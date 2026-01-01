local PLAYER = FindMetaTable("Player")
function PLAYER:GetSleepingBags()
    if (!self.SleepingBags) then return {} end

    local bags = {}
    for i = 1, #self.SleepingBags do
        local bag = self.SleepingBags[i]
        if (!bag) then continue end
        local ent = Entity(bag)
        if (!IsValid(ent)) then continue end
        
        bags[#bags + 1] = ent
    end
    
    return bags
end