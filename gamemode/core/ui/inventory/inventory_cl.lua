local InOutTime = 0.1
local StartRatio = 0.825

local function ConstructLeftPanel(panel)
    local AttireSlotSize = math.Round(100 * gRust.Hud.Scaling)
    
    local Teams = panel:Add("Panel")
    Teams:Dock(BOTTOM)
    Teams:SetTall(gRust.Hud.Scaling * 160)
    local margin = 32 * gRust.Hud.Scaling
    Teams:DockMargin(0, margin, margin, 0)

    local pl = LocalPlayer()
    local ReconstructTeamPanel = function()
        if (IsValid(Teams.Container)) then
            Teams.Container:Remove()
        end

        Teams.Container = Teams:Add("Panel")
        Teams.Container:Dock(FILL)
        
        if (pl.TeamID) then
            local LeaveButton = Teams.Container:Add("gRust.Button")
            LeaveButton:SetWide(280 * gRust.Hud.Scaling)
            LeaveButton:SetTall(56 * gRust.Hud.Scaling)
            LeaveButton:SetText("LEAVE TEAM")
            LeaveButton:SetFont("gRust.34px")
            LeaveButton:SetDefaultColor(ColorAlpha(gRust.Colors.Panel, 25))
            LeaveButton:SetHoveredColor(ColorAlpha(gRust.Colors.Panel, 100))
            LeaveButton:SetSelectedColor(ColorAlpha(gRust.Colors.Panel, 175))
            LeaveButton:SetLerpTime(0.05)
            LeaveButton.DoClick = function(me)
                gRust.LeaveTeam()
            end

            Teams.Container.PerformLayout = function(self)
                local w, h = self:GetSize()
                local bw, bh = LeaveButton:GetSize()
                LeaveButton:SetPos(w - bw - margin, margin)
            end
        else
            if (IsValid(pl.TeamInvite)) then
                local margin = 16 * gRust.Hud.Scaling
                Teams.Container:DockPadding(margin * 4, margin, margin * 4, margin)
                Teams.Container.Paint = function(me, w, h)
                    gRust.DrawPanel(0, 0, w, h)
                end

                local ButtonContainer = Teams.Container:Add("Panel")
                ButtonContainer:Dock(BOTTOM)
                ButtonContainer:SetTall(50 * gRust.Hud.Scaling)
                ButtonContainer:DockMargin(margin, margin, margin, margin)

                local buttonWide = 240 * gRust.Hud.Scaling

                local AcceptButton = ButtonContainer:Add("gRust.Button")
                AcceptButton:Dock(LEFT)
                AcceptButton:SetWide(buttonWide)
                AcceptButton:SetText("ACCEPT")
                AcceptButton:SetDefaultColor(Color(97, 119, 59))
                AcceptButton:SetHoveredColor(Color(127, 169, 55))
                AcceptButton:SetSelectedColor(Color(144, 197, 52))
                AcceptButton:SetTextColor(Color(167, 213, 75))
                AcceptButton.DoClick = function(me)
                    gRust.AcceptTeamInvite()
                end

                local DeclineButton = ButtonContainer:Add("gRust.Button")
                DeclineButton:Dock(RIGHT)
                DeclineButton:SetWide(buttonWide)
                DeclineButton:SetText("DECLINE")
                DeclineButton.DoClick = function(me)
                    gRust.DeclineTeamInvite()
                end

                local Label = Teams.Container:Add("gRust.Label")
                Label:Dock(FILL)
                Label:SetText(string.format("%s has invited you to join a team", pl.TeamInvite:Nick()))
                Label:SetContentAlignment(5)
                Label:SetTextColor(gRust.Colors.Text)
                Label:SetFont("gRust.36px")
            else
                local TeamButton = Teams.Container:Add("gRust.Button")
                TeamButton:SetWide(280 * gRust.Hud.Scaling)
                TeamButton:SetTall(56 * gRust.Hud.Scaling)
                TeamButton:SetText("CREATE TEAM")
                TeamButton:SetFont("gRust.34px")
                TeamButton:SetDefaultColor(ColorAlpha(gRust.Colors.Panel, 25))
                TeamButton:SetHoveredColor(ColorAlpha(gRust.Colors.Panel, 100))
                TeamButton:SetSelectedColor(ColorAlpha(gRust.Colors.Panel, 175))
                TeamButton:SetLerpTime(0.05)
                TeamButton.DoClick = function(me)
                    gRust.CreateTeam()
                end
    
                Teams.Container.PerformLayout = function(self)
                    local w, h = self:GetSize()
                    local bw, bh = TeamButton:GetSize()
                    TeamButton:SetPos(w / 2 - bw / 2, h / 2 - bh / 2)
                end
            end
        end
    end

    ReconstructTeamPanel()
    hook.Add("gRust.UpdateTeamUI", Teams, ReconstructTeamPanel)

    local AttireSlots = panel:Add("gRust.Grid")
    AttireSlots:Dock(BOTTOM)
    AttireSlots:SetTall(AttireSlotSize)
    AttireSlots:SetCols(7)
    AttireSlots:SetColWide(AttireSlotSize)
    AttireSlots:SetRowTall(AttireSlotSize)
    AttireSlots:SetCellSpacing(gRust.Hud.SlotPadding)
    AttireSlots:SetRows(1)

    local attire = pl.Attire
    for i = 1, attire:GetSize() do
        local slot = AttireSlots:Add("gRust.Slot")
        slot:SetSize(AttireSlotSize, AttireSlotSize)
        slot:SetInventory(attire)
        slot:SetSlot(i)
    end

    local Stats = panel:Add("Panel")
    Stats:Dock(RIGHT)
    Stats:SetWide(160 * gRust.Hud.Scaling)
    Stats:DockMargin(0, 140 * gRust.Hud.Scaling, 30 * gRust.Hud.Scaling, 100 * gRust.Hud.Scaling)

    local Name = Stats:Add("gRust.Label")
    Name:Dock(TOP)
    Name:SetText(pl:Nick())
    Name:SetTextSize(48)
    Name:SetTall(48 * gRust.Hud.Scaling)
    Name:SetContentAlignment(6)
    Name:NoClipping(true)
    Name:SetTextColor(gRust.Colors.Text)
    Name:DockMargin(0, 0, 0, 16 * gRust.Hud.Scaling)

    local function AddStat(icon, key, dock, tooltip)
        local value = pl.AttireProtection and pl.AttireProtection[key] or 0
        value = math.Round(value * 100)

        local stat = Stats:Add("Panel")
        stat:Dock(dock)
        stat:SetTall(48 * gRust.Hud.Scaling)
        stat:DockMargin(0, 0, 0, 26 * gRust.Hud.Scaling)

        local Icon = stat:Add("gRust.Icon")
        Icon:Dock(RIGHT)
        Icon:SetSize(48 * gRust.Hud.Scaling, 48 * gRust.Hud.Scaling)
        Icon:SetIcon(icon)
        Icon:SetTooltip(tooltip)
        if (value <= 0) then
            Icon:SetColor(Color(200, 200, 200, 15))
        else
            Icon:SetColor(gRust.Colors.Text)
        end

        local Value = stat:Add("gRust.Label")
        Value:Dock(LEFT)
        Value:SetTextSize(38)
        Value:SetContentAlignment(5)
        Value:SetTextColor(gRust.Colors.Text)
        Value:NoClipping(true)

        if (value > 0) then
            Value:SetText(value .. " %")
        else
            Value:SetText("")
        end

        stat.Think = function(me)
            local value = pl.AttireProtection and pl.AttireProtection[key] or 0
            value = math.Round(value * 100)
            
            if (value <= 0) then
                Icon:SetColor(Color(200, 200, 200, 15))
            else
                Icon:SetColor(gRust.Colors.Text)
            end

            if (value > 0) then
                Value:SetText(value .. " %")
            else
                Value:SetText("")
            end
        end
    end

    AddStat("bullet", "Projectile", TOP, "Protection against firearms and arrows")
    AddStat("stab", "Melee", TOP, "Protection against melee and stabbing weapons")

    AddStat("bite", "Bite", BOTTOM, "Protection from wild animals")
    AddStat("radiation", "Radiation", BOTTOM, "Protection from radiation")
    AddStat("freezing", "Cold", BOTTOM, "Protection against the cold")
    AddStat("explosion", "Explosive", BOTTOM, "Protection from explosives")

    local PlayerModel = panel:Add("DModelPanel")
    PlayerModel:Dock(FILL)
    PlayerModel:SetModel(pl:GetModel())
    PlayerModel:SetFOV(22)
    PlayerModel:SetCursor("arrow")
    PlayerModel:SetAnimated(true)
    PlayerModel.Entity:SetAngles(Angle(0, 55, 0))
    PlayerModel.Children = {}
    PlayerModel.UpdateChildren = function(self)
        for i = 1, #self.Children do
            self.Children[i]:Remove()
        end

        local attire = pl.Attire
        for i = 1, attire:GetSlots() do
            local item = attire[i]
            if (!IsValid(item)) then continue end

            local register = item:GetRegister()
            local attireItem = register:GetAttire()
            local ent = attireItem:AddToEntity(PlayerModel.Entity)
            ent.AttireItem = attireItem

            PlayerModel.Children[#PlayerModel.Children + 1] = ent
        end
    end
    PlayerModel.LayoutEntity = function(self, ent)
        ent:SetPos(Vector(-32, -32, -4))
    end
    PlayerModel.Entity.GetPlayerColor = function() return pl:GetPlayerColor() end
    PlayerModel.OnMousePressed = function(self, code)
        if (code == MOUSE_LEFT) then
            self.PressPos = gui.MousePos()
        end
    end
    PlayerModel.Think = function(self)
        if (input.IsMouseDown(MOUSE_LEFT)) then
            if (!self.PressPos) then return end
            local x, y = gui.MousePos()
            local diff = (x - self.PressPos) * 0.4
            self.PressPos = x
            self.Entity:SetAngles(self.Entity:GetAngles() + Angle(0, diff, 0))
            self.LastDiff = diff
        else
            self.PressPos = nil
        end

        if (self:GetModel() != pl:GetModel()) then
            self:SetModel(pl:GetModel())
            self:SetAnimated(true)
            self.Entity:SetAngles(Angle(0, 55, 0))
            self.Entity.GetPlayerColor = function() return pl:GetPlayerColor() end
        end
    end
    local oldDrawModel = PlayerModel.DrawModel
    PlayerModel.DrawModel = function(self)
        oldDrawModel(self)

        for i = 1, #self.Children do
            local ent = self.Children[i]
            if (!IsValid(ent)) then continue end

            local boneName = ent.AttireItem:GetBone()
            if (!boneName) then continue end
            local bone = self.Entity:LookupAttachment(boneName)
            if (!bone) then continue end

            local attachment = self.Entity:GetAttachment(bone)
            if (!attachment) then continue end

            local pos = attachment.Pos

            pos = pos + ent:GetForward() * ent.AttireItem:GetPosition().x
            pos = pos + ent:GetRight() * ent.AttireItem:GetPosition().y
            pos = pos + ent:GetUp() * ent.AttireItem:GetPosition().z
            
            ent:SetPos(pos)
            ent:SetAngles(self.Entity:GetAngles() + ent.AttireItem:GetAngles())
            ent:DrawModel()
        end
    end
    local oldOnRemove = PlayerModel.OnRemove
    PlayerModel.OnRemove = function(self)
        oldOnRemove(self)

        for i = 1, #self.Children do
            self.Children[i]:Remove()
        end
    end

    PlayerModel:UpdateChildren()
    hook.Add("OnPlayerAttireUpdated", PlayerModel, function()
        PlayerModel:UpdateChildren()
    end)
end

local function ConstructMiddlePanel(panel)
    local pl = LocalPlayer()

    local Slots = panel:Add("gRust.Grid")
    Slots:Dock(BOTTOM)
    Slots:SetTall(gRust.Hud.SlotSize * 4 + gRust.Hud.SlotPadding * 3)
    Slots:SetCols(6)
    Slots:SetColWide(gRust.Hud.SlotSize)
    Slots:SetRowTall(gRust.Hud.SlotSize)
    Slots:SetCellSpacing(math.floor(gRust.Hud.SlotPadding))
    Slots:SetRows(4)

    local inventory = LocalPlayer().Inventory
    for i = 1, inventory:GetSize() do
        local slot = Slots:Add("gRust.Slot")
        slot:SetSize(gRust.Hud.SlotSize, gRust.Hud.SlotSize)
        slot:SetInventory(inventory)
        slot:SetSlot(i)
    end

    local InventoryText = panel:Add("gRust.Label")
    InventoryText:Dock(BOTTOM)
    InventoryText:SetText("INVENTORY")
    InventoryText:SetTextSize(48)
    InventoryText:SetTall(36)
    InventoryText:DockMargin(4, 0, 0, 0)
    InventoryText:SetTextColor(gRust.Colors.Text)

    local ItemData = panel:Add("gRust.ItemData")
    ItemData:Dock(BOTTOM)
    ItemData:SetTall(527 * gRust.Hud.Scaling)
    ItemData:DockMargin(0, 0, 0, gRust.Hud.Scaling * 10)
    ItemData:Rebuild()
    ItemData.ItemDropZone = true

    local ItemText = panel:Add("gRust.Label")
    ItemText:Dock(BOTTOM)
    ItemText:SetTextSize(48)
    ItemText:SetTall(48 * gRust.Hud.Scaling)
    ItemText:SetTextColor(gRust.Colors.Text)
    ItemText:SetText("")

    local UpdateItems = function(inventory, slot)
        ItemData:SetInventory(inventory)
        ItemData:SetSlot(slot)
        ItemData:Rebuild()
        if (inventory[slot]) then
            ItemText:SetText(inventory[slot]:GetRegister():GetName())
        else
            ItemText:SetText("")
        end
    end

    hook.Add("OnPlayerBeltUpdated", panel, function()
        local inv = IsValid(gRust.ActiveInventorySlot) and gRust.ActiveInventorySlot:GetInventory() or pl.Belt
        local slot = IsValid(gRust.ActiveInventorySlot) and gRust.ActiveInventorySlot:GetSlot() or gRust.Hotbar.SelectedSlot
        UpdateItems(inv, slot)
    end)

    hook.Add("OnPlayerInventoryUpdated", panel, function()
        local inv = IsValid(gRust.ActiveInventorySlot) and gRust.ActiveInventorySlot:GetInventory() or pl.Belt
        local slot = IsValid(gRust.ActiveInventorySlot) and gRust.ActiveInventorySlot:GetSlot() or gRust.Hotbar.SelectedSlot
        UpdateItems(inv, slot)
    end)

    hook.Add("OnInventorySlotSelected", panel, function()
        UpdateItems(gRust.ActiveInventorySlot:GetInventory(), gRust.ActiveInventorySlot:GetSlot())
    end)

    UpdateItems(pl.Belt, gRust.Hotbar.SelectedSlot)
end

local function CreateQuickCraft(panel)
    local QuickCraft = panel:Add("gRust.QuickCraft")
    QuickCraft:Dock(BOTTOM)

    local QuickCraftText = panel:Add("gRust.Label")
    QuickCraftText:Dock(BOTTOM)
    QuickCraftText:SetText("QUICK CRAFT")
    QuickCraftText:SetTextSize(48)
    QuickCraftText:SetTall(36)
    QuickCraftText:DockMargin(0, 0, 0, gRust.Hud.Scaling * 8)
    QuickCraftText:SetTextColor(gRust.Colors.Text)
end

local function ConstructRightPanel(panel)
    if (panel.Callback) then
        panel.Callback(panel)

        if (panel.Title) then
            local Title = panel:Add("gRust.Label")
            Title:Dock(BOTTOM)
            Title:SetText(panel.Title or "QUICK CRAFT")
            Title:SetTextSize(48)
            Title:SetTall(36)
            Title:DockMargin(0, 0, 0, gRust.Hud.Scaling * 16)
            Title:SetTextColor(gRust.Colors.Text2)
        end
    else
        CreateQuickCraft(panel)
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

    local CraftingButton = Tabs:Add("Panel")
    CraftingButton:Dock(LEFT)
    CraftingButton:SetWide(512 * gRust.Hud.Scaling)
    CraftingButton:DockMargin(ScrW() * 0.5 - 512 * gRust.Hud.Scaling * 0.5, 0, 0, 0)
    CraftingButton:SetCursor("hand")
    CraftingButton:SetTooltip("You can also press \"q\" to switch to crafting")
    CraftingButton.Paint = function(self, w, h)
        gRust.DrawPanelColored(0, 0, w, h, ButtonColor)

        draw.SimpleText("CRAFTING", "gRust.54px", w * 0.5 - (h * 0.5), h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(gRust.Colors.Text)
        surface.SetMaterial(gRust.GetIcon("enter"))
        surface.DrawTexturedRect(w - h, IconPadding, h - IconPadding * 2, h - IconPadding * 2)
    end
    CraftingButton.OnMousePressed = function(self)
        self.Clicked = true
    end
    CraftingButton.OnMouseReleased = function(self)
        if (self.Clicked) then
            self.Clicked = false
            gRust.CloseInventory()
            gRust.OpenCrafting()
            gui.EnableScreenClicker(true)
        end
    end
end

local BACKGROUND_COLOR = Color(37, 36, 31, 225)
local BACKGROUND_MATERIAL = Material("ui/background_linear.png", "noclamp smooth")
function gRust.OpenInventory(title, callback)
    if (!gRust.Hud.ShouldDraw) then return end
    
    if (IsValid(gRust.Inventory)) then
        return
    end

    local Root = vgui.Create("EditablePanel")
    Root:SetSize(ScrW(), ScrH())
    Root:Center()
    Root:SetPos(-ScrW() * (1 - StartRatio), 0)
    Root:SetAlpha(0)
    Root:AnimAlphaTo(255, InOutTime, nil, math.ease.OutBack)
    Root:AnimMoveTo(0, 0, InOutTime, nil, math.ease.OutSine)
    Root.ItemDropZone = true
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

    gRust.Inventory = Root

    TabButtons(Root)
    
    local Container = Root:Add("Panel")
    Container:Dock(BOTTOM)
    Container:SetTall(ScrH() * (gRust.Hud.AspectRatio / (2560 / 1440)))

    local HotbarWidth = gRust.Hud.SlotSize * 6 + gRust.Hud.SlotPadding * 5

    -- Left Panel

    local LeftPanel = Container:Add("Panel")
    LeftPanel:Dock(LEFT)
    LeftPanel:SetWide((ScrW() * 0.5) - (HotbarWidth * 0.5) + gRust.Hud.HotbarXOffset)
    LeftPanel:DockMargin(0, 0, 0, 70 * gRust.Hud.Scaling)
    LeftPanel:DockPadding(103 * gRust.Hud.Scaling, 0, 0, 0)
    LeftPanel.ItemDropZone = true

    ConstructLeftPanel(LeftPanel)

    -- Middle Panel

    local MiddlePanel = Container:Add("Panel")
    MiddlePanel:Dock(LEFT)
    MiddlePanel:SetWide(HotbarWidth)
    MiddlePanel:DockMargin(0, 0, 0, gRust.Hud.Margin - gRust.Hud.HotbarYOffset + gRust.Hud.SlotSize + gRust.Hud.SlotPadding * 2)
    MiddlePanel.ItemDropZone = true

    ConstructMiddlePanel(MiddlePanel)

    -- Right Panel

    local RightPanel = Container:Add("Panel")
    RightPanel:Dock(FILL)
    RightPanel:DockMargin(25 * gRust.Hud.Scaling, 0, 136 * gRust.Hud.Scaling, 216 * gRust.Hud.Scaling)
    RightPanel.ItemDropZone = true
    RightPanel.Title = title
    RightPanel.Callback = callback

    ConstructRightPanel(RightPanel)

    hook.Run("OnInventoryOpened", Root)
end

function gRust.CloseInventory()
    if (IsValid(gRust.Inventory)) then
        gui.EnableScreenClicker(false)
        gRust.Inventory:AnimAlphaTo(0, 0.2, nil, math.ease.OutCubic)
        gRust.Inventory:AnimMoveTo(-ScrW() * (1 - StartRatio), 0, 0.2, function()
            gRust.Inventory:Remove()
        end, math.ease.OutSine)

        hook.Run("OnInventoryClosed")
    end
end

function gRust.ToggleInventory()
    if (IsValid(gRust.Crafting)) then
        gRust.CloseCrafting()
    end

    if (IsValid(gRust.Inventory)) then
        gRust.CloseInventory()
    else
        gRust.OpenInventory()
    end
end

function GM:ScoreboardShow()
    gRust.ToggleInventory()

    return false
end

function GM:ScoreboardHide()
    return false
end

hook.Add("OnPauseMenuShow", "gRust.CloseInventory", function()
    if (IsValid(gRust.Inventory)) then
        gRust.CloseInventory()
        return false
    end
end)