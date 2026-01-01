ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Model = "models/environment/spinner_wheel_casino.mdl"

ENT.Deceleration = 45

ENT.WinTypes = {
    [1] = {
        number = 1,
        multiplier = 2,
    },
    [2] = {
        number = 3,
        multiplier = 3,
    },
    [3] = {
        number = 5,
        multiplier = 5,
    },
    [4] = {
        number = 10,
        multiplier = 10,
    },
    [5] = {
        number = 20,
        multiplier = 20,
    }
}

ENT.Segments = "5121312141213132141213121"

if (SERVER) then
    gRust.CreateConfigValue("casino/roulette.interval", 40)
end

local SPIN_INTERVAL = gRust.GetConfigValue("casino/roulette.interval", 40)
local MAX_BOX_DIST = 8192^2

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "NextSpin")
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetNextSpin(CurTime() + SPIN_INTERVAL)
    
    self.CasinoBoxes = {}

    timer.Simple(0, function()
        if (!IsValid(self)) then return end

        local entities = ents.FindByClass("rust_casinobox")
        for i = 1, #entities do
            local ent = entities[i]
            if (ent:GetPos():DistToSqr(self:GetPos()) > MAX_BOX_DIST) then continue end
            if (self:CreatedByMap() != ent:CreatedByMap()) then continue end
            
            self.CasinoBoxes[#self.CasinoBoxes + 1] = ent
            ent.CasinoWheel = self
        end
    end)
end

function ENT:GetInitialSpeed(angle)
    local speed = math.sqrt(2 * self.Deceleration * angle)
    return speed
end

function ENT:GetAngleAtTime(time, initialSpeed)
    local angle = initialSpeed * time - 0.5 * self.Deceleration * time^2
    return -angle
end

-- Rearranged derivative of GetAngleAtTime at time = 0
-- This is the point where the wheel would change spin direction due to deceleration
function ENT:GetEndTime(initialSpeed)
    local time = initialSpeed / self.Deceleration
    return time
end

function ENT:GetSegment(angle)
    local segments = #self.Segments
    local segmentSize = 360 / segments

    angle = (angle + (segmentSize * 0.5)) % 360
    local segment = math.floor(angle / segmentSize) + 1

    return segment
end