AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Throw()
    local pl = self:GetOwner()

    local ent = ents.Create("rust_smokebomb")
    if (!IsValid(ent)) then return end

    ent:SetModel(self.WorldModel)
    ent:SetPos(pl:EyePos() + pl:GetAimVector() * 16)
    ent:SetAngles(pl:EyeAngles() + Angle(-90, 0, 0))
    ent:SetOwner(pl)
    ent:SetOwner(pl)
    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:SetVelocity(pl:GetAimVector() * 1000)
    end
end