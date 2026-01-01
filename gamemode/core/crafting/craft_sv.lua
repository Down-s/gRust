gRust.CreateConfigValue("grustnet/crafting.speed", 1)
local CRAFTING_SPEED = gRust.GetConfigValue("grustnet/crafting.speed")

local PLAYER = FindMetaTable("Player")
function PLAYER:StartCrafting(id, amount)
    if (!self:CanCraft(id, amount)) then return end
    
    local itemData = gRust.GetItemRegister(id)
    if (!itemData) then return end

    local recipe = itemData:GetRecipe()
    for i = 1, #recipe do
        local item = recipe[i]
        self:RemoveItem(item.Item, item.Quantity * amount, ITEM_GENERIC)
    end

    self:AddToCraftQueue(id, amount)
end

util.AddNetworkString("gRust.AddToCraftQueue")
function PLAYER:AddToCraftQueue(id, amount)
    self.CraftStack = self.CraftStack or {}

    local item = gRust.GetItemRegister(id)
    if (!item) then return end

    self.CraftStack[#self.CraftStack + 1] = {
        Item = item:GetId(),
        Amount = amount,
        Total = amount,
    }

    hook.Run("gRust.CraftQueueUpdated", self)

    net.Start("gRust.AddToCraftQueue")
        net.WriteUInt(item:GetIndex(), gRust.ItemIndexBits)
        net.WriteUInt(amount, 8)
    net.Send(self)
end

util.AddNetworkString("gRust.PopCraftingQueue")
function PLAYER:PopCraftingQueue()
    if (!self.CraftStack) then return end

    local item = self.CraftStack[1]
    if (!item) then return end

    local register = gRust.GetItemRegister(item.Item)
    if (!register) then return end

    self:AddItem(gRust.CreateItem(item.Item, register:GetCraftAmount()), ITEM_CRAFT)

    item.Amount = item.Amount - 1
    item.End = CurTime() + (register:GetCraftTime() / CRAFTING_SPEED)
    if (item.Amount <= 0) then
        table.remove(self.CraftStack, 1)
    end

    hook.Run("gRust.CraftQueueUpdated", self)

    net.Start("gRust.PopCraftingQueue")
    net.Send(self)
end

function PLAYER:RemoveFromCraftingQueue(index)
    if (!self.CraftStack) then return end

    local item = self.CraftStack[index]
    if (!item) then return end

    local register = gRust.GetItemRegister(item.Item)
    if (!register) then return end

    local recipe = register:GetRecipe()
    for i = 1, #recipe do
        local recipeItem = recipe[i]
        self:AddItem(gRust.CreateItem(recipeItem.Item, recipeItem.Quantity * item.Amount), ITEM_GENERIC)
    end

    table.remove(self.CraftStack, index)

    net.Start("gRust.RemoveFromCraftingQueue")
        net.WriteUInt(index, 8)
    net.Send(self)
end

function PLAYER:ClearCraftingQueue()
    self.CraftStack = nil
    net.Start("gRust.ClearCraftingQueue")
    net.Send(self)
end

util.AddNetworkString("gRust.Craft")
net.Receive("gRust.Craft", function(len, pl)
    local index = net.ReadUInt(gRust.ItemIndexBits)
    local amount = net.ReadUInt(8)

    if (amount == 0) then return end

    local id = gRust.GetItemRegisterFromIndex(index):GetId()
    pl:StartCrafting(id, amount)
end)

util.AddNetworkString("gRust.RemoveFromCraftingQueue")
net.Receive("gRust.RemoveFromCraftingQueue", function(len, pl)
    local index = net.ReadUInt(8)
    pl:RemoveFromCraftingQueue(index)
end)

util.AddNetworkString("gRust.ClearCraftingQueue")
net.Receive("gRust.ClearCraftingQueue", function(len, pl)
    pl.CraftStack = nil
    net.Start("gRust.ClearCraftingQueue")
    net.Send(pl)
end)

hook.Add("Think", "gRust.UpdateCrafting", function()
    for _, pl in player.Iterator() do
        if (!IsValid(pl)) then continue end
        if (!pl:Alive()) then continue end
        if (!pl.CraftStack) then continue end

        local item = pl.CraftStack[1]
        if (!item) then continue end

        local register = gRust.GetItemRegister(item.Item)
        
        if (!item.End) then
            item.End = CurTime() + (register:GetCraftTime() / CRAFTING_SPEED)
        elseif (CurTime() >= item.End) then
            pl:PopCraftingQueue()
        end
    end
end)

hook.Add("PlayerDeath", "gRust.RemoveCraftingQueue", function(pl)
    pl:ClearCraftingQueue()
end)