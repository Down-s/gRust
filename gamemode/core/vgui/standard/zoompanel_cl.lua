local PANEL = {}

function PANEL:Add(class)
    local panel = vgui.Create(class, self.Canvas)
    panel:SetPos(0, 0)
    panel:SetSize(self:GetWide(), self:GetTall())
    return panel
end

function PANEL:Init()
    self.Matrix = Matrix()

    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:SetSize(ScrW() * 10, ScrH() * 10)
end

function PANEL:Paint()
    cam.PushModelMatrix(self.Matrix)
end

function PANEL:PaintOver()
    cam.PopModelMatrix()
end

function PANEL:Think()
    if (input.IsMouseDown(MOUSE_LEFT)) then
        if (!self.InitialX) then
            local mx, my = gui.MousePos()
            local cx, cy = self.Canvas:GetPos()
            self.InitialX = mx - cx
            self.InitialY = my - cy
        end

        local mx, my = gui.MousePos()
        local diffX, diffY = mx - self.InitialX, my - self.InitialY
        
        --self.Matrix:SetTranslation(Vector(diffX, diffY, 0))
        self.Canvas:SetPos(diffX, diffY)
    else
        self.InitialX, self.InitialY = nil, nil
    end
end

local VECTOR_ONE = Vector(1, 1, 1)
function PANEL:OnMouseWheeled(delta)
    local scaleAmount = VECTOR_ONE * (1 + delta * 0.1)
    scaleAmount.z = 1
    --self.Matrix:Scale(scaleAmount)
end

vgui.Register("gRust.ZoomPanel", PANEL, "Panel")