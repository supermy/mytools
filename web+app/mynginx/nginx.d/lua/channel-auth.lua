--[[
    认证通过之后分配的ctoken与使用者的IP 关联；
    渠道和个人用户都可以使用；
--]]

--判断字符串是否为空
local function isempty(s)
  return s == nil or s == ''  or  s == ngx.null
end


--从head or cookie 获取参数值
--[[local function getHCValue(key)
    local value1 = ngx.req.get_headers()[key]

    if isempty(value1) then
        local cookie_name = key
        local var_name = "cookie_" .. cookie_name
        local value1 = ngx.var[var_name]
    end
    ngx.log(ngx.ERR,value1)

    return value1
end
]]


--支撑head或者cookie 获取参数;
--java 对渠道参数配置进行管理，并且将数据同步到redis

--环境初始化
--默认全局封禁时间，每秒访问次数，统计时间段；从redis 取渠道设置的阀值

ip_bind_time = 300  --封禁IP时间,300秒
ip_time_out = 60    --指定ip访问频率时间段,60秒
connect_count = 100 --指定ip访问频率计数最大值,100次/分钟

local myconfig = ngx.shared.myconfig
local redis_host=myconfig:get("redis-host")
local redis_port=myconfig:get("redis-port")

--连接redis
local redis = require "resty.redis"
local cache = redis.new()
local ok , err = cache.connect(cache,redis_host,redis_port)
cache:set_timeout(60000) --1分钟

--如果连接失败，跳转到脚本结尾
if not ok then
  ngx.log(ngx.ERR,">>>redis链接失败")

  --goto authdone

  local ok,err = cache:close()
  return

end


--验证渠道与ip 地址是否一致
local myIp = ngx.req.get_headers()["X-Real-IP"]
if isempty(myIp) then
  myIp = ngx.req.get_headers()["x_forwarded_for"]
end
if isempty(myIp) then
  myIp=ngx.var.remote_addr
end
if isempty(myIp) then

    ngx.log(ngx.ERR,"没有获取到ip 地址")
    ngx.say("没有获取到ip 地址");
    ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

    --goto authdone

    local ok,err = cache:close()
    return
  --ngx.exit(403)
end

--:::::::::::::::::::::
--所有的操作都进行并发控制；
--查询ip是否在封禁段内，若在则返回403错误代码
--因封禁时间会大于ip记录时间，故此处不对ip时间key和计数key做处理
is_bind , err = cache:get("bind_"..ngx.var.remote_addr)

ngx.log(ngx.ERR,is_bind == '1')

if is_bind == '1' then
    ngx.log(ngx.ERR,">>>redis封禁......")

    ngx.say("ip 地址已经被封禁");
    --ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);
    ngx.exit(403)

    --goto authdone

    local ok,err = cache:close()
    return
end

start_time , err = cache:get("time_"..ngx.var.remote_addr)
ip_count , err = cache:get("count_"..ngx.var.remote_addr)

--如果ip记录时间大于指定时间间隔或者记录时间或者不存在ip时间key则重置时间key和计数key
--如果ip时间key小于时间间隔，则ip计数+1，且如果ip计数大于ip频率计数，则设置ip的封禁key为1
--同时设置封禁key的过期时间为封禁ip的时间

if start_time == ngx.null or os.time() - start_time > ip_time_out then

  ngx.log(ngx.ERR,">>>设置初始值" .. ngx.var.remote_addr)

  res , err = cache:set("time_"..ngx.var.remote_addr , os.time())
  res , err = cache:set("count_"..ngx.var.remote_addr , 1)
else


  ip_count = ip_count + 1

  ngx.log(ngx.ERR,">>>计数" .. ip_count)

  res , err = cache:incr("count_"..ngx.var.remote_addr)
  if ip_count >= connect_count then

    ngx.log(ngx.ERR,">>>设置为封禁" .. ngx.var.remote_addr)

    res , err = cache:set("bind_"..ngx.var.remote_addr,1)
    --设置生存时间 300 秒
	res , err = cache:expire("bind_"..ngx.var.remote_addr,ip_bind_time)
  end
end




--设置ctoken 数据
--telnet 192.168.59.103 6379/monitor/keys */set aa6f21ec0fcf008aa5250904985a817b 192.168.59.3/get aa6f21ec0fcf008aa5250904985a817b
--curl -v -b "ctoken=testf97a93b6e5e08843a7c825a53bdae246" http://192.168.59.103/api
--ab -n 5000 -c 200  -C ctoken=testf97a93b6e5e08843a7c825a53bdae246 http://192.168.59.103/api
--如果已经动态分配ctoken,token 与IP 地址绑定；验证token 的有效性；则不进行认证,直接进行能力管控
ctoken = ngx.req.get_headers()["ctoken"]
if isempty(ctoken) then
    ctoken = ngx.var.cookie_ctoken
end

--ctoken1=getHCValue("ctoken")
--ngx.log(ngx.ERR,ctoken1)


--验证ctoken 在有效期内，跳过认证流程;不在有效期，继续认证流程；
if not isempty(ctoken) then
  ctokenok , err = cache:get(ctoken)
  ngx.log(ngx.ERR,ctokenok)
  ngx.log(ngx.ERR,myIp)

  if ctokenok == myIp then

    ngx.log(ngx.ERR,">>>ctoken 有效，不再进行渠道认证......")

    --goto authdone --跳过认证

    local ok,err = cache:close()
    return

  else

    ngx.say("无效的令牌");
    ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

  end
