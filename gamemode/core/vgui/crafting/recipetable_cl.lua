local PANEL = {}

AccessorFunc(PANEL, "Multiplier", "Multiplier", FORCE_NUMBER)
AccessorFunc(PANEL, "Dirty", "Dirty", FORCE_BOOL)

function PANEL:Init()
    self:SetMultiplier(1)
end

function PANEL:Paint()

end

function PANEL:SetItemId(id)
    self.ItemId = id
    self:SetDirty(true)
end

function PANEL:GetItemId()
    return self.ItemId
end

local Tabs = {
    {
        Name = "AMOUNT",
        Align = TEXT_ALIGN_RIGHT,
        Value = function(panel, item, i)
            return item:GetRecipe()[i].Quantity
        end
    },
    {
        Name = "ITEM TYPE",
        Align = TEXT_ALIGN_LEFT,
        Value = function(panel, item, i)
            return gRust.GetItemRegister(item:GetRecipe()[i].Item):GetName()
        end
    },
    {
        Name = "TOTAL",
        Align = TEXT_ALIGN_LEFT,
        Value = function(panel, item, i)
            return item:GetRecipe()[i].Quantity * panel:GetMultiplier()
        end
    },
    {
        Name = "HAVE",
        Align = TEXT_ALIGN_LEFT,
        Value = function(panel, item, i)
            return LocalPlayer():ItemCount(item:GetRecipe()[i].Item)
        end
    }
}

surface.CreateFont("gRust.RecipeTable", {
    font = "Roboto",
    size = 30 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function PANEL:Rebuild()
    local itemId = self:GetItemId()
    if (!itemId) then return end
    local item = gRust.GetItemRegister(self:GetItemId())
    if (!item) then return end

    local Spacing = 2 * gRust.Hud.Scaling
    
    for i = 1, 5 do
        local h = (i == 1) and 32 or 46
        h = h * gRust.Hud.Scaling

        local Row = self:Add("Panel")
        Row:Dock(TOP)
        Row:SetTall(h)
        Row:DockMargin(0, 0, 0, Spacing)
        for j = 1, 4 do
            local Tab = Tabs[j]
            local RecipeItem = item:GetRecipe()[i - 1]

            local w = (j == 2) and 455 or 215
            w = w * gRust.Hud.Scaling
            local Col = Row:Add("DPanel")
            Col:Dock(LEFT)
            Col:SetWide(w)
            Col:DockMargin(0, 0, Spacing, 0)
            if (i == 1) then
                Col.Paint = function(s, w, h)
                    draw.SimpleText(Tab.Name, "gRust.32px", w * 0.5, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            else
                Col.Paint = function(s, w, h)
                    local alpha = RecipeItem and 100 or 50
                    gRust.DrawPanelColored(0, 0, w, h, ColorAlpha(gRust.Colors.Background, alpha))

                    local Value
                    if (i > 1 and RecipeItem) then
                        Value = (i > 1) and Tab.Value(self, item, i - 1)
                    end
                    
                    if (Value) then
                        local col = (RecipeItem and LocalPlayer():HasItem(RecipeItem.Item, RecipeItem.Quantity * self:GetMultiplier())) and gRust.Colors.Text or Color(254, 204, 91)
                        local x
                        if (Tab.Align == TEXT_ALIGN_RIGHT) then
                            x = w - 10 * gRust.Hud.Scaling
                        elseif (Tab.Align == TEXT_ALIGN_LEFT) then
                            x = 10 * gRust.Hud.Scaling
                        else
                            x = w * 0.5
                        end
                        
                        draw.SimpleText(Value, "gRust.RecipeTable", x, h * 0.5, col, Tab.Align, TEXT_ALIGN_CENTER)
                    end
                end
            end
        end
    end
    
    self:SetDirty(false)
end

function PANEL:PerformLayout()

end

function PANEL:Think()
    if self:GetDirty() then
        self:Rebuild()
        self:SetDirty(false)
    end
end

vgui.Register("gRust.RecipeTable", PANEL, "Panel")