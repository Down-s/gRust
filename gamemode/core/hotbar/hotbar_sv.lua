util.AddNetworkString("gRust.SelectWeapon")
net.Receive("gRust.SelectWeapon", function(len, pl)
    if (pl:IsInSafeZone()) then return end
    if (!pl:Alive()) then return end
    pl:SelectWeapon("rust_hands")

    local beltIndex = net.ReadUInt(3)
    local item = pl.Belt[beltIndex]
    if (!IsValid(item)) then return end
    local register = item:GetRegister()
    local weapon = register:GetWeapon()
    if (!weapon or weapon == "") then return end
    
    if (!register:GetCondition() or item:GetCondition() > 0) then
        pl:SelectWeapon(weapon)
        pl.ActiveWeaponItem = item
        
        local wep = pl:GetActiveWeapon()
        if (wep:GetClass() != weapon) then return end

        if (IsValid(wep) and wep.SetItem) then
            wep:SetItem(item, beltIndex)
        end
    end

    pl.SelectedSlot = beltIndex
end)