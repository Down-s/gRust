ENT.Base = "rust_base"
DEFINE_BASECLASS(ENT.Base)

ENT.Model = "deployable/wooden_door.mdl"
ENT.LockBodygroup = 2
ENT.RotateTime = 0.5
ENT.RotateAmount = -95
ENT.PickupType = PickupType.Hands
ENT.AutomaticFrameAdvance = true

ENT.Deploy = gRust.CreateDeployable()
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(45, 1.2, 37.5)
            :SetAngle(0, 0, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(2) == 0
            end)
            :AddFemaleTag("lock")
    )

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 1, "RotateTime")
    self:NetworkVar("Bool", 1, "Open")
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)
    buffer:WriteBool(self:GetOpen())
    buffer:WriteBool(self:IsLocked())
    buffer:WriteFloat(self.InitialRotation)
    buffer:WriteFloat(self.RotateAmount)
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)
    self:SetOpen(buffer:ReadBool())
    self:SetLocked(buffer:ReadBool())
    self.InitialRotation = buffer:ReadFloat()
    self.RotateAmount = buffer:ReadFloat()
end