ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

ENT.Model = "models/deployable/tool_cupboard.mdl"
ENT.LockBodygroup = 1
ENT.MaxHP = 100
ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("deploy/tool_cupboard_deploy.wav")
    :SetRotate(90)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(15, -6, 48.5)
            :SetAngle(0, 90, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(1) == 0
            end)
            :AddFemaleTag("lock")
    )

ENT.Materials = {
    {
        Getter = "GetWoodUpkeep",
        Item = "wood",
    },
    {
        Getter = "GetStoneUpkeep",
        Item = "stones",
    },
    {
        Getter = "GetMetalUpkeep",
        Item = "metal_fragments",
    },
    {
        Getter = "GetHQUpkeep",
        Item = "hq_metal",
    }
}
    
ENT.Decay = 2 * 60*60 -- 2 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 100
    }
}

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "HP")
    self:NetworkVar("Int", 0, "WoodUpkeep")
    self:NetworkVar("Int", 1, "StoneUpkeep")
    self:NetworkVar("Int", 2, "MetalUpkeep")
    self:NetworkVar("Int", 3, "HQUpkeep")
    self:NetworkVar("Int", 4, "UpkeepEnd")
end

function ENT:SetInteractable(b)
end

function ENT:SetInteractText()
end

function ENT:SetInteractIcon()
end

function ENT:GetInteractable()
    return true
end

function ENT:GetInteractText()
    return LocalPlayer():HasBuildPrivilege() and "OPEN" or "AUTHORIZE"
end

function ENT:GetInteractIcon()
    return LocalPlayer():HasBuildPrivilege() and "open" or "add"
end

function ENT:CreateContainers()
    local container = gRust.CreateInventory(24)
    container:SetEntity(self)
    container.CanAcceptItem = function(me, item)
        return item:GetRegister():IsInCategory("Resources")
    end

    local tools = gRust.CreateInventory(4)
    tools:SetEntity(self)
    tools.CanAcceptItem = function(me, item)
        return item:GetRegister():IsInCategory("Tools")
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

function ENT:GetProtectedFor()
    local scarcestAmount = math.huge
    local scarcestUpkeep = nil

    for k, v in ipairs(self.Materials) do
        local amount = self.Containers[1]:ItemCount(v.Item)
        local upkeep = self[v.Getter](self)
        if (amount < scarcestAmount and upkeep > 0) then
            scarcestAmount = amount
            scarcestUpkeep = upkeep
        end
    end

    if (!scarcestUpkeep) then
        return 0
    end
    
    local protectedFor = (scarcestAmount / scarcestUpkeep) * 86400
    return protectedFor
end