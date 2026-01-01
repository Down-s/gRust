include("shared.lua")

DEFINE_BASECLASS("rust_container")

surface.CreateFont("gRust.ToolCupboard.Text", {
    font = "Roboto Condensed",
    size = 26 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function ENT:CreateExtraOptions()
    local PieMenu = BaseClass.CreateExtraOptions and BaseClass.CreateExtraOptions(self) or gRust.CreatePieMenu()

    PieMenu:CreateOption()
        :SetTitle("Deauthorize")
        :SetDescription("Remove yourself from this cupboards list. You won't be able to build within its radius.")
        :SetIcon("deauthorize")
        :SetCondition(true, function()
            return LocalPlayer():HasBuildPrivilege()
        end)
        :SetCallback(function()
            net.Start("gRust.ToolCupboard.Deauthorize")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Clear Authorized List")
        :SetDescription("Clear the authorized list, no-one will be able to build within this cupboards radius.")
        :SetIcon("clear")
        :SetCondition(true, function()
            return LocalPlayer():HasBuildPrivilege()
        end)
        :SetCallback(function()
            net.Start("gRust.ToolCupboard.ClearAuthorized")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
     :SetTitle("Open")
        :SetDescription("Open the tool cupboard.")
        :SetIcon("open")
        :SetCondition(true, function()
            return LocalPlayer():HasBuildPrivilege()
        end)
        :SetCallback(function()
            gRust.StartLooting(self)
        end)

    PieMenu:CreateOption()
        :SetTitle("Authorize")
        :SetDescription("Authorize yourself on this cupboard. You will be able to build within its radius.")
        :SetIcon("add")
        :SetCondition(true, function()
            return !LocalPlayer():HasBuildPrivilege()
        end)
        :SetCallback(function()
            LocalPlayer():RequestInteract(self)
        end)

    return PieMenu
end

function ENT:Initialize()
    self.ExtraOptions = self:CreateExtraOptions()
end

function ENT:Interact()
    if (LocalPlayer():HasBuildPrivilege()) then
        gRust.StartLooting(self)
    end
end

function ENT:OnStartLooting(pl)
    gRust.PlaySound("toolcupboard.open")
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("toolcupboard.close")
end

function ENT:GetInventoryName()
    return "Loot"
end

function ENT:CreateLootingPanel(panel)
    local container = self.Containers[1]
    local inventory = panel:Add("gRust.Inventory")
    inventory:SetInventory(container)
    inventory:SetName(container:GetName())
    inventory:Dock(BOTTOM)
    inventory:RemoveNameContainer()

    local CostPanel = panel:Add("gRust.Panel")
    CostPanel:Dock(BOTTOM)
    CostPanel:SetTall(214 * gRust.Hud.Scaling)
    CostPanel:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)

    local InToolStorage = false
    local ReloadCostPanel
    ReloadCostPanel = function()
        for k, v in pairs(CostPanel:GetChildren()) do
            v:Remove()
        end

        if (InToolStorage) then
            local StorageText = CostPanel:Add("gRust.Label")
            StorageText:Dock(TOP)
            StorageText:SetFont("gRust.28px")
            StorageText:SetColor(gRust.Colors.Text)
            StorageText:SetText("Tool Storage")
            StorageText:SetContentAlignment(5)
            StorageText:SetTall(56 * gRust.Hud.Scaling)

            local Storage = CostPanel:Add("gRust.Grid")
            Storage:Dock(FILL)
            Storage:SetCols(4)
            Storage:SetRows(1)
            Storage:SetCentered(true)
            Storage:SetCellSpacing(gRust.Hud.SlotPadding)
            Storage:DockMargin(0, 0, 0, 50 * gRust.Hud.Scaling)

            for i = 1, 4 do
                local Slot = Storage:Add("gRust.Slot")
                Slot:SetInventory(self.Containers[2])
                Slot:SetSlot(i)
            end
        else
            local CostText = CostPanel:Add("gRust.Label")
            CostText:Dock(TOP)
            CostText:SetFont("gRust.32px")
            CostText:SetColor(Color(224, 137, 65))
            CostText:SetText("Cost per 24 hours")
            CostText:SetContentAlignment(5)
            CostText:SetTall(56 * gRust.Hud.Scaling)

            local Materials = CostPanel:Add("gRust.Grid")
            Materials:Dock(FILL)
            Materials:SetCols(4)
            Materials:SetRows(1)
            Materials:SetCentered(true)
            Materials:SetCellSpacing(4 * gRust.Hud.Scaling)

            for k, v in ipairs(self.Materials) do
                local Material = Materials:Add("Panel")
                Material:SetTall(64 * gRust.Hud.Scaling)
                local padding = 8 * gRust.Hud.Scaling
                local register = gRust.GetItemRegister(v.Item)
                local icon = register:GetIcon()
                Material.Paint = function(me, w, h)
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(icon)
                    surface.DrawTexturedRect(padding, padding, w - padding * 2, h - padding * 2)

                    draw.SimpleText(string.format("x%s", string.Comma(self[v.Getter](self))), "gRust.28px", w, h, gRust.Colors.Text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                end
            end

            local ProtectedText = CostPanel:Add("gRust.Label")
            ProtectedText:Dock(BOTTOM)
            ProtectedText:SetFont("gRust.32px")
            ProtectedText:SetContentAlignment(5)
            ProtectedText:SetTall(56 * gRust.Hud.Scaling)
            ProtectedText.Think = function(me)
                local protectedFor = self:GetUpkeepEnd() - CurTime()

                if (protectedFor > 0) then
                    me:SetColor(Color(171, 194, 111))
                    me:SetText("Protected for " .. string.format("%02d", math.floor(protectedFor / 86400)) .. "d " .. string.format("%02d", math.floor(protectedFor / 3600) % 24) .. "h " .. string.format("%02d", math.floor(protectedFor / 60) % 60) .. "m")
                else
                    me:SetColor(Color(209, 122, 50))
                    me:SetText("Your base is not protected and is decaying.")
                end
            end
        end

        local SwapButtonWide = 54 * gRust.Hud.Scaling
        local SwapButtonTall = 114 * gRust.Hud.Scaling

        local SwapButton = CostPanel:Add("gRust.Button")
        SwapButton:SetWide(SwapButtonWide)
        SwapButton:SetTall(SwapButtonTall)
        SwapButton.DoClick = function(me)
            InToolStorage = !InToolStorage
            ReloadCostPanel()
        end
        
        CostPanel.PerformLayout = function(me, w, h)
            if (InToolStorage) then
                SwapButton:SetPos(0, h - SwapButtonTall  * 1.5)
                SwapButton:SetText("←")
            else
                SwapButton:SetPos(w - SwapButtonWide, h - SwapButtonTall  * 1.5)
                SwapButton:SetText("➔")
            end
        end
    end

    ReloadCostPanel()

    local InfoPanel = panel:Add("gRust.Panel")
    InfoPanel:Dock(BOTTOM)
    InfoPanel:SetTall(106 * gRust.Hud.Scaling)
    InfoPanel:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)

    local InfoIcon = InfoPanel:Add("gRust.Icon")
    InfoIcon:Dock(LEFT)
    InfoIcon:SetWide(106 * gRust.Hud.Scaling)
    InfoIcon:SetIcon("info")
    InfoIcon:SetPadding(20 * gRust.Hud.Scaling)
    InfoIcon:SetColor(gRust.Colors.PrimaryPanel)

    local InfoText = InfoPanel:Add("gRust.Label")
    InfoText:Dock(FILL)
    InfoText:SetFont("gRust.ToolCupboard.Text")
    InfoText:DockMargin(8 * gRust.Hud.Scaling, 0, 0, 0)
    InfoText:SetColor(gRust.Colors.Text)
    InfoText:SetText([[Maintain the required amount of resources to prevent your base from decaying over time. Bases left unattended without enough upkeep resources will be destroyed.]])
    InfoText:SetWrap(true)
    InfoText:SetContentAlignment(4)

    local TitlePanel = panel:Add("Panel")
    TitlePanel:Dock(BOTTOM)
    TitlePanel:SetTall(36 * gRust.Hud.Scaling)
    TitlePanel.Paint = function(me, w, h)
        gRust.DrawPanel(0, 0, w, h)
        draw.SimpleText("UPKEEP MANAGEMENT", "gRust.30px", 14 * gRust.Hud.Scaling, h / 2, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end