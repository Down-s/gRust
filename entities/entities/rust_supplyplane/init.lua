AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

AccessorFunc(ENT, "DropPos", "DropPos", FORCE_VECTOR)

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

	self.DestroyTime = CurTime() + 360
	self.Dropped = false
end

function ENT:Think()
	local pos = self:GetPos()

	if (CurTime() > self.DestroyTime) then
		self:Remove()
	end

	if (!self.Dropped and pos:DistToSqr(self:GetDropPos()) < 256) then
		self.Dropped = true
		local drop = ents.Create("rust_supplydrop")
		drop:SetPos(pos - Vector(0, 0, 196))
		drop:SetAngles(Angle(0, self:GetAngles().y, 0))
		drop:Spawn()
		drop:Activate()
	end

	self:SetPos(pos - self:GetAngles():Forward() * 1024 * FrameTime())
	self:NextThink(CurTime())

	pos = self:GetPos()
	if (pos.x < -16384 or pos.x > 16384 or pos.y < -16384 or pos.y > 16384 or pos.z < -16384 or pos.z > 16384) then
		self:Remove()
	end

	return true
end