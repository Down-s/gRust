include("shared.lua")

surface.CreateFont("gRust.Research.Text", {
    font = "Roboto Condensed",
    size = 32 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function ENT:OnStartLooting(pl)
    gRust.PlaySound("researchtable.open")
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("researchtable.close")
end

function ENT:GetInventoryName()
    return "RESEARCH TABLE"
end

local ERROR_COLOR = Color(171, 73, 58)
function ENT:CreateLootingPanel(panel)
    local margin = 8 * gRust.Hud.Scaling
    local padding = 24 * gRust.Hud.Scaling

    local ButtonContainer = panel:Add("gRust.Panel")
    ButtonContainer:Dock(BOTTOM)
    ButtonContainer:SetTall(96 * gRust.Hud.Scaling)
    ButtonContainer:DockMargin(0, margin, 0, 0)
    local buttonMargin = 16 * gRust.Hud.Scaling
    ButtonContainer:DockPadding(buttonMargin, buttonMargin, buttonMargin, buttonMargin)
    ButtonContainer.Think = function(me)
        local canResearch = self:CanResearchItem(LocalPlayer())
        if (IsValid(me.Button)) then
            if (!canResearch) then
                me.Button:Remove()
            end
        else
            if (canResearch) then
                me.Button = me:Add("gRust.Button")
                me.Button:Dock(RIGHT)
                me.Button:SetWide(256 * gRust.Hud.Scaling)
                me.Button:SetText("BEGIN RESEARCH")
                me.Button:SetFont("gRust.36px")
                me.Button:SetTall(64 * gRust.Hud.Scaling)
                me.Button:SetDefaultColor(Color(114, 134, 56))
                me.Button:SetHoveredColor(Color(98, 114, 32))
                me.Button:SetSelectedColor(Color(74, 90, 42))
                me.Button:SetTextColor(color_white)
                me.Button.DoClick = function(me)
                    net.Start("gRust.ResearchItem")
                        net.WriteEntity(self)
                    net.SendToServer()
                end
                local OldPaint = me.Button.Paint
                me.Button.Paint = function(me, w, h)
                    if (self:GetResearchFinish() != 0) then
                        surface.SetDrawColor(0, 0, 0, 200)
                        surface.DrawRect(0, 0, w, h)

                        local timeLeft = math.max(self:GetResearchFinish() - CurTime(), 0)
                        draw.SimpleText(string.format("%.2f", timeLeft), "gRust.52px", w / 2, h / 2, gRust.Colors.Text2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    else
                        OldPaint(me, w, h)
                    end
                end
            end
        end
    end

    local ScrapContainer = panel:Add("Panel")
    ScrapContainer:Dock(BOTTOM)
    ScrapContainer:SetTall(256 * gRust.Hud.Scaling)
    ScrapContainer:DockMargin(0, margin, 0, 0)

    local ScrapSlot = ScrapContainer:Add("gRust.Slot")
    ScrapSlot:Dock(LEFT)
    ScrapSlot:SetWide(256 * gRust.Hud.Scaling)
    ScrapSlot:DockMargin(0, 0, margin, 0)
    ScrapSlot:SetInventory(self.Containers[2])
    ScrapSlot:SetSlot(1)
    ScrapSlot:SetPreviewItem("scrap")
    
    local ScrapInfoContainer = ScrapContainer:Add("gRust.Panel")
    ScrapInfoContainer:Dock(FILL)
    ScrapInfoContainer:DockPadding(padding, padding, padding, padding)

    local Title = ScrapInfoContainer:Add("gRust.Label")
    Title:Dock(TOP)
    Title:SetTextSize(56)
    Title:SetContentAlignment(7)
    Title:SetTall(56 * gRust.Hud.Scaling)
    Title:SetText("Scrap To Use")
    Title:SetTextColor(gRust.Colors.Text2)

    local ScrapInfo = ScrapInfoContainer:Add("gRust.Label")
    ScrapInfo:Dock(FILL)
    ScrapInfo:SetContentAlignment(7)
    ScrapInfo:SetWrap(true)
    ScrapInfo:SetText("Scrap is required to produce an item blueprint, insert it here.")
    ScrapInfo:SetFont("gRust.Research.Text")
    ScrapInfo:SetTextColor(gRust.Colors.Text2)

    local CostContainer = panel:Add("Panel")
    CostContainer:Dock(BOTTOM)
    CostContainer:SetTall(160 * gRust.Hud.Scaling)
    CostContainer:DockMargin(0, margin, 0, 0)

    local Cost = CostContainer:Add("Panel")
    Cost:Dock(RIGHT)
    Cost:SetWide(256 * gRust.Hud.Scaling)
    Cost:DockMargin(margin, 0, 0, 0)
    Cost.Paint = function(me, w, h)
        gRust.DrawPanel(0, 0, w, h)

        local item = self.Containers[1][1]
        local cost = item and item:GetRegister():GetResearchCost() or "N/A"
        draw.SimpleText(cost, "gRust.120px", w / 2, h / 2, gRust.Colors.Text2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local CostInfoContainer = CostContainer:Add("gRust.Panel")
    CostInfoContainer:Dock(FILL)
    CostInfoContainer:DockPadding(padding, padding, padding, padding)

    local CostTitle = CostInfoContainer:Add("gRust.Label")
    CostTitle:Dock(TOP)
    CostTitle:SetTextSize(56)
    CostTitle:SetContentAlignment(7)
    CostTitle:SetTall(56 * gRust.Hud.Scaling)
    CostTitle:SetText("Research Cost")
    CostTitle:SetTextColor(gRust.Colors.Text2)

    local CostInfo = CostInfoContainer:Add("gRust.Label")
    CostInfo:Dock(FILL)
    CostInfo:SetContentAlignment(7)
    CostInfo:SetWrap(true)
    CostInfo:SetText("How much scrap you require to produce a blueprint of this item")
    CostInfo:SetFont("gRust.Research.Text")
    CostInfo:SetTextColor(gRust.Colors.Text2)

    local ItemContainer = panel:Add("Panel")
    ItemContainer:Dock(BOTTOM)
    ItemContainer:SetTall(256 * gRust.Hud.Scaling)
    ItemContainer:DockMargin(0, margin, 0, 0)

    local ItemSlot = ItemContainer:Add("gRust.Slot")
    ItemSlot:Dock(LEFT)
    ItemSlot:SetWide(256 * gRust.Hud.Scaling)
    ItemSlot:DockMargin(0, 0, margin, 0)
    ItemSlot:SetInventory(self.Containers[1])
    ItemSlot:SetSlot(1)

    local ItemInfoContainer = ItemContainer:Add("gRust.Panel")
    ItemInfoContainer:Dock(FILL)
    ItemInfoContainer:DockPadding(padding, padding, padding, padding)

    local ItemTitle = ItemInfoContainer:Add("gRust.Label")
    ItemTitle:Dock(TOP)
    ItemTitle:SetTextSize(56)
    ItemTitle:SetContentAlignment(7)
    ItemTitle:SetTall(56 * gRust.Hud.Scaling)
    ItemTitle:SetText("Item to research")
    ItemTitle:SetTextColor(gRust.Colors.Text2)

    local ItemInfo = ItemInfoContainer:Add("gRust.Label")
    ItemInfo:Dock(FILL)
    ItemInfo:SetWrap(true)
    ItemInfo:SetFont("gRust.Research.Text")

    local WorkbenchTier = ItemInfo:Add("gRust.WorkbenchTier")
    WorkbenchTier:Dock(BOTTOM)
    WorkbenchTier:SetTall(64 * gRust.Hud.Scaling)

    ItemInfo.Paint = function(me, w, h)
        local item = self.Containers[1][1]
        WorkbenchTier:SetTier(0)
        if (!item) then
            ItemInfo:SetText("This item is too broken to research.\nTry repairing it first.")
            ItemInfo:SetTextColor(gRust.Colors.Text2)
            ItemInfo:SetContentAlignment(7)
        else
            local canResearch, reason = self:CanResearchItem(LocalPlayer())
            
            if (!canResearch) then
                gRust.DrawPanelColored(0, 0, w, h, ERROR_COLOR)
                ItemInfo:SetContentAlignment(5)
                ItemInfo:SetTextColor(Color(255, 142, 96))
                ItemInfo:SetText("")

                draw.SimpleText(reason, me:GetFont(), w / 2, h / 2, me:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                ItemInfo:SetText("")
                WorkbenchTier:SetTier(item:GetRegister():GetTier())
            end
        end
    end

    local InfoContainer = panel:Add("gRust.Panel")
    InfoContainer:Dock(BOTTOM)
    InfoContainer:SetTall(128 * gRust.Hud.Scaling)

    local InfoIcon = InfoContainer:Add("gRust.Icon")
    InfoIcon:Dock(LEFT)
    InfoIcon:SetWide(128 * gRust.Hud.Scaling)
    InfoIcon:SetIcon("info")
    InfoIcon:SetPadding(32 * gRust.Hud.Scaling)
    InfoIcon:SetColor(gRust.Colors.PrimaryPanel)

    local InfoText = InfoContainer:Add("gRust.Label")
    InfoText:Dock(FILL)
    InfoText:SetContentAlignment(5)
    InfoText:SetText("Use the research table to learn how to craft new items using scrap.")
    InfoText:SetFont("gRust.Research.Text")
    InfoText:SetTextColor(gRust.Colors.Text2)
    InfoText:SetWrap(true)
    InfoText:DockMargin(0, padding, padding, padding)
    InfoText.Think = function(me)
        local researchFinish = self:GetResearchFinish()
        if (researchFinish == 0) then
            ItemSlot:SetLocked(false)
            ScrapSlot:SetLocked(false)
        else
            ItemSlot:SetLocked(true)
            ScrapSlot:SetLocked(true)
        end
    end
end