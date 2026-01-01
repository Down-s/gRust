AddCSLuaFile()

ENT.Base = "rust_container"
DEFINE_BASECLASS("rust_container")

ENT.Model = "models/deployable/stash.mdl"

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetInteractable(true)
    self:SetInteractText("OPEN")
    self:SetInteractIcon("open")

    if (self.MaxHP) then
        self:SetMaxHP(self.MaxHP)
        self:SetHP(self.MaxHP)
    end
end

function ENT:OnInventoryAttached(inv)
    if (self.ContainerIndex and self.ContainerIndex[inv:GetIndex()]) then return end

    self.Containers = self.Containers or {}
    self.Containers[#self.Containers + 1] = inv

    self.ContainerIndex = self.ContainerIndex or {}
    self.ContainerIndex[inv:GetIndex()] = #self.Containers
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
            self:CreateRespawn()
        end
    end
end