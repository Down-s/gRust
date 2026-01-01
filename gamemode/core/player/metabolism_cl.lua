local function UpdateMetabolism(delta)
    local pl = LocalPlayer()
end

local LastThink = CurTime()
hook.Add("Think", "gRust.Metabolism", function()
    local delta = CurTime() - LastThink
    UpdateMetabolism(delta)

    LastThink = CurTime()
end)

--
-- Geiger counter sounds
--

local GEIGER_SOUNDS = {
    "player/geiger_low.wav",
    "player/geiger_medium.wav",
    "player/geiger_high.wav",
    "player/geiger_ultra.wav"
}

hook.Add("gRust.ConfigUpdated", "gRust.RadiationSound", function()
    local RADIATION_AMOUNT = tonumber(gRust.GetConfigValue("environment/radzone.intensity"))
    local RADIATION_FALLOFF = tonumber(gRust.GetConfigValue("environment/radzone.falloff"))
    local RADIATION_MAX = tonumber(gRust.GetConfigValue("environment/radzone.maxintensity"))
    
    local RADIATION_ULTRA_AMOUNT = 50
    
    LocalPlayer():SetSyncVarProxy("Radiation", function(pl, name, old, new)
        if (new < 1) then
            if (pl.GeigerSound) then
                pl:StopLoopingSound(pl.GeigerSound)
                pl.GeigerSound = nil
            end

            return
        end

        local geigerSound = math.floor((new / RADIATION_ULTRA_AMOUNT) * #GEIGER_SOUNDS)
        geigerSound = math.Clamp(geigerSound, 1, #GEIGER_SOUNDS)

        if (!pl.GeigerSound or pl.GeigerSoundIndex != geigerSound) then
            if (pl.GeigerSound) then
                pl:StopLoopingSound(pl.GeigerSound)
            end

            pl.GeigerSound = pl:StartLoopingSound(GEIGER_SOUNDS[geigerSound], 0.5)
            pl.GeigerSoundIndex = geigerSound
        end
    end)
end)

local MAX_RADIATION_EFFECT = 200
local ScreenEffects = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

-- Screen discoloration
hook.Add("RenderScreenspaceEffects", "gRust.Radiation", function()
    local pl = LocalPlayer()
    local radiation = pl:GetRadiation()

    if (radiation > 0) then
        local effect = math.min(radiation / MAX_RADIATION_EFFECT, 1)
        ScreenEffects["$pp_colour_colour"] = math.max(1 - effect, 0.15)
        DrawColorModify(ScreenEffects)
    end
end)

local GRAIN_MATERIAL = Material("overlays/cc_grain")
hook.Add("HUDPaint", "gRust.Radiation", function()
    -- Grain
    local pl = LocalPlayer()
    local radiation = pl:GetRadiation()
    
    if (radiation > 0) then
        local effect = radiation / MAX_RADIATION_EFFECT
        
        --surface.SetDrawColor(255, 255, 255, 255 * effect)
        --surface.SetMaterial(GRAIN_MATERIAL)
        --surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end)