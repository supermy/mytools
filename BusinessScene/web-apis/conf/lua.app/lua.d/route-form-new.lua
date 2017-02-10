require "try-catch"
require "switch"

local log = require "log"
local routeEngine = require "route_form"
local re = routeEngine:new(1, 2)

--获取参数
local args = ngx.req.get_uri_args()


-- 检索引擎执行
try {
    function()
        --error('oops')

        local queryList, params, mtds, servertypes = re.genQueryRules(args)

        log.debug(cjson.encode(queryList))
        log.debug(cjson.encode(params))
        log.debug(cjson.encode(mtds))
        log.debug(cjson.encode(servertypes))

        local bodyvalue = re.doQuery(queryList,params, mtds,servertypes)

        log.debug(cjson.encode(bodyvalue))
        local result = re.render(args, bodyvalue)
    end,
    catch {
        function(error)
            print('caught error: ' .. error)
            log.debug('caught error: ' .. error)
            ngx.say('caught error: ' .. error)
        end
    }
}
--http://127.0.0.1/formroutenew?html=route-neo4j-json&query=neo4jsimple&namevalue=%E5%9C%B0%E5%8C%BA&_dc=1467884593669&sort=name%2CASC&sort=code%2CDESC&page=0&filter=[{%22type%22:%22string%22,%22value%22:%22test%22,%22field%22:%22name%22},{%22type%22:%22string%22,%22value%22:%22test%22,%22field%22:%22code%22}]&start=0&size=23

try {
    function()
        local PLAYER = {}
        PLAYER['sk'] = 0
        PLAYER['st'] = 0
        local slotname = 'str'
        switch(string.lower(slotname), {
            {
                "", "sk", function(_)
                PLAYER.sk = PLAYER.sk + 1
            end
            },
            {
                "in", { "str", "int", "agl", "cha", "lck", "con", "mhp", "mpp" }, function(_)
                PLAYER.st = PLAYER.st + 1
            end
            },
            { "default", "", function(_) end } --ie, do nothing
        })

--        log.debug(cjson.encode(PLAYER))
        log.debug(cjson.encode(PLAYER))

    end,
    catch {
        function(error)
            print('caught error: ' .. error)
            ngx.say('caught error: ' .. error)
        end
    }
}