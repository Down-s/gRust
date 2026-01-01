-- Net

local gRust     = gRust
local net       = net

local math_min = math.min
local math_max = math.max
local math_pow = math.pow
local math_floor = math.floor
local math_Clamp = math.Clamp
local math_ceil = math.ceil
local math_log = math.log
local math_random = math.random
local string_format = string.format

gRust.ItemIndexBits = 0

if (SERVER) then
    gRust.CreateConfigValue("farming/stack.multiplier", 1, true)
end

function net.WriteItem(item)
    local index = IsValid(item) and item:GetIndex() or 0
    net.WriteUInt(index, gRust.ItemIndexBits)
    if (index == 0 or !IsValid(item)) then return end

    local register = item:GetRegister()

    if (register:GetStack() > 1) then
        net.WriteUInt(item:GetQuantity(), register.StackBits)
    end

    if (item:IsWeapon()) then
        net.WriteUInt(item:GetClip() or 0, 7) -- 7 bits for a max of 127
    end

    if (register:GetCondition()) then
        net.WriteFloat(item:GetDamage() or 0)
        net.WriteFloat(item:GetCondition() or 0)
    end

    local slots = register:GetSlots() or 0
    if (slots > 0) then
        local inventory = item:GetInventory()

        net.WriteUInt(inventory:GetIndex(), 24)
        for i = 1, slots do
            net.WriteItem(inventory[i])
        end
    end
end

function net.ReadItem()
    local index = net.ReadUInt(gRust.ItemIndexBits)
    if (index == 0) then return end

    local Item = gRust.CreateItemFromIndex(index)
    local register = Item:GetRegister()

    if (register:GetStack() > 1) then
        Item:SetQuantity(net.ReadUInt(register.StackBits))
    else
        Item:SetQuantity(1)
    end

    if (Item:IsWeapon()) then
        Item:SetClip(net.ReadUInt(7)) -- 7 bits for a max of 127
    end

    if (Item:GetRegister():GetCondition()) then
        Item:SetDamage(net.ReadFloat())
        Item:SetCondition(net.ReadFloat())
    end

    local slots = register:GetSlots() or 0
    if (slots > 0) then
        local inventoryIndex = net.ReadUInt(24)
        
        if (!gRust.Inventories[inventoryIndex]) then
            gRust.CreateInventory(slots, inventoryIndex)
        end

        for i = 1, slots do
            local item = net.ReadItem()
            gRust.Inventories[inventoryIndex][i] = item
        end

        Item:SetInventory(gRust.Inventories[inventoryIndex])
    end

    return Item
end

-- File

local FILE = FindMetaTable("File")
function FILE:WriteItem(item)
    local index = item and item:GetIndex() or 0
    self:WriteUShort(index)
    if (index == 0 or !IsValid(item)) then return end

    local register = item:GetRegister()

    if (register:GetStack() > 1) then
        self:WriteULong(item:GetQuantity())
    end

    if (item:IsWeapon()) then
        self:WriteByte(item:GetClip() or 0)
    end

    if (register:GetCondition()) then
        self:WriteFloat(item:GetDamage() or 0)
        self:WriteFloat(item:GetCondition() or 0)
    end

    local slots = register:GetSlots() or 0
    if (slots > 0) then
        local inventory = item:GetInventory()
        self:WriteULong(inventory:GetIndex())
        self:WriteByte(inventory:GetSlots())
        for i = 1, slots do
            self:WriteItem(inventory[i])
        end
    end
end

