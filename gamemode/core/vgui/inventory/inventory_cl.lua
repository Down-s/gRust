local PANEL = {}

AccessorFunc(PANEL, "Inventory", "Inventory")

local NAME_CONTAINER_COLOR = ColorAlpha(gRust.Colors.Panel, 20)
local CONTAINER_PADDING = 12 * gRust.Hud.Scaling
function PANEL:Init()
    self:SetCols(6)
end

function PANEL:SetCols(n)
    self.Cols = n
    if (self.Grid) then
        self.Grid:InvalidateLayout(true)
    end
end

function PANEL:RemoveNameContainer()
    self.NameContainer:Remove()
end

function PANEL:SetInventory(inv)
    local spacing = gRust.Hud.SlotPadding
    local padding = CONTAINER_PADDING
    local rows = math.ceil(inv:GetSize() / self.Cols)
    self.Grid = self:Add("Panel")
    self.Grid:DockMargin(padding, padding, padding, 0)
    self.Grid:Dock(BOTTOM)
    
    for i = 1, inv:GetSize() do
        local slot = self.Grid:Add("gRust.Slot")
        slot:SetInventory(inv)
        slot:SetSlot(i)
    end

    local NameContainer = self:Add("Panel")
    NameContainer:Dock(BOTTOM)
    NameContainer:SetTall(46 * gRust.Hud.Scaling)
    NameContainer.Paint = function(me, w, h)
        gRust.DrawPanelColored(0, 0, w, h, NAME_CONTAINER_COLOR)
        draw.SimpleText(inv:GetName() or "Inventory", "gRust.32px", 16 * gRust.Hud.Scaling, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.NameContainer = NameContainer
    
    self.Grid.PerformLayout = function(me, w, h)
        local x, y = 0, 0
        local size = ((w + spacing) / self.Cols) - spacing
        size = math.floor(size)

        local children = me:GetChildren()
        if (#children == 1) then
            local v = children[1]
            v:SetSize(size, size)
            v:SetPos(w * 0.5 - size * 0.5, 0)
        else
            for k, v in pairs(children) do
                v:SetSize(size, size)
                v:SetPos(x, y)
    
                x = x + size + spacing
                if (x >= w) then
                    x = 0
                    y = y + size + spacing
                end
            end
        end

        self.Grid:SetTall((size * rows) + (spacing * (rows - 1)))
        self:SetTall(self.Grid:GetTall() + (IsValid(NameContainer) and NameContainer:GetTall() or 0) + padding)
    end
end

function PANEL:PerformLayout(w, h)
end

vgui.Register("gRust.Inventory", PANEL, "Panel")