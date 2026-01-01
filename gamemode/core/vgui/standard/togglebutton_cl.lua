local PANEL = {}

AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "Down", "Down", FORCE_BOOL)
AccessorFunc(PANEL, "Toggled", "Toggled", FORCE_BOOL)
AccessorFunc(PANEL, "Icon", "Icon", FORCE_STRING)

function PANEL:Init()
    self:SetToggled(false)
    self:SetIcon("power")
    self:SetCursor("hand")
    self:SetColor(Color(255, 255, 255, 0))
end

local ON_COLOR = Color(117, 65, 54)
local OFF_COLOR = Color(100, 119, 66)
local ON_TEXT_COLOR = Color(240, 124, 77)
local OFF_TEXT_COLOR = Color(155, 180, 110)
local ICON_MARGIN = 28
function PANEL:Paint(w, h)
    local color = self:GetToggled() and ON_COLOR or OFF_COLOR
    local text = self:GetToggled() and "Turn Off" or "Turn On"
    local textColor = self:GetToggled() and ON_TEXT_COLOR or OFF_TEXT_COLOR

    gRust.DrawPanelColored(0, 0, w, h, color)
    
    surface.SetDrawColor(self:GetColor())
    surface.DrawRect(0, 0, w, h)

    surface.SetMaterial(gRust.GetIcon(self:GetIcon()))
    surface.SetDrawColor(textColor)
    local iconMargin = ICON_MARGIN * gRust.Hud.Scaling
    surface.DrawTexturedRect(iconMargin, iconMargin, h - iconMargin * 2, h - iconMargin * 2)
    
    draw.SimpleText(text, "gRust.44px", h - iconMargin * 0.5, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:OnCursorEntered()
    self:ColorTo(Color(150, 150, 150, 8), 0.075)
end

function PANEL:OnCursorExited()
    self:ColorTo(Color(150, 150, 150, 0), 0.075)
end

function PANEL:OnMousePressed()
    self:ColorTo(Color(150, 150, 150, 15), 0.075)
    self:SetDown(true)
end

function PANEL:OnMouseReleased()
    self:ColorTo(Color(150, 150, 150, 8), 0.075)
    
    if (self:GetDown()) then
        self:SetDown(false)
        self:Toggle()
    end
end

function PANEL:Toggle()
    self:SetToggled(!self:GetToggled())
    self:OnToggle(self:GetToggled())
end

function PANEL:OnToggle(state)
    -- Override
end

vgui.Register("gRust.ToggleButton", PANEL, "Panel")