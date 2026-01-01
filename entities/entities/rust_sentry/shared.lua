ENT.Base = "rust_turret"

DEFINE_BASECLASS("rust_turret")

ENT.BaseModel = "models/deployable/sentry_base.mdl"
ENT.PitchModel = "models/deployable/sentry_pitch.mdl"
ENT.YawModel = "models/deployable/sentry_yaw.mdl"

ENT.PitchPos = Vector(-8, 0, 20)
ENT.YawPos = Vector(17.5, 0, 43)
ENT.GunPos = Vector(0, 0, -5)
ENT.Range = 2048

ENT.ShouldSave = false

function ENT:GetRotateSpeed()
    if (IsValid(self:GetTarget())) then
        return 20
    else
        return 1
    end
end