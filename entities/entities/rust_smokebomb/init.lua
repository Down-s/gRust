AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
    end

    self.StartTime = CurTime() + self.FuseTime
    self.DestroyTime = CurTime() + self.FuseTime + 120
end

function ENT:Think()
	self:NextThink(CurTime() + 0.1)

	if (CurTime() > self.DestroyTime) then
		self:StopSound("darky_rust.smoke_loop")
		self:Remove()
	end

	if (CurTime() > self.StartTime) then
		self:Explode()
		self.Exploded = true
		self:EmitSound("darky_rust.smoke_loop")
		self.StartTime = CurTime() + 4
	end
end

function ENT:Explode()
	if (self.Exploded) then return end

	self.Delay = math.random(20, 50)

	local smoke = ents.Create("env_smokestack")
	smoke:SetAngles(Angle(0,120,0))
	smoke:SetKeyValue("InitialState", "1")
	smoke:SetKeyValue("BaseSpread", "10")
	smoke:SetKeyValue("SpreadSpeed", "10")
	smoke:SetKeyValue("Speed", "30")
	smoke:SetKeyValue("StartSize", "10")
	smoke:SetKeyValue("EndSize", "120")
	smoke:SetKeyValue("Rate", "4")
	smoke:SetKeyValue("JetLength", "384")
	smoke:SetKeyValue("WindAngle", "0 0 0")
	smoke:SetKeyValue("WindSpeed", "5")
	smoke:SetKeyValue("rendercolor", "255 0 255")
	smoke:SetKeyValue("renderamt", "255")
	smoke:SetKeyValue("SmokeMaterial", "particles/smokey")
	smoke:SetPos(self:GetPos())
	smoke:SetParent(self)
	smoke:Spawn()
	smoke:Fire("TurnOff", "", 100 + self.Delay)
	smoke:Fire("kill", "", 92 + self.Delay)

	timer.Simple(self.Delay, function()
		if (IsValid(self)) then
			self:CallSupplyDrop(self:GetPos() + VectorRand() * 100)
		end
	end)
end

function ENT:CallSupplyDrop(pos)
	local plane = ents.Create("rust_supplyplane")

	pos.z = 4500
	local planeNormal = Vector((math.random() * 2) - 1, (math.random() * 2) - 1, 0):GetNormalized()
	local tr = util.QuickTrace(pos, planeNormal * 32768 * math.sqrt(2), self)

	plane:SetPos(tr.HitPos)
	plane:SetAngles(planeNormal:Angle())
	plane:Spawn()
	plane:SetDropPos(pos)
end