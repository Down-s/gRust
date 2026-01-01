local PANEL = {}

AccessorFunc(PANEL, "Padding", "Padding", FORCE_NUMBER)
AccessorFunc(PANEL, "Icon", "Icon", FORCE_STRING)
AccessorFunc(PANEL, "Material", "Material")
AccessorFunc(PANEL, "Color", "Color")

function PANEL:Init()
    self:SetPadding(0)
end

local DefaultColor = gRust.Colors.Text
function PANEL:Paint(w, h)
    local icon = self:GetIcon() and gRust.GetIcon(self:GetIcon()) or self:GetMaterial()
    if (!icon) then return end
    local padding = self:GetPadding()

    surface.SetDrawColor(self:GetColor() or DefaultColor)
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(padding, padding, w - padding * 2, h - padding * 2)
end

vgui.Register("gRust.Icon", PANEL, "Panel")