function FILE:ReadItem()
    local index = self:ReadUShort()
    if (index == 0) then return end

    local Item = gRust.CreateItemFromIndex(index)
    local register = Item:GetRegister()

    if (register:GetStack() > 1) then
        Item:SetQuantity(self:ReadULong())
    else
        Item:SetQuantity(1)
    end

    if (Item:IsWeapon()) then
        Item:SetClip(self:ReadByte())
    end

    if (Item:GetRegister():GetCondition()) then
        Item:SetDamage(self:ReadFloat())
        Item:SetCondition(self:ReadFloat())
    end

    local slots = register:GetSlots() or 0
    if (slots > 0) then
        local inventoryIndex = self:ReadULong()
        local inventorySlots = self:ReadByte()
        
        if (!gRust.Inventories[inventoryIndex]) then
            gRust.CreateInventory(slots, inventoryIndex)
        end

        for i = 1, register:GetSlots() do
            local item = self:ReadItem()
            gRust.Inventories[inventoryIndex][i] = item
        end

        Item:SetInventory(gRust.Inventories[inventoryIndex])
    end

    return Item
end

-- Item

local ITEM = {
    Id = "wood",
    Index = 1,
    Quantity = 1,
}
ITEM.__index = ITEM

ITEM.__tostring = function(self)
    return string.format("item: %s [x%i]", self:GetRegister():GetName(), self:GetQuantity())
end

gRust.AccessorFunc(ITEM, "Id", "Id", FORCE_STRING)
gRust.AccessorFunc(ITEM, "Index", "Index", FORCE_NUMBER)
gRust.AccessorFunc(ITEM, "Quantity", "Quantity", FORCE_NUMBER)
gRust.AccessorFunc(ITEM, "Condition", "Condition", FORCE_NUMBER)
gRust.AccessorFunc(ITEM, "Damage", "Damage", FORCE_NUMBER)
gRust.AccessorFunc(ITEM, "Clip", "Clip", FORCE_NUMBER)

gRust.AccessorFunc(ITEM, "Inventory", "Inventory")
gRust.AccessorFunc(ITEM, "ParentInventory", "ParentInventory")
gRust.AccessorFunc(ITEM, "ParentSlot", "ParentSlot")

function ITEM:IsValid()
    return self:GetRegister() ~= nil and self.Quantity > 0
end

function ITEM:IsWeapon()
    return self:GetRegister():GetWeapon() ~= nil and self:GetRegister():GetWeapon() ~= ""
end

function ITEM:IsDeployable()
    return self:GetRegister():GetEntity() ~= nil and self:GetRegister():GetEntity() ~= ""
end

function ITEM:Copy()
    return setmetatable({
        Id = self:GetId(),
        Index = self:GetIndex(),
        Quantity = self:GetQuantity(),
        Condition = self:GetCondition(),
        Clip = self:GetClip(),
        Inventory = self:GetInventory() and self:GetInventory():Copy(),
    }, ITEM)
end

function ITEM:Split(n)
    if (self:GetQuantity() <= n) then return end

    local item = self:Copy()
    item:SetQuantity(n)
    self:SetQuantity(self:GetQuantity() - n)

    if (self:GetInventory()) then
        item:SetInventory(self:GetInventory())
    end

    return item
end

function ITEM:SetQuantity(quantity)
    self.Quantity = math_floor(math_min(math_max(quantity, 0), (self:GetRegister():GetAbsoluteMax() or self:GetRegister():GetStack())))
end

function ITEM:SetCondition(n)
    self.Condition = math_Clamp(n, 0, self:GetMaxCondition())
end

function ITEM:AddDamage(n)
    local damage = self:GetDamage() or 0
    self:SetDamage(math.Clamp(damage + n, 0, 1))
end

function ITEM:GetMaxCondition()
    local damage = self:GetDamage() or 0
    return 1 - damage
end

function ITEM:GetRegister()
    return gRust.GetItemRegister(self:GetId())
end

