ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 1, "Recycling")
end

function ENT:CreateContainers()
    local inputInventory = gRust.CreateInventory(6)
    inputInventory:SetEntity(self)

    local outputInventory = gRust.CreateInventory(6)
    outputInventory:SetEntity(self)
    outputInventory.CanAcceptItem = function(me, item, container)
        return false
    end
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    if (self.Containers[1]) then
        inv:SetName("Output")
        self.Containers[2] = inv
    else
        inv:SetName("Input")
        self.Containers[1] = inv
    end
end