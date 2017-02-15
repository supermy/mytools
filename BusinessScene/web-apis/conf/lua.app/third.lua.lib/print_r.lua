
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            ngx.say(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        ngx.say(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        ngx.say(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        ngx.say(indent.."["..pos..'] => "'..val..'"')
                    else
                        ngx.say(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                ngx.say(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        ngx.say(tostring(t).." {")
        sub_print_r(t,"  ")
        ngx.say("}")
    else
        sub_print_r(t,"  ")
    end
    ngx.say()
end