function gRust.CreateItem(id, quantity)
    local register = gRust.GetItemRegister(id)
    if (!register) then
        error(string_format("Attempted to create an item with an invalid id '%s'", id))
    end

    quantity = quantity and math_min(quantity, (register:GetAbsoluteMax() or register:GetStack())) or 1

    local meta = {}
    meta.Id = id
    meta.Quantity = quantity
    meta.Index = register:GetIndex()
    meta.Condition = register:GetCondition() and 1 or nil
    meta.Damage = register:GetCondition() and 0 or nil

    local slots = register:GetSlots()
    if (slots and slots > 0) then
        meta.Inventory = gRust.CreateInventory(slots)
        meta.Inventory.OnUpdated = function(self)
            if (meta.ParentInventory) then
                meta.ParentInventory:SyncSlot(meta.ParentSlot)
            end
        end
        meta.Inventory.CanPlayerAccess = function(self, pl)
            if (meta.ParentInventory) then
                return meta.ParentInventory:CanPlayerAccess(pl)
            end

            return false, "Invalid Parent Inventory"
        end
        meta.Inventory.CanAcceptItem = function(self, item)
            if (register:IsWeapon()) then
                local swep = weapons.GetStored(register:GetWeapon())
                
                if (item:GetRegister():IsInCategory("Attachments")) then
                    local attachment = swep.Attachments and swep.Attachments[item:GetId()]
                    if (!attachment) then return false end

                    local attachmentType = attachment.Type
                    for i = 1, self:GetSlots() do
                        local slot = self[i]
                        if (!slot) then continue end

                        local slotRegister = slot:GetRegister()
                        if (!slotRegister) then continue end

                        local attachment = swep.Attachments and swep.Attachments[slotRegister:GetId()]
                        if (!attachment) then continue end

                        if (attachment.Type == attachmentType) then
                            return false
                        end
                    end

                    return true
                end
            end

            return false
        end
    end

    quantity = quantity and math_min(quantity, (register:GetAbsoluteMax() or register:GetStack())) or 1
    return setmetatable(meta, ITEM)
end

function gRust.CreateItemFromIndex(index)
    local register = gRust.GetItemRegisterFromIndex(index)
    if (!register) then
        gRust.LogError(string_format("Attempted to create an item with an invalid index '%i'", index))
        return
    end

    local id = register:GetId()
    return gRust.CreateItem(id)
end

-- Registry

local ItemRegistry = {}
local ItemRegistryIndex = {}
local ItemCategories = {}
local ItemCategoryIndex = {}
local CurrentIndex = 0

function gRust.GetItems()
    return ItemRegistryIndex
end

function gRust.GetItemRegister(id)
    return ItemRegistry[id]
end

function gRust.GetItemRegisterFromIndex(index)
    return ItemRegistry[ItemRegistryIndex[index]]
end

local ITEM_R = {
    Name = "Wood",
    Id = "wood",
    Index = 0,
    Stack = 1000,
    Format = "x%s",
    Category = "Resources",
    Condition = false,
    Type = "wood",
    CraftAmount = 1,
    CraftTime = 5,
}
ITEM_R.__index = ITEM_R

gRust.AccessorFunc(ITEM_R, "Name", "Name", FORCE_STRING)
gRust.AccessorFunc(ITEM_R, "Description", "Description", FORCE_STRING)
gRust.AccessorFunc(ITEM_R, "Id", "Id", FORCE_STRING)
gRust.AccessorFunc(ITEM_R, "Index", "Index", FORCE_NUMBER) -- This is the index of the item in the registry
gRust.AccessorFunc(ITEM_R, "Stack", "Stack", FORCE_NUMBER) -- The max amount of items that can be stacked
gRust.AccessorFunc(ITEM_R, "AbsoluteMax", "AbsoluteMax", FORCE_NUMBER) -- The absolute max amount of the item that can be in a stack
gRust.AccessorFunc(ITEM_R, "Format", "Format", FORCE_STRING) -- The format of the item's quantity
gRust.AccessorFunc(ITEM_R, "Condition", "Condition", FORCE_BOOL) -- If the item can be damaged
gRust.AccessorFunc(ITEM_R, "Slots", "Slots", FORCE_NUMBER) -- The amount of slots the item can hold

