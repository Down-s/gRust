local round = math.Round

local PANEL = {}

AccessorFunc(PANEL, "Selected", "Selected", FORCE_BOOL)
AccessorFunc(PANEL, "Unlocked", "Unlocked", FORCE_BOOL)
AccessorFunc(PANEL, "Locked", "Locked", FORCE_BOOL)

function PANEL:Init()
    DisableClipping(true)
    self:SetText("")

    self.Parents = {}
end

local MARGIN = 5
local ICON_PADDING = 28
local LOCK_PADDING = 64
local LINE_COLOR = Color(100, 97, 98)
local UNLOCKED_LINE_COLOR = Color(102, 115, 69)
function PANEL:Paint(w, h)
    local margin = round(MARGIN * gRust.Hud.Scaling)
    local iconPadding = round(ICON_PADDING * gRust.Hud.Scaling)
    local lockPadding = round(LOCK_PADDING * gRust.Hud.Scaling)

    if (self.Selected) then
        surface.SetDrawColor(73, 136, 182)
    elseif (self.Unlocked) then
        surface.SetDrawColor(102, 115, 69)
    else
        surface.SetDrawColor(100, 97, 98)
    end

    if (self.Selected || self.Unlocked || !self.Locked) then
        surface.DrawRect(0, 0, w, h)
    end

    if (self.Selected) then
        surface.SetDrawColor(43, 76, 99)
    elseif (self.Locked) then
        surface.SetDrawColor(18, 17, 18)
    elseif (self.Unlocked) then
        surface.SetDrawColor(63, 66, 42)
    else
        surface.SetDrawColor(18, 17, 18)
    end

    surface.DrawRect(margin, margin, w - margin * 2, h - margin * 2)

    if (self.Locked) then
        surface.SetDrawColor(255, 255, 255, 35)
    else
        surface.SetDrawColor(255, 255, 255)
    end

    surface.SetMaterial(self.Item.Icon)
    surface.DrawTexturedRect(iconPadding, iconPadding, w - iconPadding * 2, h - iconPadding * 2)

    if (self.Locked) then
        surface.SetDrawColor(152, 147, 156)
        surface.SetMaterial(gRust.GetIcon("techtree.locked"))
        surface.DrawTexturedRect(lockPadding, lockPadding, w - lockPadding * 2, h - lockPadding * 2)
    end

    if (self.Parents) then
        for k, v in ipairs(self.Parents) do
            local x2, y2 = self:GetWide() * 0.5, 0
            local x1, y1 = self:ScreenToLocal(v:LocalToScreen(v:GetWide() * 0.5, v:GetTall()))
    
            local lineColor = self.Unlocked and UNLOCKED_LINE_COLOR or LINE_COLOR
            draw.RoutedLine(x1, y1, x2, y2, lineColor, round(5 * gRust.Hud.Scaling))
        end
    end
end

function PANEL:SetItem(id)
    self.Item = gRust.GetItemRegister(id)
end

vgui.Register("gRust.TechTree.Node", PANEL, "DButton")