local PLAYER = FindMetaTable("Player")
function PLAYER:SetAmmoType(index)
    local wep = self:GetActiveWeapon()
    if (!IsValid(wep)) then return end
    if (!wep.AmmoTypes) then return end
    if (#wep.AmmoTypes < index) then return end
    if (!wep.Item) then return end
    if (wep.Item.AmmoType == index) then return end

    self:GetActiveWeapon():ChangeAmmoType(index)
end

function PLAYER:UnloadBullets(inventory, index)
    local item = inventory[index]
    if (!item) then return end
    if (!item.AmmoType) then return end
    local register = item:GetRegister()
    local weapon = register:GetWeapon()
    if (!weapon) then return end

    local wepClass = weapons.Get(register:GetWeapon())
    local ammoType = wepClass.AmmoTypes[item.AmmoType]
    local ammo = item:GetClip()
    if (!ammo or ammo <= 0) then return end
    
    local item = gRust.CreateItem(ammoType.Item, ammo)

    self:AddItem(item, ITEM_PICKUP)
    inventory[index]:SetClip(0)
    inventory:SyncSlot(index)
end

util.AddNetworkString("gRust.SetAmmoType")
net.Receive("gRust.SetAmmoType", function(len, pl)
    local index = net.ReadUInt(8)
    pl:SetAmmoType(index)
end)