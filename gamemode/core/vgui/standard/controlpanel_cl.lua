local PANEL = {}

AccessorFunc(PANEL, "Title", "Title", FORCE_STRING)

local TITLE_CONTAINER_COLOR = ColorAlpha(gRust.Colors.Panel, 20)
function PANEL:Init()
    local Title = vgui.Create("Panel", self)
    Title:Dock(TOP)
    Title:SetTall(42 * gRust.Hud.Scaling)
    Title:DockMargin(0, 0, 0, 4 * gRust.Hud.Scaling)
    Title.Paint = function(me, w, h)
        gRust.DrawPanelColored(0, 0, w, h, TITLE_CONTAINER_COLOR)
        draw.SimpleText(self:GetTitle() or "Controls", "gRust.32px", 16 * gRust.Hud.Scaling, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local Container = vgui.Create("Panel", self)
    Container:Dock(FILL)
    local padding = 16 * gRust.Hud.Scaling
    Container:DockPadding(padding, padding, padding, padding)
    Container.Paint = function(me, w, h)
        gRust.DrawPanel(0, 0, w, h)
    end

    self.Container = Container
end

function PANEL:Paint(w, h)

end

function PANEL:Add(classname)
    return vgui.Create(classname, self.Container)
end

vgui.Register("gRust.ControlPanel", PANEL, "Panel")