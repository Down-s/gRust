local PANEL = {}

AccessorFunc(PANEL, "Inventory", "Inventory")
AccessorFunc(PANEL, "Slot", "Slot")

surface.CreateFont("gRust.ItemDescription", {
    font = "Roboto Condensed",
    size = 28 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function PANEL:Init()
    self:Rebuild()
end

function PANEL:Paint(w, h)
end

function PANEL:Clear()
    for k, v in pairs(self:GetChildren()) do
        v:Remove()
    end
end

local TipColor1 = ColorAlpha(gRust.Colors.Text, 200)
local TipColor2 = ColorAlpha(gRust.Colors.Text, 100)
function PANEL:Rebuild()
    if (#self:GetChildren() > 0) then
        self:Clear()
    else
        self:SetAlpha(0)
        self:AlphaTo(255, 0.05)
    end

    if (!self:GetInventory()) then return end
    if (!self:GetInventory()[self:GetSlot()]) then return end

    local item = self:GetInventory()[self:GetSlot()]
    local register = item:GetRegister()

    if (item:GetQuantity() > 1) then
        local Splitting = self:Add("Panel")
        Splitting:SetTall(100 * gRust.Hud.Scaling)
        Splitting:Dock(BOTTOM)
        Splitting:DockMargin(0, 4 * gRust.Hud.Scaling, 0, 0)

        local Container = Splitting:Add("Panel")
        Container:Dock(FILL)

        local TipPanel = Container:Add("Panel")
        TipPanel:Dock(TOP)
        TipPanel:SetTall(40 * gRust.Hud.Scaling)
        TipPanel.Paint = function(pnl, w, h)
            gRust.DrawPanel(0, 0, w, h)
            gRust.DrawPanel(0, 0, w, h)
            draw.SimpleText("SPLITTING", "gRust.28px", 8 * gRust.Hud.Scaling, h / 2, TipColor1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("SET AMOUNT & DRAG ICON", "gRust.26px", w - (8 * gRust.Hud.Scaling), h / 2, TipColor2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        local value = math.ceil(item:GetQuantity() * 0.5)
        local Slider = Container:Add("gRust.Slider")
        Slider:Dock(FILL)
        Slider:DockMargin(0, 2 * gRust.Hud.Scaling, 0, 0)
        Slider:SetMinValue(1)
        Slider:SetMaxValue(item:GetQuantity())
        Slider:SetValue(value)

        local DragItem = Splitting:Add("gRust.Slot")
        DragItem:Dock(RIGHT)
        DragItem:SetWide(100 * gRust.Hud.Scaling)
        DragItem:DockMargin(2 * gRust.Hud.Scaling, 0, 0, 0)
        DragItem:SetInventory(self:GetInventory())
        DragItem:SetSlot(self:GetSlot())
        DragItem:SetQuantity(value)
        DragItem:SetAnimated(false)
        DragItem:SetSelectable(false)
        Slider.OnValueChanged = function(slider, value)
            DragItem:SetQuantity(value)
        end
    end

    local Info = self:Add("Panel")
    Info:Dock(FILL)

    local Description = Info:Add("gRust.Panel")
    Description:Dock(TOP)
    Description:SetTall(120 * gRust.Hud.Scaling)

    local Icon = Description:Add("DImage")
    Icon:Dock(RIGHT)
    Icon:SetWide(120 * gRust.Hud.Scaling)
    Icon:SetMaterial(item:GetRegister():GetIcon())
    Icon:DockMargin(0, 0, 16 * gRust.Hud.Scaling, 0)

    local DescriptionMargin = 20 * gRust.Hud.Scaling
    local DescriptionText = Description:Add("gRust.Label")
    DescriptionText:Dock(FILL)
    DescriptionText:SetFont("gRust.ItemDescription")
    DescriptionText:DockMargin(DescriptionMargin, DescriptionMargin, DescriptionMargin, DescriptionMargin)
    DescriptionText:SetText(item:GetRegister():GetDescription())
    DescriptionText:SetContentAlignment(7)
    DescriptionText:SetTextColor(TipColor2)
    DescriptionText:SetWrap(true)

    local ActionsRoot = Info:Add("Panel")
    ActionsRoot:Dock(RIGHT)
    ActionsRoot:SetWide(320 * gRust.Hud.Scaling)
    ActionsRoot:DockMargin(4 * gRust.Hud.Scaling, 4 * gRust.Hud.Scaling, 0, 0)

    local Title = ActionsRoot:Add("gRust.Panel")
    Title:Dock(TOP)
    Title:SetTall(40 * gRust.Hud.Scaling)
    Title:SetPrimary(true)

    local ActionsText = Title:Add("gRust.Label")
    ActionsText:Dock(FILL)
    ActionsText:SetFont("gRust.28px")
    ActionsText:DockMargin(8 * gRust.Hud.Scaling, 0, 0, 0)
    ActionsText:SetText("ACTIONS")
    ActionsText:SetTextColor(gRust.Colors.Text)

    local ActionsContainer = ActionsRoot:Add("gRust.Panel")
    ActionsContainer:Dock(FILL)
    ActionsContainer:DockMargin(0, 2 * gRust.Hud.Scaling, 0, 0)

    local Actions = ActionsContainer:Add("gRust.Scroll")
    Actions:Dock(FILL)
    Actions.PerformLayout = function(me, w, h)
        me.Canvas:SizeToChildren(false, true)
        me.Canvas:SetTall(h)
        me.Canvas:SetWide(self:GetWide())
        me.ChildTall = me.Canvas:GetTall()
    end

    do
        local Drop = Actions:Add("gRust.Button")
        Drop:Dock(BOTTOM)
        Drop:SetTall(70 * gRust.Hud.Scaling)
        Drop:SetIcon("drop")
        Drop:SetText("Drop")
        Drop.DoClick = function(me)
            if (!self:GetInventory()) then return end
            local item = self:GetInventory()[self:GetSlot()]
            gRust.DropItem(self:GetInventory(), self:GetSlot())
        end

        if (register.Actions) then
            for k, v in ipairs(register.Actions) do
                local Action = Actions:Add("gRust.Button")
                Action:Dock(BOTTOM)
                Action:SetTall(70 * gRust.Hud.Scaling)
                Action:SetIcon(v.Icon)
                Action:DockMargin(0, 0, 0, 1)
                Action:SetText(v.Name)
                Action.DoClick = function(me)
                    if (!self:GetInventory()) then return end
                    local item = self:GetInventory()[self:GetSlot()]
                    
                    net.Start("gRust.ItemAction")
                        net.WriteUInt(self:GetInventory():GetIndex(), 24)
                        net.WriteUInt(self:GetSlot(), 7)
                        net.WriteUInt(k, 5)
                    net.SendToServer()
                end
            end
        end
    end

    local Stats = Info:Add("gRust.Panel")
    Stats:Dock(FILL)

    if (register:GetWeapon()) then
        local ItemInfo = Stats:Add("gRust.ItemInfo")
        ItemInfo:Dock(TOP)
        ItemInfo:SetTall(298 * gRust.Hud.Scaling)
        ItemInfo:DockMargin(0, 4 * gRust.Hud.Scaling, 0, 0)
        ItemInfo:SetItem(item)
        ItemInfo:Rebuild()
    end
end

vgui.Register("gRust.ItemData", PANEL, "Panel")