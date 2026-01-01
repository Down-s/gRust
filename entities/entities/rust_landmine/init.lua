AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Touch(ent)
    if (!IsValid(ent) or !ent:IsPlayer()) then return end
    if (self.DisarmedPlayer == ent) then return end
    
    if (!IsValid(self:GetSteppedPlayer())) then
        self:EmitSound("landmine.trigger", 100);
    end
    
    self:SetSteppedPlayer(ent)
end

function ENT:EndTouch(ent)
    if (!IsValid(ent) or !ent:IsPlayer()) then return end
    
    if (self:GetSteppedPlayer() == ent) then
        self:SetSteppedPlayer(nil)
        self:Explode()
    elseif (self.DisarmedPlayer == ent) then
        self.DisarmedPlayer = nil
    end
end

function ENT:Explode()
    if (self.Exploded) then return end
    self.Exploded = true

    local pos = self:GetPos()
    local owner = self.OwnerID and player.GetBySteamID(self.OwnerID)
    self:EmitSound("landmine.explode")
    ParticleEffect("rust_big_explosion", pos, angle_zero)
    util.ScreenShake(pos, 500, 25, 1, self.ExplodeRadius * 2)
    gRust.BlastDamage(pos, self.ExplodeRadius, self.ExplodeDamage, owner, self)

    self:Remove()
end

function ENT:Interact()
    self.DisarmedPlayer = self:GetSteppedPlayer()
    self:EmitSound("landmine.trigger", 100);
    self:SetSteppedPlayer(nil)
end