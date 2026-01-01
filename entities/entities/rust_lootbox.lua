AddCSLuaFile()

ENT.Base = "rust_container"
ENT.SelectAmount = 4
ENT.RemoveOnEmpty = true

DEFINE_BASECLASS("rust_container")

function ENT:Initialize()
    BaseClass.Initialize(self)
    
    if (self:CreatedByMap()) then
        self:SetRespawn(true)
    end
end

function ENT:GetInventoryName()
    return "LOOT"
end

function ENT:CreateContainers()
    local main = gRust.CreateInventory(self.Slots)
    main:SetEntity(self)
    main.CanAcceptItem = function(me, item, container)
        return false
    end

    self:InsertLootTable(main)
end

function ENT:InsertLootTable(inv)
    if (self.LootTable) then
        local selectAmount = istable(self.SelectAmount) and math.random(self.SelectAmount[1], self.SelectAmount[2]) or self.SelectAmount
        local loot = gRust.SelectLootFromTable(self.LootTable, selectAmount)
        for _, v in ipairs(loot) do
            inv:InsertItem(v)
        end
    end
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("box.close")
    
    if (self.RemoveOnEmpty and self.Looters and table.Count(self.Looters) == 0) then
        local shouldRemove = true
        for k, v in ipairs(self.Containers) do
            if (!v:IsEmpty()) then
                shouldRemove = false
                break
            end
        end

        if (shouldRemove) then
            if (self:CreatedByMap() or self:GetRespawn()) then
                self:CreateRespawn()
            end

            self:Remove()
        end
    end
end