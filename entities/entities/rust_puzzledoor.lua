AddCSLuaFile()

DEFINE_BASECLASS("rust_door")

ENT.Base = "rust_door"

ENT.Model = "models/darky_m/rust/puzzle/door.mdl"

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self.InitialRotation = self:GetAngles().y
    self.Shut = true
end

function ENT:Open()
    BaseClass.Open(self)

    self.CloseTime = CurTime() + 5
end

function ENT:Think()
    BaseClass.Think(self)

    if (self.CloseTime and self.CloseTime <= CurTime()) then
        self:Close()
        self.CloseTime = nil
    end

    return true
end

function ENT:CanOpen(pl)
    return false
end

function ENT:GetOpenSound()
    return "doors/door_metal_open.wav"
end

function ENT:GetCloseSound()
    return "doors/door_metal_close.wav"
end

function ENT:GetShutSound()
    return "doors/door_metal_shut.wav"
end

function ENT:GetKnockSound()
    return string.format("doors/door_knock_metal_%i.wav", math.random(1, 2))
end