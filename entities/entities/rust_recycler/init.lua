AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

gRust.CreateConfigValue("farming/recycle.efficiency", 0.5)
gRust.CreateConfigValue("farming/recycle.interval", 5)

ENT.Model = "models/environment/misc/recycler.mdl"

function ENT:IsLootable()
    if (!self.Looters) then return true end
    return table.Count(self.Looters) == 0
end

function ENT:OnStartLooting(pl)
    self:SetInteractText("OCCUPIED")
    self:SetInteractIcon("close")
end

function ENT:OnStopLooting(pl)
    self:SetInteractText("OPEN")
    self:SetInteractIcon("open")
end

function ENT:HasRecyclableItems()
    local inputInventory = self.Containers[1]
    for i = 1, inputInventory:GetSlots() do
        local item = inputInventory[i]
        if (!item) then continue end
        local register = item:GetRegister()
        local recipe = register:GetRecipe()
        local scrap = register:GetRecycleScrap()
        if (!recipe and !scrap) then continue end
        return true
    end

    return false
end

function ENT:RecyclerThink()
    local efficiency = gRust.GetConfigValue("farming/recycle.efficiency")
    local inputInventory = self.Containers[1]
    local outputInventory = self.Containers[2]
    for i = 1, 6 do
        local item = inputInventory[i]
        if (!item) then continue end
        local register = item:GetRegister()
        local recipe = register:GetRecipe()
        local scrap = register:GetRecycleScrap()
        if (!recipe and !scrap) then continue end
        if (register:HasCondition()) then
            efficiency = efficiency * item:GetCondition()
        end

        local amount = 1
        if (item:GetQuantity() > 1) then
            amount = math.ceil(math.min(item:GetQuantity(), register:GetStack() * 0.1))
        end

        if (amount <= 0) then continue end

        if (recipe) then
            for k, v in ipairs(recipe) do
                if (v.Item == "scrap") then continue end
                local ingredientRegister = gRust.GetItemRegister(v.Item)
                local quantity = v.Quantity / register:GetCraftAmount()
                if (quantity <= 1) then
                    if (math.random(1, 2) == 1) then continue end
                end
                
                quantity = math.Clamp(quantity * efficiency * amount, 1, ingredientRegister:GetStack())
    
                local item = gRust.CreateItem(v.Item, quantity)
                outputInventory:InsertItem(item)
            end
        end

        local scrapQuantity = math.floor((register:GetRecycleScrap() or 0) * amount)
        if (scrapQuantity > 0) then
            local scrap = gRust.CreateItem("scrap", scrapQuantity)
            outputInventory:InsertItem(scrap)
        end

        inputInventory:Remove(i, amount)
        break
    end

    if (!self:HasRecyclableItems()) then
        self:TurnOff()
    end
end

function ENT:Think()
    if (self:GetRecycling() and (self.NextRecyclerThink or 0) <= CurTime()) then
        self:RecyclerThink()
        self.NextRecyclerThink = CurTime() + gRust.GetConfigValue("farming/recycle.interval")
    end
end

function ENT:TurnOn()
    if (!self:HasRecyclableItems()) then return end
    
    self:SetRecycling(true)
    self.NextRecyclerThink = CurTime() + gRust.GetConfigValue("farming/recycle.interval")
    self.RecyclingSound = self:StartLoopingSound("farming/recycle_loop.wav")
    self:EmitSound("recycle.start")
end

function ENT:TurnOff()
    self:SetRecycling(false)
    self:StopLoopingSound(self.RecyclingSound)
    self:EmitSound("recycle.stop")
end

util.AddNetworkString("gRust.RecyclerToggle")
net.Receive("gRust.RecyclerToggle", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) or ent:GetClass() != "rust_recycler") then return end
    if (!ent.Looters[pl]) then return end

    if (ent:GetRecycling()) then
        ent:TurnOff()
    else
        ent:TurnOn()
    end
end)