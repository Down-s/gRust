local PANEL = {}

function PANEL:Init()
    self.PageContainer = self:Add("Panel")
    self.PageContainer:Dock(TOP)
    self.PageContainer:SetTall(30)
    local margin = 8
    self.PageContainer:DockMargin(margin, margin, margin, margin)
end

local PANEL_COLOR = Color(27, 31, 29, 230)
function PANEL:Paint(w, h)
    gRust.DrawPanelColored(0, 0, w, h, PANEL_COLOR)
end

function PANEL:AddPage(title, class)
    self.Pages = self.Pages or {}

    local page = self.PageContainer:Add("DButton")
    page:Dock(LEFT)
    page:SetWide(100)
    page:SetCursor("hand")
    page:SetContentAlignment(5)
    page:SetText("")
    page.Alpha = 25
    page.Paint = function(me, w, h)
        if (me:IsHovered()) then
            me.Alpha = Lerp(FrameTime() * 25, me.Alpha, 100)
        else
            me.Alpha = Lerp(FrameTime() * 25, me.Alpha, 25)
        end

        draw.SimpleText(title, "gRust.32px", w * 0.5, h * 0.5, Color(130, 201, 36, me.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    page.DoClick = function()
        self:SelectPage(#self.Pages)
    end
    
    self.Pages[#self.Pages + 1] = {title = title, class = class, page = page}

    if (#self.Pages == 1) then
        self:SelectPage(1)
    end
end

function PANEL:SelectPage(i)
    if (IsValid(self.OpenedPage)) then
        self.OpenedPage:Remove()
    end

    local page = self.Pages[i]
    if (!page) then return end
    
    self.OpenedPage = self:Add(page.class)
    self.OpenedPage:Dock(FILL)
end

vgui.Register("gRust.DevTools", PANEL, "EditablePanel")