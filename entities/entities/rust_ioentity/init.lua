AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Initialize()
    BaseClass.Initialize(self)

    self.CurrentEnergy = 0
    self:SetInteractable(true)
end

function ENT:GetConsumption()
    return 1
end