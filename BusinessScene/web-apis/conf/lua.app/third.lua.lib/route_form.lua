-- 重构之后的route-form 引擎，支持各种中间件rest 查询
-- 总体分为 输入-输入参数处理 规则处理 输出-输出结果处理

-- 用lua进行面向对象的编程,声明方法和调用方法统一用冒号,对于属性的调用全部用点号

require "utils"
require "print_r"
local log = require "log"

local str_gsub = string.gsub
local str_lower = string.lower


local _M = {} -- 局部的变量
_M.__index = _M
--_M.__call = function(t, param)
--    ngx.say("Start")
--    t.Func(param)
--    ngx.say("End")
--end
_M._VERSION = '1.0' -- 模块版本



function _M:new(args)
    local temp = {}
    setmetatable(temp, _M)   --必须要有
    temp.args = args
    return temp
--    return setmetatable({}, mt)
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
function sorttojson(sortVal)

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
function filtertoJson(filtervalue)
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
function _M:genQueryRules()
    print_r(self.args)

    local args = self.args

    --构造查询语句
    local querys = {}
    --参数
    local params = {}
    --方法
    local mtds = {}
    --服务类型
    local servers = {} --SB-springboot/ES-elasticsearch/NEO4j-图计算


    --查询id q1,q2,q3
    local queryKey = args["query"]
    if (isempty(queryKey)) then
        ngx.say("query 查询id参数必须赋值");
        ngx.exit(ngx.HTTP_OK);
    end
    --查询语句key列表
    local queryList = {}
    if (type(queryKey) == 'string') then
        --ngx.say("query 查询id参数必须赋值,必须是数组.自动转换为数组");
        queryList['1'] = queryKey
    else
        queryList = queryKey
    end


    --获取查询参数 query=q1&query=q2&query=q4&PK=abc&BK=123&XXX=电路&PId=dllx0000
    local myconfig = ngx.shared.myconfig;
    local cfgDbQuery = cjson.decode(myconfig:get("cfgDbQuery"))

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

            -- 采用模板引擎对参数进行处理
            local template = require "resty.template"
            local argstring = "";
            local c = 1
            for k, v in pairs(args) do
                if c > 1 then
                    argstring=argstring..","
                end
                c = c + 1
                argstring =argstring.. k .. "=" .. v
            end

            local tempargs=string.gsub(cjson.encode(argsp), "\"{{", "{*")
            tempargs=string.gsub(tempargs, "}}\"", "*}")


--            log.debug(type(args["updated"]))
--            log.debug(args["updated"])
--            log.debug(cjson.encode(argsp))
--            log.debug(cjson.encode(args))


--           local func     = template.compile(cjson.encode(argsp))
            local func     = template.compile(tempargs)
            local realargs = func(args)
--          local realargs = template.render(cjson.encode(argsp), args)

            --local updated = args.updated
            --local data1=delCollectElement(cjson.decode(updated),'children');
            --ngx.say(cjson.encode(delCollectElement(cjson.decode(updated),'children')));


            --            ngx.say(realargs);
--            ngx.exit(ngx.HTTP_OK);

            log.debug(realargs)
            argsp = cjson.decode(realargs);

--            ngx.say(cjson.encode(realargs));
--            ngx.exit(ngx.HTTP_OK);

            setattr(argsp, args) --递归更新参数数据

            params[val] = argsp
            querys[val] = url

            -- extjs for es-query
            -- 替换filter sort 字符串
            --es过滤处理
            if (servertype == 'ES') then

                --sort
                local sortKey = args["sort"]
                --filter
                local filtervalue = args["filter"]

                local sortjson = sorttojson(sortKey)
                log.debug(sortKey)
                log.debug(sortjson)

                local filterjson = filtertoJson(filtervalue)
                log.debug(filtervalue)
                log.debug(filterjson)


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



    self.queryList = querys
        self.params = params
        self.mtds = mtds
        self.servertypes = servers
    return querys, params, mtds, servers
end

-- 执行查询
-- queryList 查询清单语句；
-- params 查询数据；
-- mtds 查询
-- auth 认证
function _M:doQuery()
    local result = {}

    local headers = {}

    local myconfig = ngx.shared.myconfig;
    local cfgDbQuery = cjson.decode(myconfig:get("cfgDbQuery"))

    --- 查询设置查询变量
    local http = require "resty.http"
    local httpc = http.new()

    for keyq, valq in pairs(self.queryList) do

        --每个查询谁请求头进行处理
        if (self.mtds[keyq] == 'GET') then
--            headers["Content-Type"] = "application/json"   q0访问出现错误；
            headers["Content-Type"] = "application/x-www-form-urlencoded"

        end
        if (self.mtds[keyq] == 'POST') then
            headers["Content-Type"] = "application/json; charset=UTF-8;"
        end

        if (self.servertypes[keyq] == 'ES') then
            --TODO 认证

            headers["Content-Type"] = "application/x-www-form-urlencoded"
        end

        if (self.servertypes[keyq] == 'NEO4J') then

            local user = cfgDbQuery["neo4j"]['username']
            local pass = cfgDbQuery["neo4j"]['password']
            --是否进行认证
            if (not isempty(user) and not isempty(pass)) then
                --    local user = 'neo4j'
                --    local pass = '123456'
                local authorization = 'Basic ' .. ngx.encode_base64(user .. ':' .. pass)
                log.debug(authorization);
                headers["Authorization"] = authorization
            end

            headers["Content-Type"] = "application/json; charset=UTF-8; stream=true"
        end

        --TODO 定制查询 请求头进行处理

        log.debug(cjson.encode(headers));
        log.debug(valq);
        log.debug(cjson.encode(self.params[keyq]));

        local res, err
        if (self.mtds[keyq] == 'GET') then
            log.debug('get');

            res, err = httpc:request_uri(valq, {
                method = "GET",
                headers = headers
            })

        else
            log.debug('post');

            res, err = httpc:request_uri(valq, {

                method = "POST",
                body = cjson.encode(self.params[keyq]),
                headers = headers
            })
        end

        --触发错误信息，try catch 捕捉
        if (err) then
            error(err)
        end

        --返回查询结果List-json
        log.debug(res.body);
        --将空table编码成数组
        cjson.encode_empty_table_as_object(false);
        local jsonvalue = cjson.decode(res.body);
        result[keyq] = jsonvalue


    end
        self.bodyvalue = result
    return result
end

--渲染指定的模板
--htmlname 模板uri
--result 模板变量 json 格式
--通过内置变量 self.args and self.bodyvalue 进行参数传递
function _M:render()

    --获取模板名称
    local htmlname = self.args['html']
    if isempty(htmlname) then
        ngx.say("html 模板引擎参数必须赋值");
        ngx.exit(ngx.HTTP_OK);
    end

    self.bodyvalue['params'] = self.args;

    local template = require "resty.template"

--    log.debug(cjson.encode(self.bodyvalue))

    template.render("/" .. htmlname .. ".html", {
        formvalue = self.bodyvalue
    })
end

return _M