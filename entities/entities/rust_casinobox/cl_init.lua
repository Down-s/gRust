include("shared.lua")

function ENT:GetInventoryName()
    return "GAMBLING"
end

function ENT:CreateLootingPanel(panel)
    local scaling = gRust.Hud.Scaling

    local WinningsContainer = panel:Add("Panel")
    WinningsContainer:Dock(BOTTOM)
    WinningsContainer:SetTall(256 * scaling)
    WinningsContainer:DockMargin(0, 8 * scaling, 0, 0)

    local slots = {}

    local Winnings = WinningsContainer:Add("gRust.Slot")
    Winnings:Dock(LEFT)
    Winnings:SetInventory(self.Containers[1])
    Winnings:SetSlot(6)
    Winnings.PerformLayout = function(me, w, h)
        me:SetWide(h)
    end

    slots[#slots + 1] = Winnings

    local InfoContainer = WinningsContainer:Add("gRust.Panel")
    InfoContainer:Dock(FILL)
    InfoContainer:DockMargin(8 * scaling, 0, 0, 0)
    local padding = 24 * scaling
    InfoContainer:DockPadding(padding, padding, padding, padding)

    local WinningsText = InfoContainer:Add("gRust.Label")
    WinningsText:Dock(TOP)
    WinningsText:SetTextSize(52)
    WinningsText:SetTall(48 * scaling)
    WinningsText:SetText("Winnings")
    WinningsText:SetContentAlignment(1)
    WinningsText:SetTextColor(gRust.Colors.Text)

    local WinningsDesc = InfoContainer:Add("gRust.Label")
    WinningsDesc:Dock(FILL)
    WinningsDesc:SetTextSize(26)
    WinningsDesc:SetText("Please ensure you take your winnings before leaving!")
    WinningsDesc:SetContentAlignment(7)
    WinningsDesc:SetWrap(true)
    WinningsDesc:SetTextColor(ColorAlpha(gRust.Colors.Text, 200))

    local BetContainer = panel:Add("gRust.Panel")
    BetContainer:Dock(BOTTOM)
    BetContainer:SetTall(128 * scaling)
    BetContainer:DockMargin(0, 8 * scaling, 0, 0)
    local padding = 2 * scaling
    BetContainer:DockPadding(padding * 12, padding * 4, padding * 12, padding)
    BetContainer.PerformLayout = function(me, w, h)
        local slotHeight = h - (padding * 4) - padding
        local remWidth = w - (slotHeight * 5) - (padding * 12 * 2)
        local margin = math.floor(remWidth / 4)
        for i, v in ipairs(me:GetChildren()) do
            v:DockMargin(0, 0, i == 5 and 0 or margin, 0)
        end
    end

    local wheel = self.CasinoWheel
    if (!IsValid(wheel)) then return end
    
    local winTypes = wheel.WinTypes
    for i = 1, 5 do
        local Bet = BetContainer:Add("gRust.Slot")
        Bet:Dock(LEFT)
        Bet:SetInventory(self.Containers[1])
        Bet:SetSlot(i)
        Bet:SetDrawBackground(false)
        Bet.PerformLayout = function(me, w, h)
            me:SetWide(h)
        end
        local oldPaint = Bet.Paint
        local background = gRust.GetIcon("casino." .. winTypes[i].number)
        local bottomMargin = 16 * scaling
        Bet.Paint = function(me, w, h)
            surface.SetDrawColor(255, 255, 255, 150)
            surface.SetMaterial(background)
            surface.DrawTexturedRect(bottomMargin * 0.5, 0, w - bottomMargin, h - bottomMargin)

            oldPaint(me, w, h)
        end

        slots[#slots + 1] = Bet
    end

    local TimeRemainingContainer = panel:Add("Panel")
    TimeRemainingContainer:Dock(BOTTOM)
    TimeRemainingContainer:SetTall(128 * scaling)
    TimeRemainingContainer:DockMargin(0, 8 * scaling, 0, 0)

    local TimeRemainingTextContainer = TimeRemainingContainer:Add("gRust.Panel")
    TimeRemainingTextContainer:Dock(RIGHT)
    TimeRemainingTextContainer:SetWide(256 * scaling)

    local TimeRemaining = TimeRemainingTextContainer:Add("gRust.Label")
    TimeRemaining:Dock(FILL)
    TimeRemaining:SetTextSize(120)
    TimeRemaining:SetText("30")
    TimeRemaining:SetContentAlignment(5)
    TimeRemaining:SetTextColor(ColorAlpha(gRust.Colors.Text, 225))
    TimeRemaining.Think = function(me)
        local timeRemaining = wheel:GetNextSpin() - CurTime()
        
        if (timeRemaining < 0) then
            me:SetText("...")
        else
            me:SetText(math.abs(math.ceil(timeRemaining)))
        end
    end

    local TimeRemainingInfoContainer = TimeRemainingContainer:Add("gRust.Panel")
    TimeRemainingInfoContainer:Dock(FILL)
    TimeRemainingInfoContainer:DockMargin(0, 0, 8 * scaling, 0)
    local padding = 20 * scaling
    TimeRemainingInfoContainer:DockPadding(26 * scaling, padding, padding, padding)

    local TimeRemainingInfoTitle = TimeRemainingInfoContainer:Add("gRust.Label")
    TimeRemainingInfoTitle:Dock(TOP)
    TimeRemainingInfoTitle:SetTextSize(52)
    TimeRemainingInfoTitle:SetText("Time Remaining")
    TimeRemainingInfoTitle:SetContentAlignment(1)
    TimeRemainingInfoTitle:SetTall(48 * scaling)
    TimeRemainingInfoTitle:SetTextColor(gRust.Colors.Text)

    local TimeRemainingInfoDesc = TimeRemainingInfoContainer:Add("gRust.Label")
    TimeRemainingInfoDesc:Dock(FILL)
    TimeRemainingInfoDesc:SetTextSize(26)
    TimeRemainingInfoDesc:SetText("Time until next spin")
    TimeRemainingInfoDesc:SetContentAlignment(7)
    TimeRemainingInfoDesc:SetWrap(true)
    TimeRemainingInfoDesc:SetTextColor(ColorAlpha(gRust.Colors.Text, 200))

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
    InfoText:SetText("Place scrap into the betting areas. If the wheel lands on your selected number(s) You win!")
    InfoText:SetFont("gRust.Research.Text")
    InfoText:SetTextColor(gRust.Colors.Text2)
    InfoText:SetWrap(true)
    InfoText:DockMargin(0, padding, padding, padding)

    InfoText.Think = function(me)
        for k, v in ipairs(slots) do
            if (self.CasinoWheel:GetNextSpin() <= CurTime()) then
                v:SetLocked(true)
            else
                v:SetLocked(false)
            end
        end
    end
end