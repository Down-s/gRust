local PANEL = {}

AccessorFunc(PANEL, "Icon", "Icon", FORCE_STRING)
AccessorFunc(PANEL, "Text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "Down", "Down", FORCE_BOOL)
AccessorFunc(PANEL, "DefaultColor", "DefaultColor")
AccessorFunc(PANEL, "HoveredColor", "HoveredColor")
AccessorFunc(PANEL, "SelectedColor", "SelectedColor")
AccessorFunc(PANEL, "TextColor", "TextColor")
AccessorFunc(PANEL, "IconPadding", "IconPadding", FORCE_NUMBER)
AccessorFunc(PANEL, "LerpTime", "LerpTime", FORCE_NUMBER)
AccessorFunc(PANEL, "Offset", "Offset", FORCE_NUMBER)
AccessorFunc(PANEL, "Font", "Font")

local DefaultColor = ColorAlpha(gRust.Colors.Panel, 25)
local HoveredColor = ColorAlpha(gRust.Colors.Panel, 50)
local SelectedColor = Color(18, 141, 223, 75)
function PANEL:Init()
    self:SetDefaultColor(DefaultColor)
    self:SetHoveredColor(HoveredColor)
    self:SetSelectedColor(SelectedColor)
    self:SetTextColor(gRust.Colors.Text)
    
    self:SetColor(self:GetDefaultColor())
    self:SetCursor("hand")
    self:SetFont("gRust.38px")
    self:SetIconPadding(12 * gRust.Hud.Scaling)
    self:SetLerpTime(0.075)
    self:SetOffset(0)
    self:SetText("")
    self:SetIcon("")
end

function PANEL:SetDefaultColor(color)
    self.DefaultColor = color
    self:SetColor(color)
end

function PANEL:OnCursorEntered()
    self:ColorTo(self:GetHoveredColor(), self.LerpTime)
end

function PANEL:OnCursorExited()
    self:ColorTo(self:GetDefaultColor(), self.LerpTime)
end

function PANEL:OnMousePressed()
    self:ColorTo(self:GetSelectedColor(), self.LerpTime)
    self:SetDown(true)
end

function PANEL:OnMouseReleased()
    self:ColorTo(self:GetHoveredColor(), self.LerpTime)
    
    if (self:GetDown()) then
        self:SetDown(false)

        -- Double Click
        if (self.ClickTime and self.DoDoubleClick and self.ClickTime + 0.2 > CurTime()) then
            self:DoDoubleClick()
            self.ClickTime = nil
            return
        else
            self:DoClick()
            self.ClickTime = CurTime()
        end
    end
end

function PANEL:DoClick()
    -- Override
end

--[[function PANEL:DoDoubleClick()
    -- Override
end]]

function PANEL:Paint(w, h)
    local Offset = self:GetOffset()
    local IconPadding = self:GetIconPadding()
    gRust.DrawPanelColored(0, 0, w, h, self:GetColor())
    local TextColor = self.TextColor

    if (self:GetText() ~= "") then
        if (self:GetIcon() ~= "") then
            surface.SetDrawColor(TextColor)
            surface.SetMaterial(gRust.GetIcon(self:GetIcon()))
            surface.DrawTexturedRect(Offset + IconPadding, IconPadding, h - IconPadding * 2, h - IconPadding * 2)
        
            draw.SimpleText(self:GetText(), self:GetFont(), Offset + h, h / 2, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(self:GetText(), self:GetFont(), w * 0.5, h * 0.5, TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    elseif (self:GetIcon() ~= "") then
        surface.SetDrawColor(TextColor)
        surface.SetMaterial(gRust.GetIcon(self:GetIcon()))
        -- Center align the icon and take into account the IconPadding
        surface.DrawTexturedRect(w / 2 - h / 2 + IconPadding, IconPadding, h - IconPadding * 2, h - IconPadding * 2)
    end
end

vgui.Register("gRust.Button", PANEL, "Panel")