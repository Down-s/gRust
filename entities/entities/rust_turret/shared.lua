ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

ENT.PickupType = PickupType.Hammer
ENT.BaseModel = "models/deployable/turret_base.mdl"
ENT.PitchModel = "models/deployable/turret_pitch.mdl"
ENT.YawModel = "models/deployable/turret_yaw.mdl"

ENT.PitchPos = Vector(0, 0, 5)
ENT.YawPos = Vector(0, 0, 30)
ENT.GunPos = Vector(0, 0, -5)
ENT.Range = 384

ENT.ShouldSave = true

ENT.MaxHP = 1000

ENT.BulletDamageScale = 0.05
ENT.MeleeDamageScale = 0.05
ENT.ExplosiveDamageScale = 0.35

-- TODO: Proper deploy sound
ENT.Deploy = gRust.CreateDeployable()
    :SetModel("models/deployable/turret_guide.mdl")
    :SetInitialRotation(180)
    :SetSound("deploy/tool_cupboard_deploy.wav")
    :SetRotate(90)
    :SetOnDeployed(function(self, pl, ent, item)
        self.Authorized[pl:SteamID()] = true
    end)
    
ENT.Decay = 2 * 60*60 -- 2 hours
ENT.Upkeep = {
    {
        Item = "hq_metal",
        Amount = 10
    }
}

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    
    if (inv:GetSize() == 1) then
        self.Containers[1] = inv
    else
        inv:SetName("AMMO STORAGE")
        self.Containers[2] = inv
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "HP")
    self:NetworkVar("Bool", 0, "Interactable")
    self:NetworkVar("String", 0, "InteractText")
    self:NetworkVar("String", 1, "InteractIcon")
    self:NetworkVar("Int", 0, "WeaponID")
    self:NetworkVar("Entity", 1, "Target")
    self:NetworkVar("Bool", 1, "Peacekeeper")
end

local IDLE_INTERVAL = 4
function ENT:GetTargetRotation()
    local target = self:GetTarget()
    if (IsValid(target)) then
        return (target:GetPos() - self:GetPos()):Angle() - self:GetAngles()
    else
        self.TargetIdleYaw = math.max(math.min(2 * math.sin(0.2 * (CurTime() + self.IdleOffset) * math.pi), 1), -1) * 45

        return Angle(0, self.TargetIdleYaw, 0)
    end

end

function ENT:GetRotateSpeed()
    if (IsValid(self:GetTarget())) then
        return 10
    else
        return 1
    end
end

function ENT:UpdateRotation()
    local rotation = self:GetTargetRotation()

    self.Rotation = self.Rotation or rotation
    self.Rotation = LerpAngle(FrameTime() * self:GetRotateSpeed(), self.Rotation, rotation)
end

function ENT:GetMuzzlePos()
    return self:LocalToWorld(self.YawPos + self.PitchPos + self.GunPos + Vector(0, 0, 5))
end