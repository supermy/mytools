-- 重构之后的route-form 引擎，支持各种中间件rest 查询
-- 总体分为 输入-输入参数处理 规则处理 输出-输出结果处理

local log = require "log"

local str_gsub = string.gsub
local str_lower = string.lower


local _M = {} -- 局部的变量
_M._VERSION = '1.0' -- 模块版本

local mt = { __index = _M }


function _M.new(self)
    return setmetatable({}, mt)
end


-- 输入参数处理

-- 公用方法
function _M.isempty(s)
    return s == nil or s == '' or s == ngx.null
end

--递归更新 参数jsontree，key 要求单个语句全局唯一
--values 参数jsontree
--params 传入的参数值
function setattr(values, params)
    for i, v in pairs(values) do
        --ngx.say(type(v))
        --ngx.exit(ngx.HTTP_OK);

        if (type(v) == 'string') then
            --参数值存在，赋值
            --ngx.say(cjson.encode(v))

            if (params[v]) then
                values[i] = params[v]
            end
        else
            --递归调用table
            if (type(v) == 'table') then
                setattr(v, params)
            end
        end
    end
end

--字符串拆分为数组
local function split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1) nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

--转换extjs-sort to es-sort ES能够识别的查询json
function _M.sorttojson(sortVal)

    if (not isempty(sortVal)) then
        local sortKeys = {}

        --非数组情况处理
        if (type(sortVal) == 'string') then
            --ngx.say("query 查询id参数必须赋值,必须是数组.自动转换为数组");
            sortKeys['1'] = sortVal
        else
            sortKeys = sortVal
        end

        local sortjson = '{'
        for key, val in pairs(sortKeys) do
            local sortvalue = split(val, ",")

            local sortline = '"' .. sortvalue[1] .. '": { "order":"' .. sortvalue[2] .. '"}'
            if (#sortjson == 1) then
                sortjson = sortjson .. sortline
            else
                sortjson = sortjson .. ',' .. sortline
            end
        end
        sortjson = sortjson .. '}'
        return sortjson
    end
    return ""
end

--转换extjs-filter to es-filter 参数， es能够识别的查询json
function _M.filtertoJson(filtervalue)
    local filterjson = ""
    if (not (isempty(filtervalue))) then
        local filterjsontmp = cjson.decode(filtervalue)
        filterjson = "["

        for key, val in pairs(filterjsontmp) do
            local line = '{"term": { "' .. val.field .. '": "' .. val.value .. '" }}'
            if (#(filterjson) == 1) then
                filterjson = filterjson .. line
            else
                filterjson = filterjson .. ',' .. line
            end
        end
        filterjson = filterjson .. ']'
    end
    return filterjson
end


-- get查询参数处理
local function genGetParam(args, argsp)
    --构造参数字符串
    local myargsp = ''
    --查询参数组合,获取参数值并且注入
    for keyp, valp in pairs(argsp) do
        --兼容参数是数组
        local line = ""
        if type(args[valp]) == 'table' then
            local c = 1
            for _, valpp in pairs(args[valp]) do
                if c > 1 then
                    line = line .. "&" .. keyp .. "=" .. valpp;
                else
                    line = line .. keyp .. "=" .. valpp;
                end
                c = c + 1
            end
            -- ngx.say(line)
        else
            line = keyp .. "=" .. args[valp];
        end

        if isempty(myargsp) then
            myargsp = myargsp .. line
        else
            myargsp = myargsp .. "&" .. line
        end
    end
    return myargsp
end

--处理查询规则;构造参数数组 post-data ，与查询数组 查询的地址url
--一次可以有多个查询语句 有spring-rest es-rest neo4j-rest /分为get post
--http://127.0.0.1/formroutequery?html=manage/my-treegrid&query=menures&query=users&page=0&size=3&pid=resource
--cfgDbQuery  配置的查询规则
--queryKeys 查询参数
--args url 参数数组
function _M.genQueryRules(cfgDbQuery, queryList, args, filterjson, sortjson)
    --构造查询语句
    local querys = {}
    --参数
    local params = {}
    --方法
    local mtds = {}
    --服务类型
    local servers = {} --SB-springboot/ES-elasticsearch/NEO4j-图计算


    local dckey = args["_dc"]

    --逐个处理查询语句的参数
    for key, val in pairs(queryList) do

        local query = cfgDbQuery["list"][val]
        local url = query["url"]
        local mtd = query["method"]
        local servertype = query["servertype"] --SB-springboot/ES-elasticsearch/NEO4j-图计算

        mtds[val] = mtd
        servers[val] = servertype

        --待处理的参数
        local argsp = query["param"]

        if (mtd == 'GET') then
            --构造参数字符串
            local myargsp = genGetParam(args, argsp);
            params[val] = myargsp
            querys[val] = url .. "?" .. myargsp;
        end

        if (mtd == 'POST') then
            -- method = POST 主要是支持es查询
            setattr(argsp, args) --递归更新参数数据
            params[val] = argsp
            querys[val] = url

            -- extjs for es-query
            -- 替换filter sort 字符串
            --es过滤处理
            if (servertype == 'ES') then
                local argsptext = ''
                if (not isempty(filterjson)) then
                    argsptext = str_gsub(cjson.encode(argsp), '"filterkey"', filterjson)
                end
                --es排序处理
                if (not isempty(sortjson)) then
                    argsptext = str_gsub(argsptext, '"sortkey"', sortjson)
                end
                argsp = cjson.decode(argsptext)
                params[val] = argsp
            end
        end

    end

    return querys, params, mtds,servers
end

-- 执行查询
-- queryList 查询清单语句；
-- params 查询数据；
-- mtds 查询
-- auth 认证
function _M.doQuery(queryList, params, mtds,servertypes, authorization)
    local result = {}

    local headers = {}
    --是否进行认证
    if (not isempty(authorization)) then
        headers["Authorization"] = authorization
    end

    --- 查询设置查询变量
    local http = require "resty.http"
    local httpc = http.new()

    for keyq, valq in pairs(queryList) do

        --每个查询谁请求头进行处理
        if (mtds[keyq] == 'GET') then
            headers["Content-Type"] = "application/json"
        end
        if (mtds[keyq] == 'POST') then
            headers["Content-Type"] = "application/json; charset=UTF-8;"
        end

        if (servertypes[keyq] == 'ES') then
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        end
        if (servertypes[keyq] == 'NEO4J') then
            headers["Content-Type"] = "application/json; charset=UTF-8; stream=true"
        end

        --TODO 定制查询 请求头进行处理

--        ngx.say(cjson.encode(headers));
        log.debug(cjson.encode(headers));


        local res, err
        if (mtds[keyq] == 'GET') then
            res, err = httpc:request_uri(valq, {
                method = "GET",
                headers = headers
            })
        else
            res, err = httpc:request_uri(valq, {
                method = "POST",
                body = cjson.encode(params[keyq]),
                headers = headers
            })
        end

        --触发错误信息，try catch 捕捉
        if (err) then
            error(err)
        end

        --返回查询结果List-json
        local jsonvalue = cjson.decode(res.body);
        result[keyq] = jsonvalue
    end

    return result
end

--渲染指定的模板
--htmlname 模板uri
--result 模板变量 json 格式
function _M.render(htmlname, result)
    local template = require "resty.template"

    template.render("/" .. htmlname .. ".html", {
        formvalue = result
    })
end

return _M