AddCSLuaFile()

ENT.Base = "rust_base"
ENT.NoCollide = true

AccessorFunc(ENT, "Stick", "Stick")

util.PrecacheModel("models/environment/misc/loot_bag.mdl")
function ENT:Initialize()
    if (CLIENT) then return end
    local mdl = self.Item:GetRegister():GetModel()
    self:SetModel(mdl or "models/environment/misc/loot_bag.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetInteractable(true)

    self:SetCustomCollisionCheck(true)

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
        phys:SetDamping(1, 5)
    end

    timer.Simple(600, function()
        if (!IsValid(self)) then return end
        self:Remove()
    end)
end

function ENT:Interact(pl)
    if (CLIENT) then return end

    pl:AddItem(self.Item, ITEM_PICKUP)
    self:Remove()
end

function ENT:SetItem(item)
    self.Item = item
    self:SetInteractText(string.upper(item:GetRegister():GetName()))
    self:SetInteractIcon("give")
end

function ENT:GetItem()
    return self.Item
end

function ENT:PhysicsCollide(data, col)
    if (!self.Item) then return end

    if (self.Stick and data.HitEntity:IsWorld()) then
        local phys = self:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(Vector(0, 0, 0))
            phys:EnableMotion(false)
            self:SetPos(data.HitPos - data.HitNormal * 2)
        end
        return
    end

    local ent = data.HitEntity
    if (ent:GetClass() == self:GetClass()) then
        local item = self:GetItem()
        local other = ent:GetItem()
        if (item and other and item:GetIndex() == other:GetIndex()) then
            local amt = item:GetQuantity() + other:GetQuantity()
            if (amt <= item:GetRegister():GetStack()) then
                self.Item:SetQuantity(amt)
                ent:Remove()
                ent.Item = nil
            end
        end
    end

    if (data.Speed > 400) then
        if (self.ImpactSound) then
            self:EmitSound(self.ImpactSound)
        end

        if (IsValid(self.Thrower) and IsValid(ent) and (ent.gRust or ent:IsPlayer()) and ent != self:GetPhysicsAttacker()) then
            local dmg = DamageInfo()
            dmg:SetAttacker(self.Thrower)
            dmg:SetDamage(self.ThrowDamage)
            dmg:SetDamageType(DMG_CLUB)
            dmg:SetInflictor(self)

            if (ent:IsPlayer() and !self.HitPlayer) then
                self.HitPlayer = true
                hook.Run("ScalePlayerDamage", ent, HITGROUP_GENERIC, dmg)
            end

            ent:TakeDamageInfo(dmg)
        end
    end
end