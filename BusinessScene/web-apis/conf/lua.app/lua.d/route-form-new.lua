require "try-catch"
require "switch"

local log = require "log"
local routeEngine = require "route_form"

--获取参数 合并 post 参数
local args = ngx.req.get_uri_args()
ngx.req.read_body()
local postargs = ngx.req.get_post_args();
log.debug(cjson.encode(postargs))
for k,v in pairs(postargs) do args[k] = v end
log.debug(cjson.encode(args))


local re = routeEngine:new(args)

-- 检索引擎执行
try {

    function()
        --error('oops')
        local queryList, params, mtds, servertypes = re:genQueryRules()

        local bodyvalue = re:doQuery()

        local result = re:render()
    end,

    catch {
        function(error)
            print('caught error: ' .. error)
            log.debug('caught error: ' .. error)
            ngx.say('caught error: ' .. error)
        end
    }
}
