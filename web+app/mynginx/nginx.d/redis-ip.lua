ip_bind_time = 300  --封禁IP时间
ip_time_out = 60    --指定ip访问频率时间段
connect_count = 100 --指定ip访问频率计数最大值

--连接redis
local redis = require "resty.redis"
local cache = redis.new()
local ok , err = cache.connect(cache,"192.168.59.103","6379")
cache:set_timeout(60000)

--如果连接失败，跳转到脚本结尾
if not ok then
  goto A
end

--查询ip是否在封禁段内，若在则返回403错误代码
--因封禁时间会大于ip记录时间，故此处不对ip时间key和计数key做处理
is_bind , err = cache:get("bind_"..ngx.var.remote_addr)
if is_bind == 1 then
  ngx.exit(403)
  goto A
end

start_time , err = cache:get("time_"..ngx.var.remote_addr)
ip_count , err = cache:get("count_"..ngx.var.remote_addr)

--如果ip记录时间大于指定时间间隔或者记录时间或者不存在ip时间key则重置时间key和计数key
--如果ip时间key小于时间间隔，则ip计数+1，且如果ip计数大于ip频率计数，则设置ip的封禁key为1
--同时设置封禁key的过期时间为封禁ip的时间
if start_time == ngx.null or os.time() - start_time > ip_time_out then
  res , err = cache:set("time_"..ngx.var.remote_addr , os.time())
  res , err = cache:set("count_"..ngx.var.remote_addr , 1)
else
  ip_count = ip_count + 1
  res , err = cache:incr("count_"..ngx.var.remote_addr)
  if ip_count >= connect_count then
    res , err = cache:set("bind_"..ngx.var.remote_addr,1)
	res , err = cache:expire("bind_",ip_bind_time)
  end
end

--结尾标记
::A::
local ok, err = cache:close()