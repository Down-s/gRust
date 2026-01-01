local PANEL = {}

AccessorFunc(PANEL, "Item", "Item")

function PANEL:Init()
    local Title = self:Add("gRust.Panel")
    Title:Dock(TOP)
    Title:SetTall(40 * gRust.Hud.Scaling)
    Title:SetPrimary(true)

    local InformationText = Title:Add("gRust.Label")
    InformationText:Dock(FILL)
    InformationText:SetFont("gRust.28px")
    InformationText:DockMargin(8 * gRust.Hud.Scaling, 0, 0, 0)
    InformationText:SetText("INFORMATION")
    InformationText:SetTextColor(gRust.Colors.Text)

    local Container = self:Add("gRust.Panel")
    Container:Dock(FILL)
    Container:DockMargin(0, 2 * gRust.Hud.Scaling, 0, 0)
    local Padding = 8 * gRust.Hud.Scaling
    Container:DockPadding(0, Padding, 0, Padding)

    self.Container = Container
end

function PANEL:Paint(w, h)

end

local WeaponFields = {
    {
        key = "Damage",
        name = "Damage",
        max = 100,
    },
    {
        key = "AttackRate",
        name = "Attack Rate",
        max = 100,
    },
    {
        key = "AttackSize",
        name = "Attack Size",
        max = 1,
    },
    {
        key = "Range",
        name = "Range",
        max = 3,
    },
    {
        key = "Accuracy",
        name = "Accuracy",
        max = 8,
    },
    {
        key = "Recoil",
        name = "Recoil",
        max = 10,
    },
    {
        key = "FireRate",
        name = "Fire Rate",
        max = 600,
    },
    {
        key = "OreGather",
        name = "Ore Gather",
        max = 10,
    },
    {
        key = "TreeGather",
        name = "Tree Gather",
        max = 20,
    },
    {
        key = "FleshGather",
        name = "Flesh Gather",
        max = 20,
    }
}

function PANEL:Rebuild()
    if (!self.Item) then return end

    local register = isstring(self.Item) and gRust.GetItemRegister(self:GetItem()) or self.Item:GetRegister()
    if (!register) then return end

    if (register:GetWeapon()) then
        local swep = weapons.GetStored(register:GetWeapon())
        if (!swep) then return end

        for k, v in pairs(WeaponFields) do
            local value = swep[v.key]
            if (value and value != 0) then
                self:AddRow(v.name, value, v.max)
            end
        end
    else

    end

    if (!isstring(self.Item)) then
        local slots = register:GetSlots() or 0
        if (slots > 0 and self.Item) then
            local inventory = self.Container:Add("gRust.Inventory")
            inventory:Dock(BOTTOM)
            inventory:SetTall(72 * gRust.Hud.Scaling)
            inventory:DockMargin(8 * gRust.Hud.Scaling, 0, 8 * gRust.Hud.Scaling, 0)
            inventory:SetCols(slots)
            inventory:SetInventory(self.Item:GetInventory())
            inventory:RemoveNameContainer()
        end
    end
end

local TextColor = Color(247, 238, 231)
local BarColor = ColorAlpha(gRust.Colors.Text, 100)
function PANEL:AddRow(name, value, max)
    local Row = self.Container:Add("Panel")
    Row:Dock(TOP)
    Row:SetTall(28 * gRust.Hud.Scaling)

    local Left = Row:Add("gRust.Label")
    Left:Dock(LEFT)
    Left:SetWide(140 * gRust.Hud.Scaling)
    Left:SetFont("gRust.24px")
    Left:SetText(name)
    Left:SetContentAlignment(6)
    Left:SetTextColor(TextColor)

    local Right = Row:Add("Panel")
    Right:Dock(FILL)
    Right:DockMargin(16 * gRust.Hud.Scaling, 0, 0, 0)
    local BarMargin = 4 * gRust.Hud.Scaling
    Right.Paint = function(me, w, h)
        local frac = math.min(value / max, 1.0)
        surface.SetFont("gRust.24px")
        local tw, th = surface.GetTextSize(value .. "  ")
        gRust.DrawPanelColored(0, BarMargin, (w - BarMargin - tw) * frac, h - BarMargin * 2, BarColor)

        draw.SimpleText(value, "gRust.24px", BarMargin + (w - BarMargin - tw) * frac, h / 2, BarColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("gRust.ItemInfo", PANEL, "Panel")