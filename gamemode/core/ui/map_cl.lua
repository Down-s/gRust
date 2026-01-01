local MapOpen = false
local MapOpenTime = 0
local MapCloseTime = 0

function gRust.PosToMap(realpos)
    local mapBounds = 15750
    local size = ScrH()
    local startX = ScrW() * 0.5 - size * 0.5
    local endX = ScrW() * 0.5 + size * 0.5
    local startY = 0
    local endY = size

    local x = math.Remap(realpos.x, -mapBounds, mapBounds, startX, endX)
    local y = math.Remap(realpos.y, mapBounds, -mapBounds, startY, endY)

    return x, y
end

function gRust.MapToPos(x, y)
    local mapBounds = 15750
    local size = ScrH()
    local startX = ScrW() * 0.5 - size * 0.5
    local endX = ScrW() * 0.5 + size * 0.5
    local startY = 0
    local endY = size

    local realX = math.Remap(x, startX, endX, -mapBounds, mapBounds)
    local realY = math.Remap(y, startY, endY, mapBounds, -mapBounds)

    return Vector(realX, realY, 0)
end

local function ReloadVendingMachines()
    gRust.Map.VendingMachines = gRust.Map.VendingMachines or {}
    local currentVendingMachines = gRust.Map.VendingMachines
    for i = 1, #currentVendingMachines do
        currentVendingMachines[i]:Remove()
    end

    local vendingMachines = ents.FindByClass("rust_vendingmachine")
    for i = 1, #vendingMachines do
        local vm = vendingMachines[i]
        if (!vm:GetBroadcasting()) then continue end
        local pos = vm:GetPos()
        
        local scaling = gRust.Hud.Scaling

        local x, y = gRust.PosToMap(pos)

        local panel = gRust.Map:Add("Panel")
        panel:SetSize(20 * scaling, 20 * scaling)
        panel:SetPos(x - 10 * scaling, y - 10 * scaling)
        
        if (#vm.SellOrders > 0) then
            local orders = {}
            for i = 1, #vm.SellOrders do
                local order = vm.SellOrders[i]
                
                local sellItem = gRust.GetItemRegisterFromIndex(order.SellItem)
                local sellAmount = string.Comma(order.SellAmount)
                local buyItem = gRust.GetItemRegisterFromIndex(order.BuyItem)
                local buyAmount = string.Comma(order.BuyAmount)
    
                table.insert(orders, string.format("%s %s | %s %s", sellAmount, sellItem.Name, buyAmount, buyItem.Name))
            end
            panel:SetTooltip(table.concat(orders, "\n"))
        else
            panel:SetTooltip("Empty")
        end
        
        panel.Paint = function()
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(gRust.GetIcon("map.vendingmachine"))
            surface.DrawTexturedRect(0, 0, 20 * scaling, 20 * scaling)
        end

        table.insert(gRust.Map.VendingMachines, panel)

        -- surface.SetDrawColor(255, 255, 255)
        -- surface.SetMaterial(gRust.GetIcon("map.vendingmachine"))
        -- surface.DrawTexturedRectRotated(x, y, 20 * scaling, 20 * scaling, 0)
    end
end

hook.Add("Think", "gRust.MapToggle", function()
    if (input.IsKeyDown(KEY_G) and !MapOpen and !vgui.CursorVisible() and gRust.Hud.ShouldDraw) then
        gui.EnableScreenClicker(true)
        
        MapOpen = true
        MapOpenTime = CurTime()

        ReloadVendingMachines()
    elseif (!input.IsKeyDown(KEY_G) and MapOpen) then
        gui.EnableScreenClicker(false)
        
        MapOpen = false
        MapCloseTime = CurTime()
    end
end)

local function GetAlphaMultiplier()
    if (MapOpen) then
        return Lerp((CurTime() - MapOpenTime) / 0.1, 0, 1)
    else
        return Lerp((CurTime() - MapCloseTime) / 0.1, 1, 0)
    end
end

local TEAM_COLOR = Color(0, 255, 0)
local function DrawPlayers()
    local pl = LocalPlayer()
    local pos = pl:GetPos()

    local scaling = gRust.Hud.Scaling

    local x, y = gRust.PosToMap(pos)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(gRust.GetIcon("map.player"))
    surface.DrawTexturedRectRotated(x, y, 20 * scaling, 20 * scaling, pl:GetAngles().y - 90)

    if (gRust.TeamsIndex) then
        for _, other in player.Iterator() do
            if (other == pl) then continue end
            if (!other:Alive()) then continue end
            if (!gRust.TeamsIndex[other:SteamID64()]) then continue end
    
            local pos = other:GetPos()
            local x, y = gRust.PosToMap(pos)
            
            draw.SimpleTextOutlined("•", "gRust.16px", x, y, TEAM_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
            draw.SimpleTextOutlined(other:Nick(), "gRust.16px", x, y - 16 * scaling, TEAM_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
        end
    end
end

local function DrawDeathPos()
    local pos = gRust.DeathPos
    if (!pos) then return end

    local scaling = gRust.Hud.Scaling
    local size = 48 * scaling

    local x, y = gRust.PosToMap(pos)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(gRust.GetIcon("map.death"))
    surface.DrawTexturedRect(x - size * 0.5, y - size, size, size)
end

local MapMaterial = Material("ui/map.png")
local function CreateMap()
    if (IsValid(gRust.Map)) then
        gRust.Map:Remove()
    end

    gRust.Map = vgui.Create("Panel")
    gRust.Map:SetSize(ScrW(), ScrH())
    gRust.Map:Center()
    gRust.Map.Paint = function(me)
        local alpha = GetAlphaMultiplier() * 255
        me:SetAlpha(GetAlphaMultiplier() * 255)

        if (alpha == 0) then return end

        local size = ScrH()

        surface.SetDrawColor(90, 85, 63)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        surface.SetDrawColor(255, 255, 255, alpha)
        surface.SetMaterial(MapMaterial)
        surface.DrawTexturedRect(ScrW() * 0.5 - size * 0.5, 0, size, size)

        DrawDeathPos()
        DrawPlayers()
    end
end

CreateMap()