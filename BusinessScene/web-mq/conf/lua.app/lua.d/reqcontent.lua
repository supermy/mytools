--获取本次请求的数据，发送到MQ
local url = ngx.var.uri
local args = ngx.req.get_uri_args()
ngx.req.read_body()
local data = ngx.req.get_body_data()

ngx.ctx.data = data
ngx.ctx.url = url
ngx.ctx.args = args


local cjson = require "cjson";
local http = require "resty.http"
local httpc = http.new()
--httpc:set_timeout(500)

-- curl -i -u guest:guest -H "content-type:application/json" \
-- -XPOST -d'{"properties":{},"routing_key":"a.aa","payload":"172.17.0.1 - - [12/Sep/2016:22:57:28 +0800] \"GET /dbtest/token.jsp HTTP/1.1\" 200 317 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36\" \"-\"","payload_encoding":"string"}' \
-- http://127.0.0.1:15672/api/exchanges/%2f/ex-sync-logs/publish

local data = {}
data.properties = {};
--持久化
data.properties.deliveryMode = 2
--url 转化为匹配routekey
data.routing_key = string.gsub(url, "/", ".");

local content = {};

if (ngx.ctx.data) then
    content.content = ngx.ctx.data
else
    content.content = '无数据'
end

content.args = ngx.ctx.args
content.url = ngx.ctx.url
data.payload =  cjson.encode(content)

data.payload_encoding = 'string'

local user = 'guest'
local pass = 'guest'
local authorization = 'Basic ' .. ngx.encode_base64(user .. ':' .. pass)


local mqurl = "http://172.16.71.20:15672/api/exchanges/%2f/ex-sync-logs/publish"
local res, err = httpc:request_uri(mqurl, {
    method = "POST",
    body = cjson.encode(data),
    headers = {
        ["Authorization"] = authorization,
        ["Content-Type"] = "application/x-www-form-urlencoded",
    }
})

ngx.status = res.status
if not res then
    ngx.say("failed to request: ", err)
    return
end

local result = {}
result.req = data
result.res = res.body
--ngx.say(res.body)

--local ok, err = httpc:set_keepalive()
--if not ok then
--    ngx.say("failed to set keepalive: ", err)
--    return
--end

ngx.say(cjson.encode(result))