gRust.AccessorFunc(ITEM_R, "Icon", "Icon", FORCE_STRING) -- The icon to use for the item
gRust.AccessorFunc(ITEM_R, "Weapon", "Weapon", FORCE_STRING) -- The weapon class to spawn
gRust.AccessorFunc(ITEM_R, "Entity", "Entity", FORCE_STRING) -- The entity class to spawn
gRust.AccessorFunc(ITEM_R, "Material", "Material", FORCE_STRING) -- This will determine the pickup/drop sound
gRust.AccessorFunc(ITEM_R, "Model", "Model", FORCE_STRING) -- The world model to use

gRust.AccessorFunc(ITEM_R, "Craftable", "Craftable", FORCE_BOOL) -- If the item can be crafted
gRust.AccessorFunc(ITEM_R, "CraftAmount", "CraftAmount", FORCE_NUMBER) -- The amount of items that will be crafted
gRust.AccessorFunc(ITEM_R, "CraftTime", "CraftTime", FORCE_NUMBER) -- The amount of time it takes to craft the item
gRust.AccessorFunc(ITEM_R, "RecycleScrap", "RecycleScrap", FORCE_NUMBER) -- The amount of scrap the item will give when recycled
gRust.AccessorFunc(ITEM_R, "ResearchCost", "ResearchCost", FORCE_BOOL) -- The amount of scrap required to research the item
gRust.AccessorFunc(ITEM_R, "Tier", "Tier", FORCE_NUMBER) -- The workbench tier required to craft the item

gRust.AccessorFunc(ITEM_R, "ProjectileType", "ProjectileType", FORCE_STRING) -- The type of projectile to use

gRust.AccessorFunc(ITEM_R, "Bleeding", "Bleeding", FORCE_NUMBER) -- The amount of bleeding the item will give when consumed
gRust.AccessorFunc(ITEM_R, "InstantHealth", "InstantHealth", FORCE_NUMBER) -- The amount of health the item will give when consumed
gRust.AccessorFunc(ITEM_R, "Healing", "Healing", FORCE_NUMBER) -- The amount of health the item will give over time when consumed
gRust.AccessorFunc(ITEM_R, "Calories", "Calories", FORCE_NUMBER) -- Will make the item edible and contribute to the player's calories
gRust.AccessorFunc(ITEM_R, "Hydration", "Hydration", FORCE_NUMBER) -- Will make the item drinkable and contribute to the player's hydration
gRust.AccessorFunc(ITEM_R, "Radiation", "Radiation", FORCE_NUMBER) -- The amount of radiation the item will give when consumed
gRust.AccessorFunc(ITEM_R, "Poison", "Poison", FORCE_NUMBER) -- The amount of poison the item will give when consumed
gRust.AccessorFunc(ITEM_R, "OnConsumed", "OnConsumed") -- A function that will be called when the item is consumed

gRust.AccessorFunc(ITEM_R, "Attire", "Attire")

function ITEM_R:GetClipSize()
    if (!self.ClipSize) then
        local weapon = weapons.GetStored(self:GetWeapon())
        if (weapon) then
            self.ClipSize = weapon.ClipSize
        end
    end

    return self.ClipSize
end

function ITEM_R:IsWeapon()
    return self:GetWeapon() ~= nil and self:GetWeapon() ~= ""
end

function ITEM_R:IsDeployable()
    return self:GetEntity() ~= nil and self:GetEntity() ~= ""
end

function ITEM_R:IsInCategory(category)
    return self.Categories and self.Categories[category] or false
end

function ITEM_R:IsBlueprint()
    return  --string.EndsWith(self.Id, "_blueprint") and
            self:IsInCategory("Blueprints")
end

function ITEM_R:HasCondition()
    return self:GetCondition()
end

