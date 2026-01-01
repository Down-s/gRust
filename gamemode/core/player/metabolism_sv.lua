gRust.CreateConfigValue("player/metabolism.hunger_rate", 0.05, true)
gRust.CreateConfigValue("player/metabolism.thirst_rate", 0.05, true)

local HUNGER_RATE = gRust.GetConfigValue("player/metabolism.hunger_rate")
local THIRST_RATE = gRust.GetConfigValue("player/metabolism.thirst_rate")

-- Number of binary search iterations
local WATER_LEVEL_ACCURACY = 6

local function UpdateMetabolism(pl, delta)
    if (pl:GetMoveType() == MOVETYPE_NOCLIP || pl:GetNoDraw()) then return end

    --
    -- Hunger/Thirst
    --

    local hunger = pl:GetCalories()
    local thirst = pl:GetHydration()

    if (hunger > 0) then
        pl:SetCalories(hunger - (HUNGER_RATE * delta))
    else
        pl:Hurt(delta * 0.1)
    end

    if (thirst > 0) then
        pl:SetHydration(thirst - (THIRST_RATE * delta))
    else
        pl:Hurt(delta * 0.1)
    end

    --
    -- Wetness
    --

    local waterLevel = 0
    if (!pl.AttireProtection or !pl.AttireProtection.Waterproof) then
        if (pl:WaterLevel() == 0) then
            waterLevel = 0
        elseif (pl:WaterLevel() == 3) then
            waterLevel = 1.0
        else
            -- Binary search to find the water level
            local plPos = pl:GetPos()
            local nextCheck = 0.5
            local max = pl:EyePos().z - plPos.z
            for i = 1, WATER_LEVEL_ACCURACY do
                local checkPos = plPos + Vector(0, 0, nextCheck * max)
                local hasWater = bit.band(util.PointContents(checkPos), CONTENTS_WATER) ~= 0
                if (hasWater) then
                    waterLevel = nextCheck
                    nextCheck = nextCheck + (0.5 ^ i)
                else
                    nextCheck = nextCheck - (0.5 ^ i)
                end
            end
        end
    end

    -- changeDelta is the amount of wetness to change per second
    -- The further waterLevel is from pl:GetWetness() the faster it will change
    local changeDelta = math.max(math.abs(waterLevel * 100 - pl:GetWetness()) * delta, delta)

    pl:SetWetness(math.MoveTowards(pl:GetWetness(), waterLevel * 100, changeDelta))

    --
    -- Bleeding
    --

    local bleeding = pl:GetBleeding()
    if (bleeding > 0) then
        pl:SetBleeding(bleeding - delta)
        pl:Hurt(delta)
    end

    --
    -- Healing
    --

    local healing = pl:GetHealing()
    if (healing > 0) then
        pl:SetHealing(healing - delta)
        pl:AddHealth(delta)
    end

    --
    -- Radiation
    --

    local newRadiation = -delta
    if (pl.RadiationEntity) then
        local radiationAmount = pl.RadiationEntity:GetRadiation(pl)
        local res = hook.Run("ScalePlayerRadiation", pl, radiationAmount)
        if (res) then
            radiationAmount = res
        end

        newRadiation = newRadiation + radiationAmount * delta
    end

    if (pl:GetRadiation() > 0) then
        newRadiation = newRadiation - ((math.min(pl:GetWetness(), 50) * 0.25) * delta)
        pl:Hurt(delta)
    end

    if (newRadiation != 0) then
        pl:SetRadiation(pl:GetRadiation() + newRadiation)
    end
end

local LastThink = CurTime()
hook.Add("Think", "gRust.Metabolism", function()
    local delta = CurTime() - LastThink
    for _, pl in player.Iterator() do
        if (pl:Alive()) then
            UpdateMetabolism(pl, delta)
        end
    end

    LastThink = CurTime()
end)