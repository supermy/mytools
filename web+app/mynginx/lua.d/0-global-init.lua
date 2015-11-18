cjson = require "cjson";
redis = require "resty.redis"
--lrucache = require "resty.lrucache"

local myconfig = ngx.shared.myconfig;
myconfig: set("Tom", 56)

--myconfig: set("redis-host", "192.168.59.103")
--myconfig: set("redis-port", "6379")
--
--myconfig: set("mysql-host", "192.168.59.103")
--myconfig: set("mysql-port", "3306")

--加载配置文件
local file = io.open("/usr/local/nginx/conf/lua.d/0-config.json", "r");

local content = cjson.decode(file:read("*all"));
file: close();

for name, value in pairs(content) do
  myconfig: set(name, value);
end


--判断字符串是否为空
function isempty(s)
  return s == nil or s == '' or s == ngx.null
end

--local cjson = require "cjson"

--拼接返回json字符串
function returnjson(status, desc, result)
  local data = {}
  data.status = status;
  data.desc = desc;
  data.data = result;
  local jsonvalue = cjson.encode(data);
  ngx.say(jsonvalue);
end

function returnjsonnew(status, desc, result)
  local data = {}
  data.status = status;
  data.desc = desc;
  data.data = result;
  local jsonvalue = cjson.encode(data);
  return jsonvalue;
end


function close_redis(red)
  if not red then
    return
  end
  --释放连接(连接池实现)
  local pool_max_idle_time = 10000 --毫秒
  local pool_size = 100 --连接池大小
  local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)

  if not ok then
    ngx.say("set keepalive error : ", err)
  end
end
