local PANEL = {}

AccessorFunc(PANEL, "MaxValue", "MaxValue", FORCE_NUMBER)
AccessorFunc(PANEL, "MinValue", "MinValue", FORCE_NUMBER)

function PANEL:Init()
    self:SetCursor("hand")
    self:SetMinValue(0)
    self:SetMaxValue(100)
    self:SetValue(50)
    self:NoClipping(true)
end

function PANEL:SetValue(value)
    self.Value = math.Clamp(value, self:GetMinValue(), self:GetMaxValue())
end

function PANEL:GetValue()
    return self.Value
end

local ValueColor = ColorAlpha(gRust.Colors.Text, 85)
function PANEL:Paint(w, h)
    gRust.DrawPanel(0, 0, w, h)

    local value = self:GetValue()
    local min = self:GetMinValue()
    local max = self:GetMaxValue()
    local frac = (value - min) / (max - min)

    gRust.DrawPanelColored(0, 0, w * frac, h, ValueColor)
    draw.SimpleText(value, "gRust.32px", w * frac, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:OnValueChanged(value)
end

function PANEL:OnMousePressed(keycode)
    if (keycode == MOUSE_LEFT) then
        --[[local x, y = self:CursorPos()
        local w, h = self:GetSize()
        local value = math.Round((x / w) * self:GetMaxValue())
    
        self:SetValue(value)
        self:OnValueChanged(value)]]
        self.Dragging = true
    elseif (keycode == MOUSE_RIGHT) then
        -- TODO: Add keyboard input
    elseif (keycode == MOUSE_MIDDLE) then
        self:SetValue(self:GetMaxValue() * 0.5)
        self:OnValueChanged(self:GetMaxValue())
    end
end

function PANEL:Think()
    if (input.IsMouseDown(MOUSE_LEFT)) then
        if (!self.Dragging) then return end
        local x, y = self:CursorPos()
        local w, h = self:GetSize()

        local min, max = self:GetMinValue(), self:GetMaxValue()
        local value = math.Round((x / w)* (max - min) + min)
    
        self:SetValue(value)
        local newValue = self:GetValue()
        if (self.LastValue != newValue) then
            self.LastValue = newValue
            self:OnValueChanged(newValue)
        end
    else
        self.Dragging = false
    end
end

vgui.Register("gRust.Slider", PANEL, "Panel")