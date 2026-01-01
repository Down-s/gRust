gRust.Hud = gRust.Hud or {}

local Margin
local IconPadding
local IconOffset

local round = math.Round
local function UpdateHudVars()
    gRust.Hud.ScalingInfluence = 0.0 -- 0 = ScrW(), 1 = ScrH()
    gRust.Hud.AspectRatio = ScrW() / ScrH()
    gRust.Hud.Scaling = (ScrH() / 1440) * gRust.Hud.ScalingInfluence + (1 - gRust.Hud.ScalingInfluence) * ScrW() / 2560
    gRust.Hud.Margin = round(32 * gRust.Hud.Scaling)
    gRust.Hud.SlotSize = round(120 * gRust.Hud.Scaling)
    gRust.Hud.SlotPadding = round(8 * gRust.Hud.Scaling)
    gRust.Hud.BarWidth = round(384 * gRust.Hud.Scaling)
    gRust.Hud.BarHeight = round(52 * gRust.Hud.Scaling)
    gRust.Hud.BarPadding = round(6 * gRust.Hud.Scaling)
    gRust.Hud.BarSpacing = round(4 * gRust.Hud.Scaling)
    gRust.Hud.ShadowOffset = round(2 * gRust.Hud.Scaling)
    gRust.Hud.ShouldDraw = gRust.Hud.ShouldDraw != false

    Margin = gRust.Hud.Margin
    IconPadding = round(10 * gRust.Hud.Scaling)
    IconOffset = round(-2 * gRust.Hud.Scaling)
end

hook.Add("OnScreenSizeChanged", "gRust.Hud.OnScreenSizeChanged", UpdateHudVars)
UpdateHudVars()

gRust.Hud.ShouldDraw = true

--
-- Hud
--

gRust.Hud.Bars = {
    {
        icon = "hunger",
        color = Color(198, 110, 47, 175),
        value = function() return math.ceil(math.max(LocalPlayer():GetCalories(), 0)) end,
        max = 500,
    },
    {
        icon = "water",
        color = Color(69, 149, 205),
        value = function() return math.ceil(math.max(LocalPlayer():GetHydration(), 0)) end,
        max = 250,
    },
    {
        icon = "health",
        color = Color(140, 186, 59, 150),
        value = function() return math.ceil(math.max(LocalPlayer():Health(), 0)) end,
        max = 100,
        background = {
            color = Color(140, 186, 59, 75),
            value = function() return math.min(math.ceil(LocalPlayer():Health()) + math.ceil(LocalPlayer():GetHealing()), LocalPlayer():GetMaxHealth()) end,
            max = 100,
        }
    }
}

local IconColor = Color(190, 180, 170, 150)
local TextColor = ColorAlpha(gRust.Colors.Text, 215)
local ShadowColor = Color(0, 0, 0, 100)
function GM:PostRenderVGUI()
    if (!LocalPlayer():Alive()) then return end
    if (!gRust.Hud.ShouldDraw) then return end
    
    if (IsValid(g_VoicePanelList)) then
        g_VoicePanelList:Remove()
    end

    local BarWidth, BarHeight = gRust.Hud.BarWidth, gRust.Hud.BarHeight
    local BarPadding, BarSpacing = gRust.Hud.BarPadding, gRust.Hud.BarSpacing
    local ShadowOffset = gRust.Hud.ShadowOffset
    local HudBars = gRust.Hud.Bars

    for i = 1, #HudBars do
        local data = HudBars[i]
        local x = ScrW() - Margin - gRust.Hud.BarWidth
        local y = (ScrH() - Margin - (gRust.Hud.BarHeight + gRust.Hud.BarSpacing) * i) + gRust.Hud.BarSpacing

        gRust.DrawPanel(x, y, gRust.Hud.BarWidth, gRust.Hud.BarHeight, data.color)

        local icon = gRust.GetIcon(data.icon)
        local iconX = x + IconPadding + IconOffset
        local iconY = y + IconPadding
        
        surface.SetDrawColor(ShadowColor)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(iconX + ShadowOffset, iconY + ShadowOffset, BarHeight - IconPadding * 2, BarHeight - IconPadding * 2)

        surface.SetDrawColor(IconColor)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(iconX, iconY, BarHeight - IconPadding * 2, BarHeight - IconPadding * 2)
        
        local value = data.value()
        local frac = value / data.max

        if (data.background) then
            local value = data.background.value()
            local frac = value / data.background.max

            gRust.DrawPanelColored(x + BarHeight + IconOffset, y + BarPadding, (BarWidth - BarHeight - BarPadding) * frac, BarHeight - BarPadding * 2, data.background.color)
        end

        -- Draw the bar
        --surface.SetDrawColor(data.color)
        --surface.DrawRect(x + BarHeight + IconOffset, y + BarPadding, (BarWidth - BarHeight - BarPadding) * frac, BarHeight - BarPadding * 2)
        gRust.DrawPanelColored(x + BarHeight + IconOffset, y + BarPadding, (BarWidth - BarHeight - BarPadding) * frac, BarHeight - BarPadding * 2, data.color)

        local textX = x + BarHeight + 10
        local textY = y + BarHeight / 2
        draw.SimpleText(value, "gRust.32px", textX + ShadowOffset, textY + ShadowOffset, ShadowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(value, "gRust.32px", textX, textY, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

local function DrawVoiceIndicator()
    local pl = LocalPlayer()
    if (!pl:Alive()) then return end
    if (!pl:IsSpeaking()) then return end

    local scaling = gRust.Hud.Scaling
    local size = math.Round(108 * scaling)

    local x = ScrW() * 0.5 - size * 0.5
    local y = size

    surface.SetDrawColor(61, 79, 29)
    surface.DrawRect(x, y, size, size)

    surface.SetDrawColor(141, 182, 28)
    -- TODO: Find a way to make this work
    -- if (LocalPlayer():VoiceVolume() > 0.05) then
	-- 	surface.SetDrawColor(141, 182, 28)
	-- else
	-- 	surface.SetDrawColor(100, 120, 45)
	-- end

    local icon = gRust.GetIcon("voice")
    local padding = math.Round(16 * scaling)
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(x + padding, y + padding, size - padding * 2, size - padding * 2)
end

function GM:HUDPaint()
    hook.Call("PostHUDPaint", self)
    DrawVoiceIndicator()
end

-- Don't draw the default HUD elements
local NoDraw = {
    ["CHudHealth"] = true,
    ["CHudWeaponSelection"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudBattery"] = true,
    ["CHudCrosshair"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHUDQuickInfo"] = true
}

function GM:HUDShouldDraw(name)
    return !NoDraw[name]
end

local NextCheck = 0
hook.Add("Think", "gRust.CheckVehicleHud", function()
    local pl = LocalPlayer()
    if (!pl:InVehicle()) then
        gRust.Hud.Bars[4] = nil
        return
    end

    local vehicle = pl:GetVehicle() and pl:GetVehicle():GetParent()
    if (!IsValid(vehicle)) then return end
    if (!vehicle.GetMaxHP or vehicle:GetMaxHP() <= 0) then return end

    gRust.Hud.Bars[4] = {
        icon = "gear",
        color = Color(0, 0, 0, 175),
        value = function() return math.ceil(math.max(vehicle:GetHP(), 0)) end,
        max = vehicle:GetMaxHP(),
    }
end)