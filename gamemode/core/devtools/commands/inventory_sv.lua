local function ItemAutoComplete(cmd, argStr, args)
    if (#args > 1) then return {} end
    local searchItem = string.lower(args[1] or "")

    local items = {}
    for k, v in ipairs(gRust.GetItems()) do
        local itemId = string.lower(v)
        if (string.StartWith(itemId, searchItem)) then
            local completion = string.format("%s %s", cmd, v)
            table.insert(items, completion)
        end
    end

    table.sort(items, function(a, b)
        return string.len(a) < string.len(b)
    end)

    return items
end

concommand.Add("grust_giveitem", function(pl, cmd, args)
    local itemID = args[1]
    local amount = tonumber(args[2]) or 1
    
    pl:AddItem(gRust.CreateItem(itemID, amount), ITEM_PICKUP)
    gRust.Log(string.format("%s gave themselves %s x%d", pl:Name(), itemID, amount))
end, ItemAutoComplete, "Give yourself an item", FCVAR_CHEAT)