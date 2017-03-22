local log = require "log"


-- Remove key k (and its value) from table t. Return a new (modified) table.
function table.removeKey(t, k)
    local i = 0
    local keys, values = {},{}
    for k,v in pairs(t) do
        i = i + 1
        keys[i] = k
        values[i] = v
    end

    while i>0 do
        if keys[i] == k then
            table.remove(keys, i)
            table.remove(values, i)
            break
        end
        i = i - 1
    end

    local a = {}
    for i = 1,#keys do
        a[keys[i]] = values[i]
    end

    return a
end

--local t = {name="swfoo", domain="swfoo.com"}
--t = table.removeKey(t, "domain")




--删除集合 k/v 中，特定的 key
function delCollectElement(text, elementName)
    --log.debug(cjson.encode(text))

    local data = cjson.decode(text)
    local result = {}

    table.foreach(data, function(i, v)    if(v[elementName]) then v=table.removeKey(v,elementName);end;log.debug(cjson.encode(v)) ; result[i] = v; end);

    return cjson.encode(result);
end




