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