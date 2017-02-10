local str_find = string.find

function switch(term, cases)
    assert(type(cases) == "table")
    local casetype, caseparm, casebody
    for i,case in ipairs(cases) do
        assert(type(case) == "table" and #case == 3)
        casetype,caseparm,casebody = case[1],case[2],case[3]
        assert(type(casetype) == "string" and type(casebody) == "function")
        if
        (casetype == "default")
                or  ((casetype == "eq" or casetype=="") and caseparm == term)
                or  ((casetype == "!eq" or casetype=="!") and not caseparm == term)
                or  (casetype == "in" and has_value(term, caseparm))
                or  (casetype == "!in" and not has_value(term, caseparm))
                or  (casetype == "range" and range(term, caseparm))
                or  (casetype == "!range" and not range(term, caseparm))
        then
            return casebody(term)
        else if
        (casetype == "default-fall")
                or  ((casetype == "eq-fall" or casetype == "fall") and caseparm == term)
                or  ((casetype == "!eq-fall" or casetype == "!-fall") and not caseparm == term)
                or  (casetype == "in-fall" and has_value(term, caseparm))
                or  (casetype == "!in-fall" and not has_value(term, caseparm))
                or  (casetype == "range-fall" and range(term, caseparm))
                or  (casetype == "!range-fall" and not range(term, caseparm))
        then
            casebody(term)
        end end
    end
end

function has_value (val, tab)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end