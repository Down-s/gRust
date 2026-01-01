include("shared.lua")

surface.CreateFont("gRust.Furnace.Text", {
    font = "Roboto Condensed",
    size = 28 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true
})

matproxy.Add({
    name = "RUST_FURNACE_PROXY",
    init = function(self, mat, values)
        self.resultVar = values.resultvar
    end,
    bind = function(self, mat, ent)
        if (IsValid(ent)) then
            if (ent.GetBurning and ent:GetBurning()) then
                mat:SetInt("$flags", 64)
            else
                mat:SetInt("$flags", 0)
            end
        end
    end
})

function ENT:OnStartLooting(pl)
    pl:EmitSound(string.format("farming/furnace_open_%i.wav", math.random(1, 2)))
end

function ENT:OnStopLooting(pl)
    pl:EmitSound(string.format("farming/furnace_close_%i.wav", math.random(1, 2)))
end

function ENT:GetInventoryName()
    return "FURNACE"
end

local TOGGLE_ON_TEXT = [[This furnace is on. It will burn fuel until it runs out or is switched off. Put ore inside to extract whatever they're holding.]]
local TOGGLE_OFF_TEXT = [[The furnace is off. To switch it on make sure it has fuel (wood) and press the button on the left.]]
function ENT:CreateLootingPanel(panel)
    local burning = self:GetBurning()

    local ControlPanel = panel:Add("gRust.ControlPanel")
    ControlPanel:Dock(BOTTOM)
    ControlPanel:DockMargin(0, 20 * gRust.Hud.Scaling, 0, 0)
    ControlPanel:SetTall(184 * gRust.Hud.Scaling)

    local ToggleButton = ControlPanel:Add("gRust.ToggleButton")
    ToggleButton:Dock(LEFT)
    ToggleButton:SetWide(256 * gRust.Hud.Scaling)
    ToggleButton:SetToggled(burning)

    local Info = ControlPanel:Add("gRust.Label")
    Info:Dock(FILL)
    Info:SetWrap(true)
    Info:SetFont("gRust.Furnace.Text")
    Info:SetTextColor(gRust.Colors.Text)
    Info:DockMargin(20 * gRust.Hud.Scaling, 0, 0, 0)
    Info:SetText(burning and TOGGLE_ON_TEXT or TOGGLE_OFF_TEXT)
    Info:SetContentAlignment(5)
    ToggleButton.OnToggle = function(me, toggled)
        net.Start("gRust.FurnaceToggle")
        net.WriteEntity(self)
        net.SendToServer()
    end
    ToggleButton.Think = function(me)
        local toggled = self:GetBurning()
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