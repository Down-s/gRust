function util.XmlToTable(xml)
    local stack = {}
    local res = {}
    
    local tags = string.gmatch(xml, "<[^>]+>")
    for tag in tags do
        local name = string.match(tag, "<(/?[^%s>/]+)")
        local closing = string.sub(name, 1, 1) == "/"

        local props = {}
        for k, v in string.gmatch(tag, [[([^%s=]+)="([^"%s>]+)]]) do
            props[k] = v
        end
        
        if (!closing) then
            table.insert(stack, {
                name = name,
                props = props,
                children = {}
            })
        else
            local top = table.remove(stack)
            if (top.name != string.sub(name, 2)) then
                error("Invalid XML")
            end

            if (#stack == 0) then
                table.insert(res, top)
            else
                table.insert(stack[#stack].children, top)
            end
        end
    end
    
    return res
end