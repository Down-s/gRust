local PANEL = {}

AccessorFunc(PANEL, "Dirty", "Dirty", FORCE_BOOL)
AccessorFunc(PANEL, "Cols", "Cols", FORCE_NUMBER)
AccessorFunc(PANEL, "ItemMargin", "ItemMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "IconMargin", "IconMargin", FORCE_NUMBER)

function PANEL:Init()
    self.Items = {}
    self.ItemIndices = {}
    self.CraftStates = {}

    self:SetCols(5)
    self:SetItemMargin(22 * gRust.Hud.Scaling)
end

function PANEL:Paint(w, h)
end

function PANEL:AddItem(name)
    self.Items[#self.Items + 1] = name
    self.ItemIndices[name] = #self.Items

    self:SetDirty(true)
end

function PANEL:ClearItems()
    self.Items = {}
    self.ItemIndices = {}

    for k, v in pairs(self:GetChildren()) do
        v:Remove()
    end

    self:SetDirty(true)
end

function PANEL:OnItemSelected(item)
    -- Override
end

function PANEL:Clear()
    for k, v in pairs(self:GetChildren()) do
        v:Remove()
    end
end

function PANEL:SetScrollable(b)
    self.Scrollable = b
    self:SetDirty(true)
end

local LOCK_MARGIN = 20 * gRust.Hud.Scaling
function PANEL:Rebuild()
    self:Clear()

    self.ItemPanels = {}

    local ItemMargin = self:GetItemMargin()
    if (self.Scrollable) then
        local Scroll = self:Add("gRust.Scroll")
        Scroll:Dock(FILL)

        self.Container = Scroll:Add("Panel")
    else
        self.Container = self:Add("Panel")
    end

    self.Container:Dock(FILL)
    self.Container:DockPadding(ItemMargin, ItemMargin, ItemMargin, ItemMargin)

    local pl = LocalPlayer()
    if not IsValid(pl) then return end

    local items = self.Items

    -- First only craftable
    table.sort(items, function(a, b)
        if (pl:CanCraft(a) and !pl:CanCraft(b)) then
            return true
        elseif (!pl:CanCraft(a) and pl:CanCraft(b)) then
            return false
        end

        return false
    end)

    local row
    local itemsInRow = 0
    local lastCanCraft = nil

    for i = 1, #items do
        local id = items[i]
        local item = gRust.GetItemRegister(id)

        if (item:GetResearchCost() and !pl:HasBlueprint(id)) then
            continue
        end

        local canCraft = pl:CanCraft(id)
        local bNewRow = false

        if (row == nil) then
            bNewRow = true
        elseif (itemsInRow >= self:GetCols()) then
            bNewRow = true
        elseif (lastCanCraft ~= nil and lastCanCraft ~= canCraft) then
            bNewRow = true
        end

        if (bNewRow) then
            row = self.Container:Add("Panel")
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, ItemMargin)
            row:InvalidateParent(true)
            itemsInRow = 0
        end

        lastCanCraft = canCraft

        local ItemPanel = row:Add("gRust.Button")
        ItemPanel:Dock(LEFT)
        ItemPanel:DockMargin(0, 0, ItemMargin, 0)
        ItemPanel:SetTooltip(string.upper(item:GetName()))
        ItemPanel.Paint = function(me, w, h)
            local IconMargin = self:GetIconMargin() or 0

            surface.SetDrawColor(200, 200, 200, pl:CanCraft(item:GetId()) and 255 or 100)
            surface.SetMaterial(item:GetIcon())
            surface.DrawTexturedRect(IconMargin, IconMargin, w - (IconMargin * 2), h - (IconMargin * 2))

            if (me:IsHovered()) then
                if (me:GetDown()) then
                    surface.SetDrawColor(255, 255, 255, 25)
                else
                    surface.SetDrawColor(200, 200, 200, 25)
                end
                surface.DrawRect(0, 0, w, h)
            end

            local amountMargin = 24 * gRust.Hud.Scaling
            local amount = gRust.GetCraftingAmount(id)
            if (amount ~= 0) then
                local width, height = surface.GetTextSize(amount)
                width = width + 12 * gRust.Hud.Scaling
                height = 32 * gRust.Hud.Scaling
                local padding = 4 * gRust.Hud.Scaling
                draw.RoundedBox(8, w - width - amountMargin, h - height - amountMargin, width, height, Color(140, 186, 59, 15))
                draw.SimpleText(amount, "gRust.32px", (w - width - amountMargin) + width / 2, (h - height - amountMargin) + height / 2, Color(140, 186, 59), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        ItemPanel.DoClick = function(me)
            self:OnItemSelected(id)
        end
        ItemPanel.DoDoubleClick = function(me)
            gRust.Craft(id, 1)
        end

        self.ItemPanels[#self.ItemPanels + 1] = ItemPanel
        itemsInRow = itemsInRow + 1
    end

    self:InvalidateLayout(true)
end

function PANEL:Think()
    local pl = LocalPlayer()
    if IsValid(pl) then
        local stateChanged = false
        for i = 1, #self.Items do
            local id = self.Items[i]
            local canCraft = pl:CanCraft(id)

            if self.CraftStates[id] ~= canCraft then
                self.CraftStates[id] = canCraft
                stateChanged = true
            end
        end

        if stateChanged then
            self:SetDirty(true)
        end
    end

    if (self:GetDirty()) then
        self:Rebuild()
        self:SetDirty(false)
    end
end


function PANEL:PerformLayout(w, h)
    if (!self.ItemPanels) then return end

    for i = 1, #self.ItemPanels do
        local itemPanel = self.ItemPanels[i]
        itemPanel:SetWide((w - (self:GetItemMargin() * (self:GetCols() + 1))) / self:GetCols())
    end

    for k, v in pairs(self.Container:GetChildren()) do
        v:SetTall((w - (self:GetItemMargin() * (self:GetCols() + 1))) / self:GetCols())
    end
end

vgui.Register("gRust.CraftGrid", PANEL, "Panel")
