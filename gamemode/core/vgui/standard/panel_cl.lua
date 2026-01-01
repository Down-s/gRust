local PANEL = {}

AccessorFunc(PANEL, "Primary", "Primary", FORCE_BOOL)
AccessorFunc(PANEL, "Color", "Color")

function PANEL:Init()
end

function PANEL:Paint(w, h)
    if (self.Color) then
        gRust.DrawPanelColored(0, 0, w, h, self.Color)
    else
        if (self.Primary) then
            gRust.DrawPanel(0, 0, w, h, gRust.Colors.Panel)
            gRust.DrawPanel(0, 0, w, h, gRust.Colors.Panel)
        else
            gRust.DrawPanel(0, 0, w, h, gRust.Colors.Panel)
        end
    end
end

vgui.Register("gRust.Panel", PANEL, "Panel")