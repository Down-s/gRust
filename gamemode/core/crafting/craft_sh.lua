local PLAYER = FindMetaTable("Player")

local MAX_WORKBENCH_DISTANCE = (5 * METERS_TO_UNITS) ^ 2
local WORKBENCH_TIERS = {
    ["rust_tier1"] = 1,
    ["rust_tier2"] = 2,
    ["rust_tier3"] = 3,
}

function PLAYER:GetWorkbenchTier()
    if (!self:CanBuild() && !self:IsInSafeZone()) then return 0 end
    
    local maxTier = 0
    for _, ent in ents.Iterator() do
        local tier = WORKBENCH_TIERS[ent:GetClass()]
        if (tier && tier > maxTier) then
            if (self:GetShootPos():DistToSqr(ent:GetPos()) > MAX_WORKBENCH_DISTANCE) then continue end

            local tr = {}
            tr.start = self:GetShootPos()
            tr.endpos = ent:GetPos()
            tr.filter = {self, ent}
            if (util.TraceLine(tr).Hit) then continue end

            maxTier = tier
        end
    end

    return maxTier
end

function PLAYER:CanCraft(id, amount)
    amount = amount or 1
    local item = gRust.GetItemRegister(id)
    if (!item:GetCraftable()) then return false end
    if (!item:GetRecipe()) then return false end
    if (item:GetResearchCost() and !self:HasBlueprint(id)) then return false end

    local tier = item:GetTier()
    if (tier && tier > 0) then
        if (tier > self:GetWorkbenchTier()) then
            return false
        end
    end

    local recipe = item:GetRecipe()
    for i = 1, #recipe do
        local item = recipe[i]
        if (!self:HasItem(item.Item, item.Quantity * amount)) then
            return false
        end
    end

    return true
end