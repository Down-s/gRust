gRust.Notifications = {}

local NOTIFICATION = {}
NOTIFICATION.__index = NOTIFICATION

AccessorFunc(NOTIFICATION, "Color", "Color")
AccessorFunc(NOTIFICATION, "Text", "Text")
AccessorFunc(NOTIFICATION, "TextColor", "TextColor")
AccessorFunc(NOTIFICATION, "SideColor", "SideColor")
AccessorFunc(NOTIFICATION, "Icon", "Icon")
AccessorFunc(NOTIFICATION, "IconColor", "IconColor")
AccessorFunc(NOTIFICATION, "IconPadding", "IconPadding")
AccessorFunc(NOTIFICATION, "ExitDuration", "ExitDuration")
AccessorFunc(NOTIFICATION, "Side", "Side")

function NOTIFICATION:__tostring()
    return "Notification[" .. self.index .. "]"
end

function NOTIFICATION:Init()
    self.index = table.insert(gRust.Notifications, self)
    self.entering = true
    self.removing = false
    self.enterTime = CurTime()
    self.animProgress = 0
    self.visible = true

    self.Color = gRust.Colors.Primary
    self.Text = "NOTIFICATION"
    self.Icon = "drop"
    self.IconColor = Color(0, 0, 0, 200)
    self.TextColor = Color(255, 255, 255, 175)
    self.IconPadding = 10
    self.EnterDuration = 0.15
    self.ExitDuration = 0.15
end

function NOTIFICATION:RemoveImmediate()
    table.remove(gRust.Notifications, self.index)
    self.entering = false

    for i = self.index, #gRust.Notifications do
        gRust.Notifications[i].index = i
    end
end

function NOTIFICATION:Remove()
    if (self.removing) then return end

    self.entering = false
    self.removing = true
    self.removeTime = CurTime()
end

function NOTIFICATION:Show()
    self.entering = true
    self.removing = false
    self.enterTime = CurTime()
    self.animProgress = 0
    self.visible = true

    -- Move the notification to the end of the list
    table.remove(gRust.Notifications, self.index)
    self.index = table.insert(gRust.Notifications, self)
    for i = 1, #gRust.Notifications do
        gRust.Notifications[i].index = i
    end
end

function NOTIFICATION:Hide()
    if (self.removing) then return end

    self.entering = false
    self.removing = true
    self.removeTime = CurTime()

    timer.Simple(self.ExitDuration, function()
        self.visible = false
    end)
end

function NOTIFICATION:SetDuration(duration)
    self.duration = CurTime() + duration
end

function NOTIFICATION:SetCondition(fn)
    self.condition = fn
end

function NOTIFICATION:Update()
end

function NOTIFICATION:PaintOver(x, y, w, h)
end

function NOTIFICATION:Think()
    if (self.duration and (self.duration < CurTime())) then
        self:Remove()
    end

    if (self.condition and not self.condition() and self.visible and not self.removing) then
        self:Hide()
    elseif (self.condition and self.condition()) then
        self:Update()

        if (not self.visible and not self.entering) then
            self:Show()
        end
    elseif (not self.condition) then
        self:Update()
    end

    -- self.animProgress goes from 0 to 1 when entering, and from 1 to 0 when removing
    if (self.entering) then
        self.animProgress = math.Clamp((CurTime() - self.enterTime) / self.EnterDuration, 0, 1)
    
        if (self.animProgress == 1) then
            self.entering = false
        end
    elseif (self.removing) then
        self.animProgress = 1 - math.Clamp((CurTime() - self.removeTime) / self.ExitDuration, 0, 1)
    end
end

function gRust.CreateNotification()
    local notification = setmetatable({}, NOTIFICATION)
    notification:Init()

    return notification
end

--
-- Draw notifications
--

