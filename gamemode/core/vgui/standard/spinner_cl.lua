local PANEL = {}

function PANEL:Init()
    self.Min = 0
    self.Max = 100
    
    local Sub = self:Add("gRust.Button")
    Sub:SetContentAlignment(5)
    Sub:Dock(LEFT)
    Sub:SetText("-")
    Sub:SetFont("gRust.50px")

    local Add = self:Add("gRust.Button")
    Add:SetContentAlignment(5)
    Add:Dock(RIGHT)
    Add:SetText("+")
    Add:SetFont("gRust.50px")

    local Value = self:Add("gRust.Input")
    Value:SetContentAlignment(5)
    Value:Dock(FILL)
    Value:SetValue("0")
    Value:SetTextSize(22)
    Value:SetNumeric(true)
    Value.OnEnter = function(s, val)
        local num = tonumber(val)
        if (num < self.Min) then
            num = self.Min
        elseif (num > self.Max) then
            num = self.Max
        end

        s:SetValue(tostring(num))
    end
    Value.OnValueChanged = function(me, val)
        if (self.OnValueChanged) then
            self:OnValueChanged(val)
        end
    end
    
    self.Sub = Sub
    self.Add = Add
    self.Value = Value

    self.Sub.DoClick = function()
        local num = tonumber(Value:GetValue())
        if (num > self.Min) then
            num = num - 1
            Value:SetValue(num)
        end
    end
    
    self.Add.DoClick = function()
        local num = tonumber(Value:GetValue())
        if (num < self.Max) then
            num = num + 1
            Value:SetValue(num)
        end
    end
end

function PANEL:PerformLayout(W, h)
    self.Sub:SetWide(h)
    self.Add:SetWide(h)
end

function PANEL:SetMin(min)
    local val = tonumber(self.Value:GetValue())
    if (val < min) then
        self.Value:SetValue(min)
    end

    self.Min = min
end

function PANEL:SetMax(max)
    local val = tonumber(self.Value:GetValue())
    if (val > max) then
        self.Value:SetValue(max)
    end

    self.Max = max
end

function PANEL:GetValue()
    return tonumber(self.Value:GetValue())
end

function PANEL:SetValue(val)
    self.Value:SetValue(val)
end

vgui.Register("gRust.Spinner", PANEL, "Panel")