ENT.Base = "rust_container"
DEFINE_BASECLASS("rust_container")
ENT.Model = "models/deployable/furnace.mdl"
ENT.MaxHP = 500
ENT.PickupType = PickupType.Hammer
ENT.ShouldSave = true
ENT.Decay = 8 * 60 * 60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 10
    },
    {
        Item = "stones",
        Amount = 20
    }
}

ENT.Furnace = {
    Fuel = {
        ["wood"] = true,
    },
    Cookables = {
        --  Input                       Output                  Time        Chance
        ["metal_ore"] = {"metal_fragments", 3.33},
        ["sulfur_ore"] = {"sulfur", 1.67},
        ["hq_metal_ore"] = {"hq_metal", 6.67},
        ["empty_can_of_beans"] = {"metal_fragments", 10},
        ["empty_tuna_can"] = {"metal_fragments", 10},
        ["wood"] = {"charcoal", 2, 0.75}
    },
}

ENT.Deploy = gRust.CreateDeployable():SetModel(ENT.Model):SetInitialRotation(180):SetSound("farming/furnace_deploy.wav"):SetRotate(90)
function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 1, "Burning")
end

function ENT:CreateContainers()
    local inventory = gRust.CreateInventory(6)
    inventory:SetEntity(self)
    local outputInventory = gRust.CreateInventory(6)
    outputInventory:SetEntity(self)
    outputInventory.CanAcceptItem = function(me, item, container) return false end
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    if self.Containers[1] then
        inv:SetName("Output")
        self.Containers[2] = inv
    else
        inv:SetName("Input")
        self.Containers[1] = inv
    end
end