local INTERACTMENU = {}
INTERACTMENU.__index = INTERACTMENU

gRust.AccessorFunc(INTERACTMENU, "Name")
gRust.AccessorFunc(INTERACTMENU, "Icon")
gRust.AccessorFunc(INTERACTMENU, "Time")
gRust.AccessorFunc(INTERACTMENU, "Progress")
gRust.AccessorFunc(INTERACTMENU, "Callback")

function INTERACTMENU:__tostring()
    return "INTERACTMENU[" .. self:GetName() .. "]"
end

function INTERACTMENU:__eq(other)
    return self:GetName() == other:GetName()
end

function INTERACTMENU:IsValid()
    return self:GetName() ~= nil
end

function INTERACTMENU:Update()
    local progress = (CurTime() - self.Start) / self:GetTime()
    self:SetProgress(progress)

    if (progress >= 1) then
        self:Close(true)
        self:GetCallback()()
    end
end

local BACKGROUND_COLOR = ColorAlpha(gRust.Colors.Text, 100)
function INTERACTMENU:Draw()
    self:Update()

    local barWidth = 396 * gRust.Hud.Scaling
    local barHeight = 16 * gRust.Hud.Scaling
    local iconSize = 26 * gRust.Hud.Scaling
    local iconOffset = 12 * gRust.Hud.Scaling
    local yOffset = 60 * gRust.Hud.Scaling

    surface.SetDrawColor(BACKGROUND_COLOR)
    surface.DrawRect(ScrW() / 2 - barWidth / 2, ScrH() * 0.5 - yOffset, barWidth, barHeight)

    surface.SetDrawColor(246, 246, 246)
    surface.DrawRect(ScrW() / 2 - barWidth / 2, ScrH() * 0.5 - yOffset, barWidth * self:GetProgress(), barHeight)

    surface.SetDrawColor(gRust.Colors.Primary)
    surface.SetMaterial(gRust.GetIcon(self:GetIcon()))
    surface.DrawTexturedRect(ScrW() * 0.5 - barWidth * 0.5 + iconOffset, ScrH() * 0.5 - yOffset - iconSize, iconSize, iconSize)

    draw.SimpleText(self:GetName(), "gRust.24px", ScrW() * 0.5 - barWidth * 0.5 + iconOffset + iconSize, ScrH() * 0.5 - yOffset, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

function INTERACTMENU:Close(suppressSound)
    if (self.Closed) then return end
    
    hook.Remove("HUDPaint", self)
    gRust.InteractMenu = nil
    self.Closed = true

    if (!suppressSound) then
        gRust.PlaySound("piemenu.close")
    end
end

function gRust.CreateInteractMenu(name, icon, time, callback)
    if (gRust.InteractMenu) then
        gRust.InteractMenu:Close(true)
    end

    local interactMenu = setmetatable({}, INTERACTMENU)
    interactMenu:SetName(name)
    interactMenu:SetIcon(icon)
    interactMenu:SetTime(time)
    interactMenu:SetCallback(callback)
    interactMenu:SetProgress(0)
    interactMenu.Start = CurTime()
    hook.Add("HUDPaint", interactMenu, interactMenu.Draw)

    gRust.PlaySound("piemenu.open")

    gRust.InteractMenu = interactMenu
    return interactMenu
end