function ITEM_R:AddToCategory(category)
    if (!ItemCategories[ItemCategoryIndex[category]]) then
        gRust.LogWarning(string_format("Attempted to add item '%s' to invalid category '%s'", self:GetId(), category))
        return
    end

    local items = ItemCategories[ItemCategoryIndex[category]].Items
    items[#items + 1] = self:GetId()

    self.Categories = self.Categories or {}
    self.Categories[category] = true

    return self
end

function ITEM_R:AddAction(name, icon, callback)
    self.Actions = self.Actions or {}
    self.Actions[#self.Actions + 1] = {
        Name = name,
        Icon = icon,
        Callback = callback,
    }

    return self
end

if (SERVER) then
    util.AddNetworkString("gRust.ItemAction")
    net.Receive("gRust.ItemAction", function(len, pl)
        if (!pl:Alive()) then return end
        local inventoryIndex = net.ReadUInt(24)
        local itemIndex = net.ReadUInt(7)
        local actionIndex = net.ReadUInt(5)

        local inventory = gRust.Inventories[inventoryIndex]
        if (!inventory) then return end

        local item = inventory[itemIndex]
        if (!item) then return end

        local register = item:GetRegister()
        if (!register.Actions) then return end
        local action = register.Actions[actionIndex]
        if (!action) then return end

        action.Callback(pl, inventory, itemIndex)
    end)
end

function ITEM_R:SetRecipe(...)
    self.Recipe = self.Recipe or {}

    local craft = {...}
    for i = 1, #craft, 2 do
        local item = craft[i]
        local quantity = craft[i + 1]

        self.Recipe[#self.Recipe + 1] = {
            Item = item,
            Quantity = quantity,
        }
    end

    return self
end

function ITEM_R:GetRecipe()
    return self.Recipe
end

function ITEM_R:Register()
    gRust.RegisterItem(self)
end

function ITEM_R:SetStack(n)
    self.Stack = n
    self.StackBits = math_ceil(math_log((self.AbsoluteMax or n) + 1, 2))
    return self
end

function ITEM_R:SetAbsoluteMax(n)
    self.AbsoluteMax = n
    self.StackBits = math_ceil(math_log(n + 1, 2))
    return self
end

function ITEM_R:SetIcon(icon)
    self.Icon = Material(icon, "smooth")
    self.IconPath = icon
    return self
end

function ITEM_R:GetPickupSound()
    if (!self:GetMaterial()) then return end
    return string_format("ui/items/pickup_%s_%i.wav", string.lower(self:GetMaterial()), math_random(1, 4))
end

function ITEM_R:GetDropSound()
    if (!self:GetMaterial()) then return end
    return string_format("ui/items/drop_%s_%i.wav", string.lower(self:GetMaterial()), math_random(1, 4))
end

function gRust.ItemRegister(id)
    CurrentIndex = CurrentIndex + 1
    return setmetatable({
        Id = id,
        Index = CurrentIndex,
    }, ITEM_R)
end

function gRust.RegisterItem(item)
    if (ItemRegistry[item.Id]) then
        gRust.LogWarning(string_format("Attempted to register item '%s' twice", item.Id))
        return
    end

    local name
    local icon
    local snd
    if (item.Calories) then
        name = "Eat"
        icon = "eat"
        snd = string.format("player/eat_%i.wav", math_random(1, 4))
    elseif (item.Hydration) then
        name = "Drink"
        icon = "water"
        snd = string.format("player/drink_%i.wav", math_random(1, 4))
    elseif (item.Healing) then
        name = "Use Medkit"
        icon = "medical"
        snd = ""
    end

    if (name) then
        item:AddAction(name, icon, function(pl, inventory, slot)
            if ((pl.NextConsume or 0) > CurTime()) then return end
            pl.NextConsume = CurTime() + 1

            local consumable = inventory[slot]
            if (!consumable) then return end
            
            if (item:GetCalories()) then
                pl:AddCalories(item:GetCalories())
            end

            if (item:GetHydration()) then
                pl:AddHydration(item:GetHydration())
            end

            if (item:GetRadiation()) then
                pl:AddRadiation(item:GetRadiation())
            end

            if (item:GetPoison()) then
                pl:AddPoison(item:GetPoison())
            end

            if (item:GetHealing()) then
                pl:AddHealing(item:GetHealing())
            end

            if (item:GetInstantHealth()) then
                pl:AddHealth(item:GetInstantHealth())
            end

            if (item:GetBleeding()) then
                pl:AddBleeding(item:GetBleeding())
            end

            inventory:Remove(slot, 1)

            if (item:GetOnConsumed()) then
                if (!item:GetOnConsumed()(pl, inventory, slot) and snd) then
                    pl:EmitSound(snd)
                end
            elseif (snd) then
                pl:EmitSound(snd)
            end
        end)
    end

    ItemRegistry[item.Id] = setmetatable(item, ITEM_R)
    ItemRegistryIndex[item.Index] = item.Id

    if (math_pow(2, CurrentIndex + 1) > gRust.ItemIndexBits) then
        gRust.ItemIndexBits = math_ceil(math_log(CurrentIndex + 1, 2))
    end

    --[[if (math_pow(2, item.Stack) > gRust.ItemQuantityBits) then
        gRust.ItemQuantityBits = math_ceil(math_log(item.Stack, 2))
    end]]

    if (item.ResearchCost) then
        gRust.ItemRegister(item.Id .. "_blueprint")
            :SetName(item.Name .. " Blueprint")
            :SetDescription("A blueprint for " .. item.Name)
            :SetStack(1)
            :SetIcon(item.IconPath)
            :SetMaterial("Paper")
            :AddToCategory("Blueprints")
            :AddAction("Learn Blueprint", "learn", function(pl, inventory, slot)
                local item = inventory[slot]
                if (!item) then return end
                local register = item:GetRegister()
                if (!register) then return end
                if (!register:IsInCategory("Blueprints")) then return end
                
                local itemName = string.Split(item.Id, "_blueprint")[1]
                if (pl:HasBlueprint(itemName)) then return end

                pl:LearnBlueprint(itemName)
                inventory:Remove(slot)
            end)
            :Register()
    end
    
    if (item.Model) then
        util.PrecacheModel(item.Model)
    end

    if (item.Attire) then
        util.PrecacheModel(item.Attire:GetModel())
    end
end

function gRust.CreateCategory(name, icon, visible)
    if (visible == nil) then
        visible = true
    end

    ItemCategories[#ItemCategories + 1] = {
        Name = name,
        Icon = icon,
        Items = {},
        Visible = visible,
    }

    ItemCategoryIndex[name] = #ItemCategories
end

function gRust.GetCategory(name)
    return ItemCategories[ItemCategoryIndex[name]]
end

function gRust.GetCategories()
    return ItemCategories
end

gRust.CreateCategory("Favourite", "favorite.inactive")
gRust.CreateCategory("Common", "servers")
gRust.CreateCategory("Construction", "construction")
gRust.CreateCategory("Items", "extinguish")
gRust.CreateCategory("Resources", "servers")
gRust.CreateCategory("Clothing", "servers")
gRust.CreateCategory("Tools", "tools")
gRust.CreateCategory("Medical", "medical")
gRust.CreateCategory("Weapons", "weapon")
gRust.CreateCategory("Ammo", "ammo")
gRust.CreateCategory("Traps", "banana")
gRust.CreateCategory("Electrical", "electric")
gRust.CreateCategory("Fun", "fun")
gRust.CreateCategory("Components", "servers", false)
gRust.CreateCategory("Blueprints", "servers", false)
gRust.CreateCategory("Attachments", "servers", false)
gRust.CreateCategory("Other", "dots")

hook.Add("gRust.ConfigInitialized", "gRust.UpdateItemStacks", function()
    local multiplier = gRust.GetConfigValue("farming/stack.multiplier", 1)
    for k, v in pairs(ItemRegistry) do
        if (v:GetStack() == 1) then continue end
        
        v:SetStack(v:GetStack() * multiplier)

        if (v:GetAbsoluteMax()) then
            v:SetAbsoluteMax(v:GetAbsoluteMax() * multiplier)
        end
    end
end)