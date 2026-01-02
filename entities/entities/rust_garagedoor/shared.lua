ENT.Base = "rust_base"
DEFINE_BASECLASS(ENT.Base)

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/darky_m/rust/building/garage_door.mdl"
ENT.LockBodygroup = 1
ENT.OpenTime = 2.7
ENT.OpenAmount = 138
ENT.PickupType = PickupType.Hammer
ENT.AutomaticFrameAdvance = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRequireSocket(true)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 5, 0)
            :SetAngle(0, 0, 0)
            :SetCustomCheck(function(ent, pos, ang, tr)
                return IsValid(tr.Entity) and #tr.Entity:GetChildren() == 0
            end)
            :AddMaleTag("doubledoor"),
        gRust.CreateSocket()
            :SetPosition(45, 1.2, 37.5)
            :SetAngle(0, 0, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(1) == 0
            end)
            :AddFemaleTag("lock")
    )
    :SetOnDeployed(function(self, pl, ent)
        self:SetParent(ent)
    end)

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 1, "OpenTime")
    self:NetworkVar("Bool", 1, "Open")
end

ENT.Mins = Vector(-58, 2, 0)
ENT.Maxs = Vector(58,  5,  132)

function ENT:SetupCollision()
    self.PhysCollide = CreatePhysCollideBox(self.Mins, self.Maxs)
    self:EnableCustomCollisions()
end

function ENT:TestCollision(startpos, delta, isbox, extents, mask)
    if (!IsValid(self.PhysCollide)) then return end

    local max = extents
    local min = -extents
    max.z = max.z - min.z
    min.z = 0

    local hit, norm, frac = self.PhysCollide:TraceBox(self:GetPos(), self:GetAngles(), startpos, startpos + delta, min, max)
    if (!hit) then return end

    return {
        HitPos = hit,
        Normal = norm,
        Fraction = frac,
    }
end

function ENT:Think()
    BaseClass.Think(self)
    self:UpdateCollisionBounds()
    
    self:NextThink(CurTime())
    return true
end

function ENT:UpdateCollisionBounds()
    if ((self.NextCollisionUpdate or 0) > CurTime()) then return end
    if (SERVER) then
        self.NextCollisionUpdate = CurTime() + 0.25
    else
        self.NextCollisionUpdate = CurTime() + 0.1
    end

    local openTime = self:GetOpenTime()
    if (openTime == 0.0) then return end
    local progress = (CurTime() - openTime) / self.OpenTime
    if (progress < 0.0) then return end

    if (progress > 1.0) then
        if (SERVER and !self.IsShut) then
            self:Shut()
        end

        return
    end

    local mins = self.Mins
    local maxs = self.Maxs
    local amount = maxs.z

    if (self:GetOpen()) then
        local newMins = Vector(mins.x, mins.y, mins.z + amount * progress)
        self:SetCollisionBounds(newMins, maxs)
    else
        local newMins = Vector(mins.x, mins.y, mins.z + amount * (1.0 - progress))
        self:SetCollisionBounds(newMins, maxs)
    end
end

function ENT:Draw()
    self:DrawModel()

    -- local mins, maxs = self:GetCollisionBounds()
    -- debugoverlay.Box(self:GetPos(), mins, maxs, 0.1, Color(255, 0, 0, 255))
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)
    buffer:WriteBool(self:GetOpen())
    buffer:WriteBool(self:IsLocked())
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)
    self:SetOpen(buffer:ReadBool())
    self:SetLocked(buffer:ReadBool())
end