AddCSLuaFile()

ENT.Base = "rust_container"
ENT.SelectAmount = 4
ENT.RemoveOnEmpty = true
ENT.Model = "models/environment/misc/death_bag.mdl"

DEFINE_BASECLASS("rust_container")

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("String", 2, "PlayerName")
end

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    if (SERVER) then
        timer.Simple(600, function()
            if (IsValid(self)) then
                self:Remove()
            end
        end)
    end
end

function ENT:GetInventoryName()
    return self:GetPlayerName() or "LOOT"
end

function ENT:CreateContainers()
    local function CanAcceptItem(me, item, container)
        return false
    end

    local inventory = gRust.CreateInventory(24)
    inventory:SetEntity(self)
    inventory.CanAcceptItem = CanAcceptItem

    local attire = gRust.CreateInventory(7)
    attire:SetEntity(self)
    attire.CanAcceptItem = CanAcceptItem
    
    local belt = gRust.CreateInventory(6)
    belt:SetEntity(self)
    belt.CanAcceptItem = CanAcceptItem
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    if (!self.Containers[1]) then
        self.Containers[1] = inv
        inv:SetName("Inventory")
    elseif (!self.Containers[2]) then
        self.Containers[2] = inv
        inv:SetName("Attire")
    elseif (!self.Containers[3]) then
        self.Containers[3] = inv
        inv:SetName("Belt")
    end
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("box.close")
    
    if (self.Looters and table.Count(self.Looters) == 0) then
        local shouldRemove = true
        for k, v in ipairs(self.Containers) do
            if (!v:IsEmpty()) then
                shouldRemove = false
                break
            end
        end

        if (shouldRemove) then
            self:Remove()
        end
    end
end

function ENT:CreateLootingPanel(panel)
    local containers = self.Containers
    for i = #containers, 1, -1 do
        local v = containers[i]
        local inventory = panel:Add("gRust.Inventory")
        if (v:GetSlots() == 7) then
            inventory:SetCols(7)
        end
        inventory:SetInventory(v)
        inventory:SetName(v:GetName())
        inventory:Dock(BOTTOM)
        inventory:DockMargin(0, i == 1 and 0 or 20 * gRust.Hud.Scaling, 0, 0)
    end
end