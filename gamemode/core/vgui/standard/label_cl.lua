local PANEL = {}

function PANEL:Init()
    self:SetFont("gRust.32px")
    self:SetTextColor(Color(255, 255, 255, 255))
end

function PANEL:SetTextSize(size)
    self:SetFont("gRust." .. size .. "px")
end

vgui.Register("gRust.Label", PANEL, "DLabel")