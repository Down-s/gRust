include("shared.lua")

surface.CreateFont("gRust.Recycle.Text", {
    font = "Roboto Condensed",
    size = 28 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

function ENT:OnStartLooting(pl)
    gRust.PlaySound("recycler.open")
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("recycler.close")
end

function ENT:GetInventoryName()
    return "RECYCLER"
end

local TOGGLE_ON_TEXT = [[The recycler is on. It will continue to recycle items until they run out or it is switched off.]]
local TOGGLE_OFF_TEXT = [[The recycler is off. Input items to recycle and switch it on.]]
function ENT:CreateLootingPanel(panel)
    local recycling = self:GetRecycling()

    local ControlPanel = panel:Add("gRust.ControlPanel")
    ControlPanel:Dock(BOTTOM)
    ControlPanel:DockMargin(0, 20 * gRust.Hud.Scaling, 0, 0)
    ControlPanel:SetTall(184 * gRust.Hud.Scaling)

    local ToggleButton = ControlPanel:Add("gRust.ToggleButton")
    ToggleButton:Dock(LEFT)
    ToggleButton:SetWide(256 * gRust.Hud.Scaling)
    ToggleButton:SetToggled(recycling)

    local Info = ControlPanel:Add("gRust.Label")
    Info:Dock(FILL)
    Info:SetWrap(true)
    Info:SetFont("gRust.Recycle.Text")
    Info:SetTextColor(gRust.Colors.Text)
    Info:DockMargin(20 * gRust.Hud.Scaling, 0, 0, 0)
    Info:SetText(recycling and TOGGLE_ON_TEXT or TOGGLE_OFF_TEXT)
    Info:SetContentAlignment(5)
    ToggleButton.OnToggle = function(me, toggled)
        net.Start("gRust.RecyclerToggle")
        net.WriteEntity(self)
        net.SendToServer()
    end
    ToggleButton.Think = function(me)
        local toggled = self:GetRecycling()
        if (toggled) then
            Info:SetText(TOGGLE_ON_TEXT)
            ToggleButton:SetToggled(true)
        else
            Info:SetText(TOGGLE_OFF_TEXT)
            ToggleButton:SetToggled(false)
        end
    end

    local containers = self.Containers
    for i = #containers, 1, -1 do
        local v = containers[i]
        local inventory = panel:Add("gRust.Inventory")
        inventory:SetInventory(v)
        inventory:SetName(v:GetName())
        inventory:Dock(BOTTOM)
        inventory:DockMargin(0, i == 1 and 0 or (20 * gRust.Hud.Scaling), 0, 0)
    end
end