hook.Add("HUDPaint", "gRust.DrawNotifications", function()
	if (!gRust.Hud.ShouldDraw) then return end
    
    local scrw, scrh = ScrW(), ScrH()

    local x = scrw - gRust.Hud.BarWidth - gRust.Hud.Margin
    local y = scrh - gRust.Hud.Margin - (gRust.Hud.BarHeight + gRust.Hud.BarSpacing) * #gRust.Hud.Bars + gRust.Hud.BarSpacing
    local w = gRust.Hud.BarWidth
    local h = gRust.Hud.BarHeight

    for _, notification in ipairs(gRust.Notifications) do
        notification:Think()
        if (!notification.visible) then continue end

        if (notification.removing and notification.animProgress == 0) then continue end

        local iconPadding = math.Round(notification.IconPadding * gRust.Hud.Scaling)

        local progress = notification.animProgress
        surface.SetAlphaMultiplier(progress)

        --render.SetScissorRect(x, (y - gRust.Hud.BarSpacing), x + w, y - (h + gRust.Hud.BarSpacing), true)
        local scissorY = y - gRust.Hud.BarSpacing - gRust.Hud.BarHeight
        render.SetScissorRect(x, scissorY, x + w, scissorY + h, true)

        if (notification.duration) then
            y = y - (h + gRust.Hud.BarSpacing) * progress
        else
            y = y - (h + gRust.Hud.BarSpacing) * progress
        end

        do
            gRust.DrawPanelColored(x, y, w, h, notification.Color)

            if (notification.Icon) then
                surface.SetDrawColor(notification.IconColor)
                surface.SetMaterial(gRust.GetIcon(notification.Icon))
                surface.DrawTexturedRect(x + iconPadding, y + iconPadding, h - iconPadding * 2, h - iconPadding * 2)
            end

            draw.SimpleText(notification.Text, "gRust.32px", x + h, y + h * 0.5, notification.TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            if (notification.Side) then
                draw.SimpleText(notification.Side, "gRust.32px", x + w - iconPadding * 2, y + h * 0.5, notification.SideColor or notification.TextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end

            notification:PaintOver(x, y, w, h)
        end
        
        surface.SetAlphaMultiplier(1)

        render.SetScissorRect(0, 0, 0, 0, false)
    end
end)

local VITAL_COLOR = Color(150, 49, 31, 250)
local VITAL_ICON_COLOR = Color(92, 30, 2)
local VITAL_TEXT_COLOR = Color(178, 136, 123)

--
-- Starving
--

local starving = gRust.CreateNotification()
starving:SetColor(VITAL_COLOR)
starving:SetIconColor(VITAL_ICON_COLOR)
starving:SetTextColor(VITAL_TEXT_COLOR)
starving:SetCondition(function()
    return LocalPlayer():GetCalories() <= 60
end)
starving.Update = function(self)
    self.Text = gRust.GetPhrase("STARVING")
    self.Icon = "hunger"
    self.Side = math.ceil(math.max(LocalPlayer():GetCalories(), 0))
end

--
-- Hydration
--

local hydration = gRust.CreateNotification()
hydration:SetColor(VITAL_COLOR)
hydration:SetIconColor(VITAL_ICON_COLOR)
hydration:SetTextColor(VITAL_TEXT_COLOR)
hydration:SetCondition(function()
    return LocalPlayer():GetHydration() <= 60
end)
hydration.Update = function(self)
    self.Text = gRust.GetPhrase("DEHYDRATED")
    self.Icon = "water"
    self.Side = math.ceil(math.max(LocalPlayer():GetHydration(), 0))
end

--
-- Bleeding
--

local bleeding = gRust.CreateNotification()
bleeding:SetColor(VITAL_COLOR)
bleeding:SetIconColor(VITAL_ICON_COLOR)
bleeding:SetTextColor(VITAL_TEXT_COLOR)
bleeding:SetCondition(function()
    return LocalPlayer():GetBleeding() > 0
end)
bleeding.Update = function(self)
    self.Text = "BLEEDING"
    self.Icon = "bleeding"
    self.Side = math.floor(LocalPlayer():GetBleeding())
end

--
-- Wetness
--

local wet = gRust.CreateNotification()
wet:SetColor(VITAL_COLOR)
wet:SetIconColor(VITAL_ICON_COLOR)
wet:SetTextColor(VITAL_TEXT_COLOR)
wet:SetCondition(function()
    return LocalPlayer():GetWetness() > 0
end)
wet.Update = function(self)
    self.Text = "WETNESS"
    self.Icon = "wet"
    self.Side = string.format("%i%%", math.ceil(LocalPlayer():GetWetness()))
end

--
-- Radiation Poisoning
--

local radiation = gRust.CreateNotification()
radiation:SetColor(VITAL_COLOR)
radiation:SetIconColor(VITAL_ICON_COLOR)
radiation:SetTextColor(VITAL_TEXT_COLOR)
radiation:SetCondition(function()
    return LocalPlayer():GetRadiation() >= 1
end)
radiation.Update = function(self)
    self.Text = "RADIATION POISONING"
    self.Icon = "radiation"
    self.Side = math.floor(LocalPlayer():GetRadiation())
end

if (StormFox2) then
    --
    -- Cold
    --

    local cold = gRust.CreateNotification()
    cold:SetColor(VITAL_COLOR)
    cold:SetIconColor(VITAL_ICON_COLOR)
    cold:SetTextColor(VITAL_TEXT_COLOR)
    cold:SetCondition(function()
        return StormFox2.Temperature.Get("celsius") <= 0
    end)
    cold.Update = function(self)
        self.Text = "TOO COLD"
        self.Icon = "freezing"
        self.Side = string.format("%i°C", math.floor(StormFox2.Temperature.Get("celsius")))
    end

    --
    -- Hot
    --

    local hot = gRust.CreateNotification()
    hot:SetColor(VITAL_COLOR)
    hot:SetIconColor(VITAL_ICON_COLOR)
    hot:SetTextColor(VITAL_TEXT_COLOR)
    hot:SetCondition(function()
        return StormFox2.Temperature.Get("celsius") >= 30
    end)
    hot.Update = function(self)
        self.Text = "TOO HOT"
        self.Icon = "hot"
        self.Side = string.format("%i°C", math.floor(StormFox2.Temperature.Get("celsius")))
    end
end