AddCSLuaFile()

ENT.Base = "rust_base"
DEFINE_BASECLASS(ENT.Base)

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/sleeping_bag.mdl"
ENT.MaxHP = 200
ENT.BagSpawnTime = 5 * 60
ENT.NoCollide = true
ENT.SleepingBag = true
ENT.NoCollide = true

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetInitialRotation(180)
    :SetModel(ENT.Model)
    :SetRotate(90)
    :SetOnDeployed(function(self, pl, ent)
        pl:AddSleepingBag(self)
    end)

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("String", 2, "BagName")
    self:NetworkVar("Float", 1, "RespawnTime")
end

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:SetBagName("Unnamed Bag")

    self:SetInteractable(true)
    self:SetInteractText("RENAME SLEEPING BAG")
    self:SetInteractIcon("enter")

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetRespawnTime(CurTime())
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)

    buffer:WriteString(self:GetBagName())
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)

    self:SetBagName(buffer:ReadString())
end

function ENT:Interact(pl)
    if (CLIENT) then
        gRust.OpenSleepingBagRename(self)
    end
end
