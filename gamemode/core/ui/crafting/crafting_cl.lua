local InOutTime = 0.1
local StartRatio = 0.825

local SelectedCategory = "Common"
local SelectedItem = "rock"
local SearchString = ""

local function LightenColor(col, amt)
    local r = col.r + amt
    local g = col.g + amt
    local b = col.b + amt
    local a = col.a + amt
    return Color(r, g, b, a)
end

local TextColor = ColorAlpha(gRust.Colors.Text, 50)
local CategoryTextColor = ColorAlpha(gRust.Colors.Text, 120)
local CategoryIconColor = ColorAlpha(gRust.Colors.Text, 10)
local ItemCountColor = Color(55, 150, 167, 90)
local function ConstructLeftPanel(panel)
    local padding = 16 * gRust.Hud.Scaling
    local CraftingQueue = panel:Add("Panel")
    CraftingQueue:Dock(BOTTOM)
    CraftingQueue:SetTall(144 * gRust.Hud.Scaling)
    CraftingQueue:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)
    CraftingQueue:DockPadding(padding, padding, padding, padding)
    CraftingQueue.Paint = function(self, w, h)
        gRust.DrawPanel(0, 0, w, h)
        draw.SimpleText("CRAFTING QUEUE", "gRust.118px", 16 * gRust.Hud.Scaling, h * 0.5, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local pl = LocalPlayer()
    
    local function UpdateCraftingQueue()
        if (!pl.CraftQueue) then return end

        for k, v in ipairs(CraftingQueue:GetChildren()) do
            v:Remove()
        end

        local timeLeft = 0
        for i = 1, #pl.CraftQueue do
            local item = pl.CraftQueue[i]

            local Item = CraftingQueue:Add("DButton")
            Item:Dock(RIGHT)
            Item:SetWide(144 * gRust.Hud.Scaling - padding * 2)
            Item:DockMargin(padding, 0, 0, 0)
            Item:SetCursor("hand")
            Item:SetText("")
            Item.Paint = function(me, w, h)
                local register = gRust.GetItemRegister(item.Item)
                if (!register) then return end

                surface.SetDrawColor(color_white)
                surface.SetMaterial(register:GetIcon())
                surface.DrawTexturedRect(0, 0, w, h)

                if (i == 1) then
                    -- Time left
    
                    draw.RoundedBox(8, 4 * gRust.Hud.Scaling, 4 * gRust.Hud.Scaling, 64 * gRust.Hud.Scaling, 28 * gRust.Hud.Scaling, Color(164, 233, 47, 2150))
                    
                    surface.SetDrawColor(44, 62, 4)
                    surface.SetMaterial(gRust.GetIcon("stopwatch"))
                    surface.DrawTexturedRect(8 * gRust.Hud.Scaling, 6 * gRust.Hud.Scaling, 24 * gRust.Hud.Scaling, 24 * gRust.Hud.Scaling)
    
                    local timeLeft = (item.End or CurTime()) - CurTime()
                    local finish = math.ceil(timeLeft)
                    if (finish < 0) then finish = 0 end
    
                    draw.SimpleText(finish .. "s", "gRust.24px", 36 * gRust.Hud.Scaling, 18 * gRust.Hud.Scaling, Color(44, 62, 4), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
    
                -- Craft amount

                if (item.Amount > 1) then
                    local width = 42 * gRust.Hud.Scaling
                    local height = 28 * gRust.Hud.Scaling
                    local margin = 4 * gRust.Hud.Scaling
                    draw.RoundedBox(8, w - width - margin, h - height - margin, width, height, Color(247, 236, 226, 255))
    
                    draw.SimpleText("x" .. item.Amount, "gRust.28px", w - margin - width * 0.5, h - margin - height * 0.5, Color(74, 68, 61), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                if (me:IsHovered()) then
                    local margin = 8 * gRust.Hud.Scaling
                    surface.SetDrawColor(ColorAlpha(gRust.Colors.Primary, 200))
                    surface.SetMaterial(gRust.GetIcon("close"))
                    surface.DrawTexturedRect(margin, margin, w - margin * 2, h - margin * 2)
                end
            end
            Item.DoClick = function(self)
                gRust.PlaySound("ui.select")
                gRust.RemoveFromCraftingQueue(i)
            end
        end
    end

    UpdateCraftingQueue()
    hook.Add("gRust.CraftQueueUpdated", CraftingQueue, UpdateCraftingQueue)
    
    local Container = panel:Add("Panel")
    Container:Dock(FILL)

    local Categories = Container:Add("gRust.Panel")
    Categories:Dock(LEFT)
    Categories:SetWide(280 * gRust.Hud.Scaling)
    Categories:DockMargin(0, 0, 6 * gRust.Hud.Scaling, 0)

    local itemCategories = gRust.GetCategories()
    for i = 1, #itemCategories do
        local cat = itemCategories[i]
        if (!cat.Visible) then continue end

        local Category = Categories:Add("gRust.Button")
        Category:Dock(TOP)
        Category:SetTall(66 * gRust.Hud.Scaling)
        Category:SetCursor("hand")
        Category.HoveredTime = 0
        Category.bHovered = false
        Category.AnimScale = 1
        Category.Brightness = 0
        Category.Matrix = Matrix()
        if (SelectedCategory == cat.Name) then
            Category.ClickTime = CurTime()
        end
        local AnimTime = 0.5
        local AnimIntensity = 0.11
        Category.DoClick = function(self)
            gRust.PlaySound("ui.select")
            if (SelectedCategory == cat.Name) then return end
            
            self.ClickTime = CurTime()
            SelectedCategory = cat.Name

            gRust.Crafting.ItemGrid:Rebuild()
        end
        Category.Paint = function(self, w, h)
            cam.PushModelMatrix(self.Matrix)

            do -- Animate
                local x, y = self:LocalToScreen(0, 0)
                local w, h = self:GetWide(), self:GetTall()
                x = x + w * 0.5
                y = y + h * 0.5

                if (vgui.GetHoveredPanel() == self || SelectedCategory == cat.Name) then
                    self.Brightness = Lerp(FrameTime() / 0.1, self.Brightness, 1)
                    if (!self.bHovered && SelectedCategory ~= cat.Name) then
                        self.bHovered = true
                        self.HoveredTime = CurTime()
                        gRust.PlaySound("ui.blip")
                    end
                else
                    self.Brightness = Lerp(FrameTime() / 0.1, self.Brightness, 0)
                    if (self.bHovered) then
                        self.bHovered = false
                    end
                end
                
                local t = Lerp((CurTime() - self.HoveredTime) / AnimTime, 0, 1)
            
                self.AnimScale = (gRust.Anim.Punch(t) * AnimIntensity) + 1

                if (SelectedCategory == cat.Name) then
                    self.AnimScale = Lerp(self.ClickTime and (CurTime() - self.ClickTime) / 0.075 or 0, self.AnimScale, 1.09)

                    local clickProgress = self.ClickTime and (CurTime() - self.ClickTime) / 0.04
                    if (clickProgress) then
                        gRust.DrawPanelColored(w - (clickProgress * w), 0, (clickProgress * w), h, Color(49, 116, 175, clickProgress * 255))
                    end
                end
                
                Category.Matrix:Identity()
                Category.Matrix:Translate(Vector(x, y))
                Category.Matrix:SetScale(Vector(1, 1, 1) * self.AnimScale)
                Category.Matrix:Translate(Vector(-x, -y))
            end

            local IconColor = LightenColor(CategoryIconColor, self.Brightness * 50)
            local TextColor = LightenColor(CategoryTextColor, self.Brightness * 50)
            local CountColor = LightenColor(ItemCountColor, self.Brightness * 50)

            surface.SetDrawColor(IconColor)
            surface.SetMaterial(gRust.GetIcon(cat.Icon))
            surface.DrawTexturedRect(16 * gRust.Hud.Scaling, 16 * gRust.Hud.Scaling, 32 * gRust.Hud.Scaling, 32 * gRust.Hud.Scaling)

            draw.SimpleText(string.upper(cat.Name), "gRust.30px", 64 * gRust.Hud.Scaling, h * 0.5, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(#cat.Items, "gRust.30px", w - 16 * gRust.Hud.Scaling, h * 0.5, CountColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            cam.PopModelMatrix()
        end
    end

    local Items = Container:Add("Panel")
    Items:Dock(FILL)

    local SearchBar = Items:Add("gRust.Input")
    SearchBar:Dock(BOTTOM)
    SearchBar:SetTall(64 * gRust.Hud.Scaling)
    SearchBar:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)
    SearchBar:SetPlaceholder("Search...")
    SearchBar:SetMargin(20 * gRust.Hud.Scaling, 0, 0, 0)
    SearchBar.OnValueChanged = function(self, value)
        SearchString = value
        gRust.Crafting.ItemGrid:Rebuild()
    end

    local Craftables = Items:Add("gRust.Panel")
    Craftables:Dock(FILL)

    gRust.Crafting.ItemGrid = Craftables:Add("gRust.CraftGrid")
    gRust.Crafting.ItemGrid:Dock(FILL)
    gRust.Crafting.ItemGrid:SetScrollable(true)
    gRust.Crafting.ItemGrid:DockMargin(0, 28 * gRust.Hud.Scaling, 0, 0)
    local Rebuild = gRust.Crafting.ItemGrid.Rebuild
    gRust.Crafting.ItemGrid.Rebuild = function(self)
        self:ClearItems()
        --[[for k, v in ipairs(gRust.GetItems()) do
            local item = gRust.GetItemRegister(v)
            if (item:GetCategory() == SelectedCategory) then
                self:AddItem(v)
            end
        end]]

        if (SearchString and string.len(SearchString) > 0) then
            for k, v in ipairs(gRust.GetItems()) do
                local item = gRust.GetItemRegister(v)
                if (!item:GetCraftable()) then continue end
                if (!item:GetRecipe()) then continue end

                if (string.find(string.lower(item:GetName()), string.lower(SearchString))) then
                    self:AddItem(v)
                end
            end
        else
            local items = gRust.GetCategory(SelectedCategory).Items
            for k, v in ipairs(items) do
                local register = gRust.GetItemRegister(v)
                if (!register:GetCraftable()) then continue end
                if (!register:GetRecipe()) then continue end
                -- if (!LocalPlayer():HasBlueprint(v)) then continue end
                self:AddItem(v)
            end
        end
        
        Rebuild(self)
    end
    gRust.Crafting.ItemGrid.OnItemSelected = function(self, item)
        gRust.Crafting:SelectItem(item)
    end

    gRust.Crafting.ItemGrid:Rebuild()
end

surface.CreateFont("gRust.Crafting.Description", {
    font = "Roboto Condensed",
    size = 32 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

local BounceIntensity = 0.075
local function ConstructRightPanel(panel, dontanimate)
    local Item = gRust.GetItemRegister(SelectedItem)
    
    panel.StartTime = CurTime()
    panel.Matrix = Matrix()
    panel:SetPaintedManually(true)
    hook.Add("PostRenderVGUI", panel, function(self)
        if (!dontanimate) then
            cam.PushModelMatrix(self.Matrix)
    
            local mx, my = self:LocalToScreen(0, 0)
            local mw, mh = self:GetWide(), self:GetTall()
            mx = mx + mw * 0.5
            my = my + mh * 0.5
    
            local t = Lerp((CurTime() - self.StartTime) / 0.15, 0, 1)
            local scale = (1 - BounceIntensity) + (BounceIntensity * math.ease.OutBack(t))
            
            surface.SetAlphaMultiplier(t)

            self.Matrix:Translate(Vector(mx, my))
            self.Matrix:SetScale(Vector(1, 1, 1) * scale)
            self.Matrix:Translate(Vector(-mx, -my))
        end

        self:PaintManual(w, h)

        if (!dontanimate) then
            surface.SetAlphaMultiplier(1)
            cam.PopModelMatrix()
        end
    end)

    local Padding = 8 * gRust.Hud.Scaling

    local CraftingPanel = panel:Add("gRust.Panel")
    CraftingPanel:Dock(BOTTOM)
    CraftingPanel:SetTall(314 * gRust.Hud.Scaling)
    CraftingPanel:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)
    CraftingPanel:DockPadding(Padding, Padding, Padding, Padding)

    local RecipeTable = CraftingPanel:Add("gRust.RecipeTable")
    RecipeTable:Dock(FILL)
    RecipeTable:SetItemId(SelectedItem)

    local CraftOptions = CraftingPanel:Add("Panel")
    CraftOptions:Dock(BOTTOM)
    CraftOptions:SetTall(64 * gRust.Hud.Scaling)
    CraftOptions:DockMargin(0, 12 * gRust.Hud.Scaling, 0, 0)

    local SubtractQuantity = CraftOptions:Add("gRust.Button")
    SubtractQuantity:Dock(LEFT)
    SubtractQuantity:SetWide(79 * gRust.Hud.Scaling)
    SubtractQuantity:SetIcon("subtract")
    SubtractQuantity:SetIconPadding(14 * gRust.Hud.Scaling)

    local Quantity = CraftOptions:Add("gRust.Input")
    Quantity:Dock(LEFT)
    Quantity:SetWide(128 * gRust.Hud.Scaling)
    Quantity:SetValue(1)
    Quantity:DockMargin(8 * gRust.Hud.Scaling, 0, 8 * gRust.Hud.Scaling, 0)

    local AddQuantity = CraftOptions:Add("gRust.Button")
    AddQuantity:Dock(LEFT)
    AddQuantity:SetWide(79 * gRust.Hud.Scaling)
    AddQuantity:SetIcon("add")
    AddQuantity:SetIconPadding(14 * gRust.Hud.Scaling)

    local MaxQuantity = CraftOptions:Add("gRust.Button")
    MaxQuantity:Dock(LEFT)
    MaxQuantity:SetWide(79 * gRust.Hud.Scaling)
    MaxQuantity:SetIcon("maximum")
    MaxQuantity:SetIconPadding(14 * gRust.Hud.Scaling)
    MaxQuantity:DockMargin(8 * gRust.Hud.Scaling, 0, 0, 0)

    local CraftButton = CraftOptions:Add("gRust.Button")
    CraftButton:Dock(RIGHT)
    CraftButton:SetWide(192 * gRust.Hud.Scaling)
    CraftButton:SetText("CRAFT")
    -- DoClick is at the bottom of this function

    AddQuantity.DoClick = function(self)
        local value = tonumber(Quantity:GetValue())
        if (value < 10) then
            Quantity:SetValue(value + 1)
            RecipeTable:SetMultiplier(value + 1)
        end
    end

    SubtractQuantity.DoClick = function(self)
        local value = tonumber(Quantity:GetValue())
        if (value > 1) then
            Quantity:SetValue(value - 1)
            RecipeTable:SetMultiplier(value - 1)
        end
    end

    MaxQuantity.DoClick = function(self)
        Quantity:SetValue(10)
        RecipeTable:SetMultiplier(10)
    end

    --local SkinsPanel = panel:Add("gRust.Panel")
    --SkinsPanel:Dock(BOTTOM)
    --SkinsPanel:SetTall(294 * gRust.Hud.Scaling)
    --SkinsPanel:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)

    local ItemContainer = panel:Add("gRust.Panel")
    ItemContainer:Dock(FILL)
    ItemContainer:DockPadding(Padding, Padding, Padding, Padding)

    local ItemInfo = ItemContainer:Add("Panel")
    ItemInfo:Dock(TOP)
    ItemInfo:SetTall(114 * gRust.Hud.Scaling)

    local ItemIcon = ItemInfo:Add("gRust.Icon")
    ItemIcon:Dock(LEFT)
    ItemIcon:SetWide(114 * gRust.Hud.Scaling)
    ItemIcon:SetMaterial(Item:GetIcon())
    ItemIcon:SetPadding(8 * gRust.Hud.Scaling)
    ItemIcon:DockMargin(12 * gRust.Hud.Scaling, 0, 0, 0)

    local StatFont = "gRust.38px"
    local StatColor = ColorAlpha(gRust.Colors.Text, 150)
    local StatPadding = 16 * gRust.Hud.Scaling
    local StatBackground = Color(0, 0, 0, 75)
    local IconSize = 38 * gRust.Hud.Scaling

    local ItemStats = ItemInfo:Add("Panel")
    ItemStats:Dock(RIGHT)
    ItemStats:SetWide(162 * gRust.Hud.Scaling)

    local function AddStat(txt, icon)
        local Container = ItemStats:Add("Panel")
        Container:Dock(TOP)
        Container:SetTall(54 * gRust.Hud.Scaling)
        Container:DockMargin(0, 0, 0, 6 * gRust.Hud.Scaling)

        surface.SetFont(StatFont)
        local tw, th = surface.GetTextSize(txt)

        local StatContainer = Container:Add("Panel")
        StatContainer:Dock(RIGHT)
        StatContainer:SetWide(tw + StatPadding * 2 + IconSize + 12 * gRust.Hud.Scaling)
        StatContainer.Paint = function(self, w, h)
            gRust.DrawPanelColored(0, 0, w, h, StatBackground)
            draw.SimpleText(txt, StatFont, w - StatPadding, h * 0.5, StatColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            surface.SetMaterial(gRust.GetIcon(icon))
            surface.SetDrawColor(StatColor)
            surface.DrawTexturedRect(w - StatPadding * 1.5 - IconSize - tw, h * 0.5 - IconSize * 0.5, IconSize, IconSize)
        end
    end

    AddStat(string.format("%.1f", Item:GetCraftTime()), "stopwatch")
    AddStat(string.format("%i", Item:GetCraftAmount()), "authorize")

    local TitleContainer = ItemInfo:Add("Panel")
    TitleContainer:Dock(FILL)

    local ItemName = TitleContainer:Add("gRust.Label")
    ItemName:Dock(FILL)
    ItemName:SetFont("gRust.52px")
    ItemName:SetText(string.upper(Item:GetName()))
    ItemName:SetTextColor(gRust.Colors.Text)
    ItemName:SetContentAlignment(5)

    local WorkbenchTier = TitleContainer:Add("gRust.WorkbenchTier")
    WorkbenchTier:Dock(BOTTOM)
    WorkbenchTier:SetTall(48 * gRust.Hud.Scaling)
    WorkbenchTier:SetTier(Item:GetTier())

    local FavouriteContainer = ItemContainer:Add("Panel")
    FavouriteContainer:Dock(TOP)
    FavouriteContainer:SetTall(30 * gRust.Hud.Scaling)

    local FavouriteButton = FavouriteContainer:Add("gRust.Button")
    FavouriteButton:Dock(LEFT)
    FavouriteButton:SetWide(140 * gRust.Hud.Scaling)
    FavouriteButton:SetIcon("favorite.inactive")
    FavouriteButton:SetText("FAVOURITED")
    FavouriteButton:SetFont("gRust.20px")
    FavouriteButton:SetIconPadding(4 * gRust.Hud.Scaling)
    FavouriteButton:SetContentAlignment(5)
    FavouriteButton:SetOffset(8 * gRust.Hud.Scaling)

    local ItemStatsContainer = ItemContainer:Add("Panel")
    ItemStatsContainer:Dock(RIGHT)
    ItemStatsContainer:SetWide(436 * gRust.Hud.Scaling)
    ItemStatsContainer:DockMargin(0, 0, 8 * gRust.Hud.Scaling, 12 * gRust.Hud.Scaling)

    local ItemStats = ItemStatsContainer:Add("gRust.ItemInfo")
    ItemStats:Dock(BOTTOM)
    ItemStats:SetTall(264 * gRust.Hud.Scaling)
    ItemStats:Rebuild()

    local DescriptionMargin = 24 * gRust.Hud.Scaling
    local ItemDescription = ItemContainer:Add("gRust.Label")
    ItemDescription:Dock(FILL)
    ItemDescription:SetFont("gRust.Crafting.Description")
    ItemDescription:SetText(Item:GetDescription())
    ItemDescription:SetTextColor(gRust.Colors.Text)
    ItemDescription:SetContentAlignment(7)
    ItemDescription:SetWrap(true)
    ItemDescription:DockMargin(DescriptionMargin, DescriptionMargin, DescriptionMargin, DescriptionMargin)

    CraftButton.DoClick = function(me, w, h)
        local itemTier = Item:GetTier()
        if (itemTier && itemTier > 0) then
            local workbenchTier = LocalPlayer():GetWorkbenchTier()
            if (workbenchTier < Item:GetTier()) then
                WorkbenchTier:Wiggle()
                return
            end
        end

        gRust.Craft(SelectedItem, tonumber(Quantity:GetValue()))
    end
end

local ButtonColor = Color(250, 240, 220, 40)
local function TabButtons(panel)
    local ButtonTall = 96 * gRust.Hud.Scaling
    local IconPadding = 16 * gRust.Hud.Scaling

    local Tabs = panel:Add("Panel")
    Tabs:SetTall(ButtonTall)
    Tabs:Dock(TOP)
    Tabs:SetZPos(100)

    local InventoryButton = Tabs:Add("Panel")
    InventoryButton:Dock(LEFT)
    InventoryButton:SetWide(512 * gRust.Hud.Scaling)
    InventoryButton:DockMargin(ScrW() * 0.5 - 512 * gRust.Hud.Scaling * 0.5, 0, 0, 0)
    InventoryButton:SetCursor("hand")
    InventoryButton:SetTooltip("You can also press \"tab\" to switch to inventory")
    InventoryButton.Paint = function(self, w, h)
        gRust.DrawPanelColored(0, 0, w, h, ButtonColor)

        draw.SimpleText("INVENTORY", "gRust.54px", w * 0.5 + (h * 0.5), h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(gRust.Colors.Text)
        surface.SetMaterial(gRust.GetIcon("exit"))
        surface.DrawTexturedRect(IconPadding * 3, IconPadding, h - IconPadding * 2, h - IconPadding * 2)
    end
    InventoryButton.OnMousePressed = function(self)
        self.Clicked = true
    end
    InventoryButton.OnMouseReleased = function(self)
        if (self.Clicked) then
            self.Clicked = false
            gRust.CloseCrafting()
            gRust.OpenInventory()
        end
    end
end

local BACKGROUND_COLOR = Color(37, 36, 31, 225)
local BACKGROUND_MATERIAL = Material("ui/background_linear.png", "noclamp smooth")
function gRust.OpenCrafting()
    if (!gRust.Hud.ShouldDraw) then return end

    SearchString = ""

    local Root = vgui.Create("EditablePanel")
    Root:SetSize(ScrW(), ScrH())
    Root:Center()
    Root:SetPos(ScrW() * (1 - StartRatio), 0)
    Root:SetAlpha(0)
    Root:AnimAlphaTo(255, InOutTime, nil, math.ease.OutBack)
    Root:AnimMoveTo(0, 0, InOutTime, nil, math.ease.OutSine)
    Root:SetKeyboardInputEnabled(true)
    Root.EnterTime = RealTime()
    gui.EnableScreenClicker(true)
    Root.Paint = function(self, w, h)
        local blur = Lerp((RealTime() - self.EnterTime) / 0.1, 0, 4)
        gRust.DrawPanelBlurred(0, 0, w, h, blur, BACKGROUND_COLOR, self)

        surface.SetDrawColor(BACKGROUND_COLOR)
        surface.SetMaterial(BACKGROUND_MATERIAL)
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)

        surface.SetDrawColor(Color(115, 140, 68, 2))
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)
    end

    gRust.Crafting = Root

    TabButtons(Root)
    
    local Container = Root:Add("Panel")
    Container:Dock(FILL)
    Container:DockMargin(140 * gRust.Hud.Scaling, 0, 172 * gRust.Hud.Scaling, 232 * gRust.Hud.Scaling)

    local Crafting = Container:Add("Panel")
    Crafting:Dock(BOTTOM)
    Crafting:SetTall(1105 * gRust.Hud.Scaling)

    local LeftPanel = Crafting:Add("Panel")
    LeftPanel:Dock(LEFT)
    LeftPanel:SetWide(1120 * gRust.Hud.Scaling)
    LeftPanel:DockMargin(0, 0, 6 * gRust.Hud.Scaling, 0)
    
    ConstructLeftPanel(LeftPanel)

    gRust.Crafting.SelectItem = function(me, item)
        --if (IsValid(gRust.Crafting.RightPanel) and SelectedItem == item) then return end

        local dontanimate = true
        if (IsValid(gRust.Crafting.RightPanel)) then
            gRust.Crafting.RightPanel:Remove()
            dontanimate = false
        end

        gRust.Crafting.RightPanel = Crafting:Add("Panel")
        gRust.Crafting.RightPanel:Dock(FILL)

        SelectedItem = item

        ConstructRightPanel(gRust.Crafting.RightPanel, dontanimate)
    end

    gRust.Crafting:SelectItem(SelectedItem)

    hook.Run("OnCraftingOpened", Root)
end

function gRust.CloseCrafting()
    if (IsValid(gRust.Crafting)) then
        gRust.Crafting.RightPanel:SetPaintedManually(false)
        hook.Remove("PostRenderVGUI", gRust.Crafting.RightPanel)

        gui.EnableScreenClicker(false)
        gRust.Crafting:AnimAlphaTo(0, 0.2, nil, math.ease.OutCubic)
        gRust.Crafting:AnimMoveTo(ScrW() * (1 - StartRatio), 0, 0.2, function()
            gRust.Crafting:Remove()
        end, math.ease.OutSine)

        hook.Run("OnCraftingClosed")
    end
end

function gRust.ToggleCrafting()
    if (IsValid(gRust.Inventory)) then
        gRust.CloseInventory()
    end

    if (IsValid(gRust.Crafting)) then
        gRust.CloseCrafting()
    else
        gRust.OpenCrafting()
    end
end

gRust.AddBind("+menu", function()
    gRust.ToggleCrafting()
end)

hook.Add("OnPauseMenuShow", "gRust.CloseCrafting", function()
    if (IsValid(gRust.Crafting)) then
        gRust.CloseCrafting()
        return false
    end
end)