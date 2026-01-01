include("shared.lua")

surface.CreateFont("gRust.Repair.Text", {
    font = "Roboto Condensed",
    size = 32 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function ENT:OnStartLooting(pl)
    gRust.PlaySound("repairbench.open")
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("repairbench.close")
end

function ENT:GetInventoryName()
    return "REPAIR BENCH"
end

function ENT:CreateLootingPanel(panel)
    local BottomPanel = panel:Add("gRust.Panel")
    BottomPanel:Dock(BOTTOM)
    BottomPanel:SetTall(42 * gRust.Hud.Scaling)
    BottomPanel:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)

    local RepairContainer = panel:Add("Panel")
    RepairContainer:Dock(BOTTOM)
    RepairContainer:SetTall(246 * gRust.Hud.Scaling)
    RepairContainer:DockMargin(0, 6 * gRust.Hud.Scaling, 0, 0)
    local padding = 6 * gRust.Hud.Scaling
    RepairContainer:DockPadding(padding, padding, padding, padding)

    do
        local Slot = RepairContainer:Add("gRust.Slot")
        Slot:Dock(LEFT)
        Slot:SetInventory(self.Containers[1])
        Slot:SetSlot(1)
        RepairContainer.PerformLayout = function(me, w, h)
            Slot:SetWide(h)
        end

        local InfoContainer = RepairContainer:Add("gRust.Panel")
        InfoContainer:Dock(FILL)
        InfoContainer:DockMargin(16 * gRust.Hud.Scaling, 0, 0, 0)
        local padding = 16 * gRust.Hud.Scaling
        InfoContainer:DockPadding(padding, padding, padding, 8 * gRust.Hud.Scaling)
        InfoContainer.AddText = function(me, text, color, dock)
            local Label = InfoContainer:Add("DLabel")
            Label:Dock(dock or FILL)
            Label:SetFont("gRust.Repair.Text")
            Label:SetText(text)
            Label:SetContentAlignment(5)
            Label:SetTextColor(color)
            Label:SizeToContents()
        end
        InfoContainer.Reload = function(me)
            local item = self.Containers[1][1]
            for k, v in pairs(me:GetChildren()) do
                if (v:IsValid()) then
                    v:Remove()
                end
            end
            
            if (item) then
                local cost = self:GetRepairCost(item)
                if (cost) then
                    if (#cost == 0) then
                        InfoContainer:AddText("Repairs are not needed", gRust.Colors.Primary)
                        return
                    end

                    if (!LocalPlayer():HasBlueprint(item:GetId())) then
                        InfoContainer:AddText("You don't have this item's blueprint", gRust.Colors.Primary)
                        return
                    end

                    if (item:GetDamage() >= 0.8) then
                        InfoContainer:AddText("Item is too damaged", gRust.Colors.Primary)
                        return
                    end

                    for k, v in ipairs(cost) do
                        local ingredientRegister = gRust.GetItemRegister(v.Item)
                        local col = LocalPlayer():HasItem(v.Item, v.Quantity) and gRust.Colors.Text or gRust.Colors.Primary
                        InfoContainer:AddText(string.format("%i %s", v.Quantity, ingredientRegister.Name), col, TOP)
                    end

                    local Button = InfoContainer:Add("gRust.Button")
                    Button:Dock(BOTTOM)
                    Button:SetText("Repair")
                    Button:SetFont("gRust.36px")
                    Button:SetTall(64 * gRust.Hud.Scaling)
                    Button:SetDefaultColor(Color(83, 105, 40))
                    Button:SetHoveredColor(Color(81, 100, 35))
                    Button:SetSelectedColor(Color(61, 85, 18))
                    Button:SetTextColor(color_white)
                    Button.DoClick = function(me)
                        net.Start("gRust.RepairItem")
                            net.WriteEntity(self)
                        net.SendToServer()
                    end
                else
                    InfoContainer:AddText("Item is not repairable.", gRust.Colors.Primary)
                end
            else
                InfoContainer:AddText("Drag an item here to repair it", gRust.Colors.Primary)
            end 
        end
        InfoContainer.Think = function(me)
            local item = self.Containers[1][1]
            if (me.LastItem != item) then
                me:Reload()
                me.LastItem = item
            end
        end

        InfoContainer:Reload()
    end
    
    local TopPanel = panel:Add("gRust.Panel")
    TopPanel:Dock(BOTTOM)
    TopPanel:SetTall(42 * gRust.Hud.Scaling)
end