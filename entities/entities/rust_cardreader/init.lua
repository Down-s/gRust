AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Initialize()
    BaseClass.Initialize(self)

    local id = self:GetName()
    timer.Simple(0, function()
        for k, v in ipairs(ents.FindByClass("rust_fusebox")) do
            if (v:GetName() != id) then continue end
            self.FuseBox = v
            v.CardReader = self
        end

        for k, v in ipairs(ents.FindByClass("rust_puzzledoor")) do
            if (v:GetName() != id) then continue end
            self.Door = v
        end
    end)
end

function ENT:AcceptKeycard()
    if (!self.FuseBox:GetPower()) then return end

    self.Door:Open()
end

function ENT:GetPower()
    return self.Power
end

function ENT:SetPower(power)
    self.Power = power

    if (power) then
        self:SetSkin(1 + self.Level)
    else
        self:SetSkin(0)
    end
end

function ENT:KeyValue(key, value)
    if (key == "level") then
        self.Level = tonumber(value)
    end
end