ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

ENT.Model = "models/deployable/research_table.mdl"
ENT.MaxHP = 200
ENT.PickupType = PickupType.Hammer

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("farming/repair_bench_deploy.wav")
    :SetRotate(90)

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 1, "ResearchFinish")
end

function ENT:CreateContainers()
    local function IsResearching(self)
        return self:GetResearchFinish() ~= 0
    end

    local itemContainer = gRust.CreateInventory(1)
    itemContainer:SetEntity(self)
    itemContainer.CanAcceptItem = function(me, item, container)
        if (IsResearching(self)) then return false end
        return true
    end
    itemContainer.CanRemoveItem = function(me, item, container)
        if (IsResearching(self)) then return false end
        return true
    end
    itemContainer.CustomCheck = function(inv, item, container)
        if (IsResearching(self)) then return false end
        return true
    end

    local scrapContainer = gRust.CreateInventory(1)
    scrapContainer:SetEntity(self)
    scrapContainer.CanAcceptItem = function(me, item, container)
        if (item:GetId() != "scrap") then return false end
        if (IsResearching(self)) then return false end
        return true
    end
    scrapContainer.CanRemoveItem = function(me, item, container)
        if (IsResearching(self)) then return false end
        return true
    end
    scrapContainer.CustomCheck = function(inv, item, container)
        if (IsResearching(self)) then return false end
        return true
    end
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    if (self.Containers[1]) then
        self.Containers[2] = inv
    else
        self.Containers[1] = inv
    end
end

function ENT:CanResearchItem(pl)
    if (!IsValid(pl)) then return false end
    local item = self.Containers[1][1]
    if (!item) then return false, "Invalid item" end
    local register = item:GetRegister()
    if (!register) then return false, "Item does not exist" end

    local cost = register:GetResearchCost()
    if (!cost) then return false, "Item cannot be researched" end

    if (item:GetQuantity() > 1) then return false, "One at a time please" end
    if (pl:HasBlueprint(item:GetId())) then return false, "Blueprint already learned" end

    local scrap = self.Containers[2][1]
    return scrap and scrap:GetQuantity() >= cost, "Not enough scrap"
end