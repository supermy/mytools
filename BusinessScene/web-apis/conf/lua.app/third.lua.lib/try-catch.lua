local log = require "log"

function catch(what)
    return what[1]
end

function try(what)
--    status, result = xpcall(what[1],__TRACKBACK__)
--    status, result = pcall(what[1])
    status, result = xpcall(what[1], debug.traceback)

if not status then
        what[2](result)
    end
    return result
end
--
--function __TRACKBACK__(errmsg)
--    local track_text = debug.traceback(tostring(errmsg), 6);
--    print("---------------------------------------- TRACKBACK ----------------------------------------");
--    print(track_text, "LUA ERROR");
--    print("---------------------------------------- TRACKBACK ----------------------------------------");
--    ngx.say("---------------------------------------- TRACKBACK ----------------------------------------");
--    ngx.say(track_text, "LUA ERROR");
--    ngx.say("---------------------------------------- TRACKBACK ----------------------------------------");
--
--    local exception_text = "LUA EXCEPTION\n" .. track_text;
--    return false;
--end