end


--进行认证

--获取从head 或者cookie 中渠道编码code/渠道秘钥-动态生成  ab -C 会更改cookie 的名称
--curl -v -b "ChannelCode=test;ChannelSecretkey=a8152b13f4ef9daca84cf981eb5a7907"  http://192.168.59.103/api
--mysql2redis.sh 同步数据
--ab -n 5000 -c 200 -H "Cookie:ChannelCode=test;ChannelSecretkey=a8152b13f4ef9daca84cf981eb5a7907"   http://192.168.59.103/api
channel_code = ngx.req.get_headers()["ChannelCode"]
channel_secretkey = ngx.req.get_headers()["ChannelSecretkey"]

if isempty(channel_code) then
    channel_code = ngx.var.cookie_ChannelCode
end

if isempty(channel_secretkey) then
    channel_secretkey = ngx.var.cookie_ChannelSecretkey
end

if isempty(channel_code)  or isempty(channel_secretkey) then

      ngx.log(ngx.ERR,"传递的参数不全，或者名称不对")

      --ngx.header.content_type = "application/json; charset=UTF-8";

      ngx.say("请仔细检查传递的参数");
      ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

      --ngx.exit(403)

      --goto authdone

      local ok,err = cache:close()
      return

end


---telnet 192.168.59.103 6379/monitor/keys */set 1234ip_bind_time 300/set 1234ip_time_out 60 /set 1234connect_count 100
---set 1234pwd 111111/set 1234iplist 192.168.59.3/set 1234token_expire 1/
--设置渠道的封禁时间，访问频率和统计时间段
--注意数字和字符串类型
if not isempty(channel_code) then
    --渠道带宽控制

    local channel_ip_bind_time , err = cache:hget("hash_"..channel_code,"ip_bind_time")
    local channel_ip_time_out ,  err = cache:hget("hash_"..channel_code,"ip_time_out")
    local channel_connect_count ,err = cache:hget("hash_"..channel_code,"connect_count")

    local channel_pwd ,err = cache:hget("hash_"..channel_code,"pwd") --秘钥盐渍
    local channel_iplist ,err = cache:hget("hash_"..channel_code,"iplist") --渠道ip 地址
    local channel_token ,err = cache:hget("hash_"..channel_code,"token") --渠道令牌
    local channel_token_expire ,err = cache:hget("hash_"..channel_code,"token_expire") --渠道有效期


    --ngx.log(ngx.ERR,channel_connect_count)
    ngx.log(ngx.ERR,channel_connect_count == ngx.null)

    if isempty(channel_ip_bind_time)  or isempty(channel_ip_time_out) or isempty(channel_connect_count)
        or isempty(channel_pwd) or isempty(channel_iplist) or isempty(channel_token) or isempty(channel_token_expire) then

        ngx.log(ngx.ERR,"渠道号没有生效")
        ngx.say("渠道号没有生效");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

    else
        ip_bind_time=channel_ip_bind_time
        ip_time_out=channel_ip_time_out
        connect_count=channel_connect_count

    end

    _ , q = string.find(channel_iplist , myIp )
    if isempty(q) then

        ngx.log(ngx.ERR,"实际ip 地址与渠道设置的ip 地址不匹配")

        ngx.say("实际ip 地址与渠道设置的ip 地址不匹配");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);
        --ngx.exit(403)
        --goto authdone

        local ok,err = cache:close()
        return

    end

    --验证秘钥 是否有效
    local server_secretkey = ngx.md5( channel_code .. myIp .. channel_pwd)
    ngx.log(ngx.ERR,"server秘钥"..server_secretkey)

    if channel_secretkey ~= server_secretkey then

        ngx.log(ngx.ERR,"秘钥不匹配")

        ngx.say("秘钥不匹配");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

        --ngx.exit(403)
        --goto authdone

        local ok,err = cache:close()
        return

    end

    --给渠道返回一个token,有效期
    local ctoken = ngx.md5( channel_code .. myIp .. channel_pwd .. os.time())
    res , err = cache:set(channel_code .. ctoken,myIp)

    --设置生存时间 天数转换为秒
    res , err = cache:expire(channel_code .. ctoken,channel_token_expire*60*60*60)

    ngx.log(ngx.ERR,"新的令牌"..ctoken.."，有效期：" .. channel_token_expire*60*60*60)

    --tokenvalue = "{status:200,message:ok,ctoken:"..ctoken..",expire:" .. channel_token_expire*60*60*60 .. "}"

    --ngx.say(tokenvalue);

    --local cjson = require "cjson"
    local data = {}
        data.message= "ok";
        data.status=200;
        data.ctoken=ctoken;
        data.token_expire=channel_token_expire*60*60*60;
        data.attachment={}

    local jsonvalue=cjson.encode(data);

    ngx.say(jsonvalue);


    ngx.exit(ngx.HTTP_OK);

    --goto authdone
    local ok,err = cache:close()
    return

end


--认证完成，下面是进行并发控制
--::authdone::
--local ok,err = cache:close()

