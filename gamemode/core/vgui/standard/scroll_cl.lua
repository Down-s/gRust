local PANEL = {}

function PANEL:Init()
    self.ScrollAmount = 0
    self.ScrollTarget = 0

    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:SetMouseInputEnabled(true)
end

function PANEL:Paint(w, h)
end

function PANEL:Add(...)
    return self.Canvas:Add(...)
end

function PANEL:PerformLayout(w, h)
    self.Canvas:SetTall(h * 2)
    self.Canvas:SetWide(self:GetWide())
end

-- Drag scrolling
function PANEL:OnMousePressed()
    self.Dragging = {gui.MouseX(), gui.MouseY()}
    self.CPos = {self.Canvas.x, self.Canvas.y}
end

local ElasticStrength = 20
function PANEL:Think()
    self.YPos = self.YPos or 0
    self.YPos = Lerp(FrameTime() * ElasticStrength, self.YPos, self.ScrollTarget)

    -- if (self.ScrollTarget > (self.ChildTall or self.Canvas:GetTall()) - self:GetTall()) then
    --     self.ScrollTarget = Lerp(FrameTime() * ElasticStrength, self.ScrollTarget, 0)
    -- end

    if (self.ScrollTarget > 0) then
        self.ScrollTarget = Lerp(FrameTime() * ElasticStrength, self.ScrollTarget, 0)
    end

    if (self.Dragging) then
        local x, y = gui.MouseX(), gui.MouseY()
        local xDiff, yDiff = x - self.Dragging[1], y - self.Dragging[2]
        self.Dragging = {x, y}

        --self.Canvas:SetPos(self.CPos[1] + xDiff, self.CPos[2] + yDiff)
        self.Canvas:SetY(self.CPos[2] + yDiff)
        self.YPos = self.Canvas.y
        self.ScrollTarget = self.YPos
    end

    self.Canvas:SetY(self.YPos)
end

function PANEL:OnMouseWheeled(delta)
    self.ScrollTarget = self.ScrollTarget + delta * 20
end

vgui.Register("gRust.Scroll", PANEL, "Panel")