--java 对渠道参数配置进行管理，并且将数据同步到redis

--连接redis
local redis = require "resty.redis"
local cache = redis.new()
local ok , err = cache.connect(cache,"192.168.59.103","6379")
cache:set_timeout(60000) --1分钟

--如果连接失败，跳转到脚本结尾
if not ok then
  ngx.log(ngx.ERR,">>>redis链接失败")

  --goto done

  return

end


--链接mysql 数据库
local mysql = require "resty.mysql"
local db, err = mysql:new()
if not db then
    ngx.say("failed to instantiate mysql: ", err)
    return
end

db:set_timeout(1000) -- 1 sec

-- or connect to a unix domain socket file listened
-- by a mysql server:
--     local ok, err, errno, sqlstate =
--           db:connect{
  --              path = "/path/to/mysql.sock",
  --              database = "ngx_test",
  --              user = "ngx_test",
  --              password = "ngx_test" }

local ok, err, errno, sqlstate = db:connect{
host = "192.168.59.103",
port = 3306,
database = "javatest",
user = "java",
password = "java",
max_packet_size = 1024 * 1024 }

if not ok then
    ngx.say("failed to connect: ", err, ": ", errno, " ", sqlstate)
    return
end

ngx.say("connected to mysql.")

--查询配置数据         db:query("select * from channel_auth order by id asc", 10)
res, err, errno, sqlstate =
    db:query("select * from channel_auth order by id asc")
if not res then
    ngx.say("bad result: ", err, ": ", errno, ": ", sqlstate, ".")
end




--配置数据同步到redis
table.foreach(res,
    function(i, v)
--[[
    res , err = cache:set(v.code.."pwd" , v.pwd)
    res , err = cache:set(v.code.."token_expire" , v.token_expire)
    res , err = cache:set(v.code.."iplist" , v.iplist)
    res , err = cache:set(v.code.."token" , v.token)

    res , err = cache:set(v.code.."ip_bind_time" , v.ip_bind_time)
    res , err = cache:set(v.code.."ip_time_out" , v.ip_time_out)
    res , err = cache:set(v.code.."connect_count" , v.connect_count)
    res , err = cache:set(v.code.."limit_bandwidth" , v.limit_bandwidth)
--]]
     res , err = cache:set(v.code.."limit_bandwidth" , v.limit_bandwidth) --主线程中调用yiled，会导致错误attempt to yield across C-call boundary

     --ngx.log(ngx.ERR,"同步配置数据"..v.code.." : "..v.iplist)

end)

--ngx.say(res[1].code)

--for code,pwd in res do
--    print(string.format("%s  %s",code,pwd))
--end
--


-- put it into the connection pool of size 100,
-- with 10 seconds max idle timeout
local ok, err = db:set_keepalive(10000, 100)
if not ok then
    ngx.say("failed to set keepalive: ", err)
    return
end

local ok,err = cache:close()

--::done::

--local ok,err = cache:close()