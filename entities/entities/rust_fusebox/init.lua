AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:GetPower()
    return self.Power
end

function ENT:SetPower(power)
    if (self.Power == power) then return end

    self.Power = power
    self.CardReader:SetPower(power)
    
    self:SetSkin(power and 1 or 0)
end

function ENT:OnInventoryUpdated()
    if (!self.CardReader) then return end

    local item = self.Containers[1][1]
    if (IsValid(item)) then
        local register = item:GetRegister()
        if (register:GetId() == "electric_fuse" and item:GetCondition() > 0) then
            self:SetPower(true)
        else
            self:SetPower(false)
        end
    else
        self:SetPower(false)
    end
end

gRust.CreateConfigValue("environment/fusebox.fuse_duration", 180, true)
local FUSE_DURATION = gRust.GetConfigValue("environment/fusebox.fuse_duration")

local THINK_INTERVAL = 1
function ENT:Think()
    self:NextThink(CurTime() + THINK_INTERVAL)
    local item = self.Containers[1][1]
    if (IsValid(item) and item:GetRegister():GetId() == "electric_fuse" and item:GetCondition() > 0) then
        item:SetCondition(item:GetCondition() - (THINK_INTERVAL / FUSE_DURATION))
        self.Containers[1]:SyncSlot(1)
    else
        self:SetPower(false)
    end
    
    return true
end