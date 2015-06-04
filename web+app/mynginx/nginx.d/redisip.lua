local function isempty(s)
  return s == nil or s == ''
end

--支撑head或者cookie 获取参数

--环境初始化
--默认全局封禁时间，每秒访问次数，统计时间段；从redis 取渠道设置的阀值

ip_bind_time = 300  --封禁IP时间,300秒
ip_time_out = 60    --指定ip访问频率时间段,60秒
connect_count = 100 --指定ip访问频率计数最大值,100次/分钟


--连接redis
local redis = require "resty.redis"
local cache = redis.new()
local ok , err = cache.connect(cache,"192.168.59.103","6379")
cache:set_timeout(60000) --1分钟

--如果连接失败，跳转到脚本结尾
if not ok then
  ngx.log(ngx.ERR,">>>redis链接失败")

  goto done

end


--验证渠道与ip 地址是否一致
myIp = ngx.req.get_headers()["X-Real-IP"]
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

    goto done
  --ngx.exit(403)
end


--设置ctoken 数据
--telnet 192.168.59.103 6379/monitor/keys */set aa6f21ec0fcf008aa5250904985a817b 192.168.59.3/get aa6f21ec0fcf008aa5250904985a817b
--curl -v -b "ctoken=aa6f21ec0fcf008aa5250904985a817b"  http://192.168.59.103/hello
--如果已经动态分配ctoken,token 与IP 地址绑定；验证token 的有效性；则不进行认证,直接进行能力管控
ctoken = ngx.req.get_headers()["ctoken"]
if isempty(ctoken) then
    ctoken = ngx.var.cookie_ctoken
end

--验证ctoken 在有效期内，跳过认证流程;不在有效期，继续认证流程；
if not isempty(ctoken) then
  ctokenok , err = cache:get(ctoken)
  ngx.log(ngx.ERR,ctokenok)
  ngx.log(ngx.ERR,myIp)

  if ctokenok == myIp then

    ngx.log(ngx.ERR,">>>ctoken 有效，不再进行渠道认证......")

    goto authdone --跳过认证
  else

    ngx.say("无效的令牌");
    ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

  end
end


--进行认证

--获取从head 或者cookie 中渠道编码code/渠道秘钥-动态生成
--curl -v -b "channelCode=1234;ChannelSecretkey=aa6f21ec0fcf008aa5250904985a817b"  http://192.168.59.103/hello1
channel_code = ngx.req.get_headers()["ChannelCode"]
channel_secretkey = ngx.req.get_headers()["ChannelSecretkey"]

if isempty(channel_code) then
    channel_code = ngx.var.cookie_ChannelCode
    ngx.log(ngx.DEBUG,">>>channel_code:" .. channel_code)

end
if isempty(channel_secretkey) then
    channel_secretkey = ngx.var.cookie_ChannelSecretkey
    ngx.log(ngx.DEBUG,">>>channel_secretkey:" .. channel_secretkey)
end

if isempty(channel_code)  or isempty(channel_secretkey) then

      ngx.log(ngx.WARN,"传递的参数不全，或者名称不对")

      --ngx.header.content_type = "application/json; charset=UTF-8";

      ngx.say("请仔细检查传递的参数");
      ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

      --ngx.exit(403)

      goto done
end


--设置渠道的封禁时间，访问频率和统计时间段
--注意数字和字符串类型
if not isempty(channel_code) then
    --渠道带宽控制
    ip_bind_time , err = cache:get(channel_code.."ip_bind_time")
    ip_time_out ,  err = cache:get(channel_code.."ip_time_out")
    connect_count ,err = cache:get(channel_code.."connect_count")

    local channel_pwd ,err = cache:get(channel_code.."pwd") --秘钥盐渍
    local channel_iplist ,err = cache:get(channel_code.."iplist") --渠道ip 地址
    local channel_token ,err = cache:get(channel_code.."token") --渠道令牌
    local channel_token_expire ,err = cache:get(channel_code.."token_expire") --渠道有效期

    if not ip_bind_time  or not ip_time_out or not connect_count
       or not channel_pwd or not channel_iplist or not channel_token or not channel_token_expire then

        ngx.log(ngx.ERR,"渠道号没有是生效")
        ngx.say("渠道号没有生效");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

    end

    _ , q = string.find(channel_iplist , myIp )
    if q <= 0 then
      ngx.log(ngx.ERR,"实际ip 地址与渠道设置的ip 地址不匹配")

        ngx.say("实际ip 地址与渠道设置的ip 地址不匹配");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);
        --ngx.exit(403)
        goto done
    end

    --验证秘钥 是否有效
    local server_secretkey = ngx.md5( channel_code .. myIp .. channel_pwd)
    if channel_secretkey ~= server_secretkey then

        ngx.log(ngx.WARN,"秘钥不匹配")

        ngx.say("秘钥不匹配");
        ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);

        --ngx.exit(403)
        goto done
    end

    --给渠道返回一个token,有效期
    local ctoken = ngx.md5( channel_code .. myIp .. channel_pwd .. os.time())
    res , err = cache:set(channel_code .. ctoken,myIp)
    --设置生存时间 天数转换为秒
    res , err = cache:expire(channel_code .. ctoken,channel_token_expire*60*60*60)

    ngx.say("新的令牌，有效期：" .. channel_token_expire*60*60*60);
    ngx.exit(ngx.HTTP_OK);

    goto done

end

--认证完成，下面是进行并发控制
::authdone::

--查询ip是否在封禁段内，若在则返回403错误代码
--因封禁时间会大于ip记录时间，故此处不对ip时间key和计数key做处理
is_bind , err = cache:get("bind_"..ngx.var.remote_addr)
ngx.log(ngx.ERR,is_bind == '1')

if is_bind == '1' then
    ngx.log(ngx.INFO,">>>redis封禁......")

    ngx.say("ip 地址已经被封禁");
    --ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE);
    ngx.exit(403)

    goto done

end

start_time , err = cache:get("time_"..ngx.var.remote_addr)
ip_count , err = cache:get("count_"..ngx.var.remote_addr)

--如果ip记录时间大于指定时间间隔或者记录时间或者不存在ip时间key则重置时间key和计数key
--如果ip时间key小于时间间隔，则ip计数+1，且如果ip计数大于ip频率计数，则设置ip的封禁key为1
--同时设置封禁key的过期时间为封禁ip的时间

if start_time == ngx.null or os.time() - start_time > ip_time_out then

  ngx.log(ngx.WARN,">>>设置初始值" .. ngx.var.remote_addr)

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

::done::
local ok,err = cache:close()
