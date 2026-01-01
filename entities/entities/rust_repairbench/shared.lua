ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

ENT.Model = "models/deployable/repair_bench.mdl"
ENT.MaxHP = 200
ENT.PickupType = PickupType.Hammer

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("farming/repair_bench_deploy.wav")
    :SetRotate(90)

function ENT:CreateContainers()
    local container = gRust.CreateInventory(1)
    container:SetEntity(self)
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    self.Containers[1] = inv
end

function ENT:GetRepairCost(item)
    local register = gRust.GetItemRegister(item:GetId())
    if (!register) then return end
    if (!register:GetCondition()) then return end
    local recipe = register:GetRecipe()
    if (!recipe) then return end

    local cost = {}
    for k, v in ipairs(register:GetRecipe()) do
        local ingredientRegister = gRust.GetItemRegister(v.Item)
        if (ingredientRegister:IsInCategory("Components")) then continue end

        local quantity = v.Quantity * (1 - (item:GetCondition() / item:GetMaxCondition()))
        quantity = math.ceil(quantity * 0.35)
        if (quantity <= 0) then continue end

        cost[#cost + 1] = {
            Item = v.Item,
            Quantity = quantity
        }
    end

    return cost
end