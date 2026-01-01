local function CreateHotbar()
    local pl = LocalPlayer()
    local scale = gRust.Hud.Scaling
    local margin = gRust.Hud.Margin
    local Padding = math.floor(gRust.Hud.SlotPadding)

    gRust.Hud.HotbarXOffset = -19 * scale
    gRust.Hud.HotbarYOffset = -4 * scale

    local XOffset = gRust.Hud.HotbarXOffset
    local YOffset = gRust.Hud.HotbarYOffset

    if (gRust.Hotbar) then
        gRust.Hotbar:Remove()
    end

    local Hotbar = vgui.Create("Panel")
    Hotbar:SetSize(gRust.Hud.SlotSize * 6 + Padding * 5, gRust.Hud.SlotSize)
    Hotbar:SetPos(ScrW() / 2 - Hotbar:GetWide() / 2 + XOffset, ScrH() - Hotbar:GetTall() - margin + YOffset)
    Hotbar:SetZPos(1000)

    local Slots = {}

    for i = 1, 6 do
        local Slot = Hotbar:Add("gRust.Slot")
        Slot:Dock(LEFT)
        Slot:SetWide(gRust.Hud.SlotSize)
        Slot:SetInventory(pl.Belt)
        Slot:SetSlot(i)
        if (i != 6) then
            Slot:DockMargin(0, 0, Padding, 0)
        end

        local oldPaint = Slot.Paint
        Slot.Paint = function(self, w, h)
            if (!gRust.Hud.ShouldDraw) then return end

            oldPaint(self, w, h)
        end

        Slots[i] = Slot
    end

    gRust.Hotbar = Hotbar
    gRust.Hotbar.SelectedSlot = 0
    gRust.Hotbar.LastSelectedSlot = 0
    gRust.Hotbar.Slots = Slots
end

-- Selection

local function UpdateSelection()
    local pl = LocalPlayer()
    if (#pl:GetWeapons() == 0) then return end
    local item = pl.Belt[gRust.Hotbar.SelectedSlot]

    gRust.StopDeploy()

    if (item and item:IsWeapon()) then
        local wep = LocalPlayer():GetWeapon(item:GetRegister():GetWeapon())
        if (IsValid(wep)) then
            if (gRust.Hotbar.SelectedSlot != gRust.Hotbar.LastSelectedSlot or (pl.ActiveWeaponItem and pl.ActiveWeaponItem:GetId() or "") != item:GetId()) then
                wep:Holster()
                wep:Deploy()
                pl.ActiveWeaponItem = item
    
                net.Start("gRust.SelectWeapon")
                net.WriteUInt(gRust.Hotbar.SelectedSlot, 3)
                net.SendToServer()
            end
        else
            input.SelectWeapon(LocalPlayer():GetWeapons()[1])
        end
    elseif (item and item:IsDeployable() and (item:GetCondition() or 1) > 0) then
        gRust.StartDeploy(item:GetId())
        input.SelectWeapon(LocalPlayer():GetWeapons()[1])
    else
        input.SelectWeapon(LocalPlayer():GetWeapons()[1])
    end

    if (IsValid(gRust.Hotbar)) then
        gRust.Hotbar.LastSelectedSlot = gRust.Hotbar.SelectedSlot
    end
end

local function SelectSlot(i, action)
    if (i == gRust.Hotbar.SelectedSlot) then
        i = 0
    end

    local pl = LocalPlayer()
    local item = pl.Belt[i]
    if (action and item) then
        local register = item:GetRegister()
        if (register.Actions and register.Actions[1] and register:GetCalories()) then
            net.Start("gRust.ItemAction")
                net.WriteUInt(pl.Belt:GetIndex(), 24)
                net.WriteUInt(i, 7)
                net.WriteUInt(1, 5)
            net.SendToServer()
            
            return
        end
    end

    if (IsValid(gRust.Hotbar)) then
        local oldSlot = gRust.Hotbar.SelectedSlot
        gRust.Hotbar.LastSelectedSlot = oldSlot
        gRust.Hotbar.SelectedSlot = i
    
        if (gRust.Hotbar.Slots[oldSlot]) then
            gRust.Hotbar.Slots[oldSlot]:SetSelected(false)
        end
    
        if (item and gRust.Hotbar.Slots[i]) then
            gRust.Hotbar.Slots[i]:SetSelected(true)
        end
    end
    
    UpdateSelection()
end

local SlotBinds = {
    ["slot1"] = 1,
    ["slot2"] = 2,
    ["slot3"] = 3,
    ["slot4"] = 4,
    ["slot5"] = 5,
    ["slot6"] = 6,
}

hook.Add("PlayerBindPress", "gRust.Hotbar", function(pl, bind, pressed)
    if (SlotBinds[bind]) then
        if (pressed) then
            SelectSlot(SlotBinds[bind], true)
        end
    end
end)

local function CanSelectItem(item)
    local pl = LocalPlayer()
    if (pl:IsInSafeZone()) then
        return !item:IsWeapon() and !item:IsDeployable()
    end

    return true
end

local function SelectSlotInDirection(direction)
    if (!IsValid(gRust.Hotbar)) then return end
    
    local num = LocalPlayer().Belt[gRust.Hotbar.SelectedSlot] and (gRust.Hotbar.SelectedSlot + direction) or 0
    for i = 1, 7 do
        num = (num + 7) % 7
        local item = LocalPlayer().Belt[num]
        if (item and CanSelectItem(item)) then
            SelectSlot(num)
            return
        end
        
        num = num + direction
    end
end

gRust.AddBind("invnext", function(pl)
    SelectSlotInDirection(1)
end)

gRust.AddBind("invprev", function(pl)
    SelectSlotInDirection(-1)
end)

hook.Add("OnPlayerBeltAttached", "Rust.Hotbar", CreateHotbar)
hook.Add("OnScreenSizeChanged", "Rust.Hotbar", function()
    timer.Simple(0, function()
        CreateHotbar()
    end)
end)

hook.Add("OnInventoryClosed", "Rust.Hotbar", function()
    if (IsValid(gRust.ActiveInventorySlot)) then
        gRust.ActiveInventorySlot:SetSelected(false)
    end

    if (gRust.Hotbar.SelectedSlot && gRust.Hotbar.Slots[gRust.Hotbar.SelectedSlot] && IsValid(LocalPlayer().Belt[gRust.Hotbar.SelectedSlot])) then
        gRust.Hotbar.Slots[gRust.Hotbar.SelectedSlot]:SetSelected(true)
    end
end)

hook.Add("OnPlayerBeltUpdated", "gRust.Hotbar", function()
    UpdateSelection()
end)