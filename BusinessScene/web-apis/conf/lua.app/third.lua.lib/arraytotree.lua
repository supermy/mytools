--data 是数组
--local data=formvalue[formvalue.params.query].results[1].data[1].row[1]
--require "arraytotree"
--ngx.say(cjson.encode(arraytotree(data)));
--默认增加 id and parent_id 属性
function arraytotree(data,sourceId,sourcePId,childname)

    --为所有的节点建立 children
    --首先建立 children 集合
    --最后输出顶级节点
    --节点 ID,data.group_id; 父级节点 ID data.pid

    --ngx.say(cjson.encode(data))
    --转换为 k/v 节点
    local nodes={}
    for kline, line in pairs(data) do
        local id = line[sourceId]
        line['id'] = id
        nodes[id] = line
    end


    --建立 childrend 节点
    for kline, line in pairs(nodes) do
        local pid = line[sourcePId]
        line['parent_id']=pid

        local parent = nodes[pid]

        if (parent)  then
            --line['parent']=parent
            local children=parent[childname]
            if (children) then
                table.insert (parent[childname], line)
            else
                parent[childname]={}
                table.insert (parent[childname], line)
            end
        else
            line['isroot']=true
        end
    end



    --支持多根节点输出
    local result ={}
    for kline, line in pairs(nodes) do
        if(line.isroot) then
            table.insert (result, line)
        end
    end

    return result
end