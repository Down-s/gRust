ENT.Type = "brush"
ENT.Base = "base_brush"

gRust.CreateConfigValue("environment/radzone.intensity", 0.0075, true)
gRust.CreateConfigValue("environment/radzone.falloff", 0.85, true)
gRust.CreateConfigValue("environment/radzone.maxintensity", 10, true)

local RADIATION_AMOUNT = tonumber(gRust.GetConfigValue("environment/radzone.intensity"))
local RADIATION_FALLOFF = tonumber(gRust.GetConfigValue("environment/radzone.falloff"))
local RADIATION_MAX = tonumber(gRust.GetConfigValue("environment/radzone.maxintensity"))

function ENT:Initialize()
    self.Bounds = self:OBBMaxs() - self:OBBMins()
end

function ENT:GetRadiation(pl)
    local playerPos = pl:GetPos()
    local mins, maxs = self:WorldSpaceAABB()

    local leftDistance = math.abs(playerPos.x - mins.x)
    local rightDistance = math.abs(playerPos.x - maxs.x)
    local topDistance = math.abs(playerPos.y - mins.y)
    local bottomDistance = math.abs(playerPos.y - maxs.y)

    local xDistance = math.min(leftDistance, rightDistance)
    local yDistance = math.min(topDistance, bottomDistance)
    
    local distance = math.min(xDistance, yDistance)
    local radiation = RADIATION_AMOUNT * (distance * 1 / RADIATION_FALLOFF)
    return math.Clamp(radiation, 0, RADIATION_MAX)
end

function ENT:StartTouch(pl)
    if (!pl:IsPlayer()) then return end
    pl.RadiationEntity = self
end

function ENT:EndTouch(pl)
    if (!pl:IsPlayer()) then return end
    pl.RadiationEntity = nil
end