AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:SetInteractable(true)
    self:SetInteractText("USE")
    self:SetInteractIcon("gear")
end

function ENT:UnlockItem(id)
    local techTree = self.TechTree
end

util.AddNetworkString("gRust.TechTree.Unlockitem")
net.Receive("gRust.TechTree.UnlockItem", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    local techTree = ent.TechTree
    if (!techTree) then return end

    local index = net.ReadUInt(gRust.ItemIndexBits)
    local item = gRust.GetItemRegisterFromIndex(index)
    if (!item) then return end
    local itemId = item:GetId()

    local stack = util.Stack()
    stack:Push(techTree[1])
    local hasPath = false
    local cost = 0
    while (stack:Size() != 0) do
        local node = stack:Pop()
        local id = node.props["id"]
        if (id) then
            if (id == itemId) then
                cost = tonumber(node.props["cost"] or 0)
                hasPath = true
                break
            end

            if (!pl:HasBlueprint(id)) then continue end
        end

        for _, child in ipairs(node.children) do
            stack:Push(child)
        end
    end

    if (!hasPath) then return end
    if (!pl:HasItem("scrap", cost)) then return end

    pl:RemoveItem("scrap", cost, ITEM_CRAFT)
    pl:LearnBlueprint(itemId)
end)