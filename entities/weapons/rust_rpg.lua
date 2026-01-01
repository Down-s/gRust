AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_rocketlauncher.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_rocketlauncher.mdl"

SWEP.IronSightsPos = Vector(-3.6, 0, 2.3)
SWEP.IronSightsAng = Vector(1.1, 3.85, -25.629)
SWEP.IronSightsFOV = 50

SWEP.Damage = 0
SWEP.RPM = 10
SWEP.AimCone = 0.2
SWEP.ClipSize = 1
SWEP.Range = 512
SWEP.ReloadTime = 6.0

SWEP.ShootSound = "darky_rust.rpg_fire"
SWEP.ShootSoundSilenced = "darky_rust.rpg_fire"

SWEP.RecoilAmount = 2.5
SWEP.RecoilLerpTime = 0.1
SWEP.RecoilTable = {
	Angle(-15, 0.8, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "rocket",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	},
	{
		Item = "high_velocity_rocket",
		Projectile = ProjectileType.HighVelocity,
		Icon = "riflebullet",
	},
}

SWEP.Animations = {
	["Fire"] = ACT_VM_PRIMARYATTACK,
	["FireADS"] = ACT_VM_PRIMARYATTACK_1,
	["Draw"] = ACT_VM_DRAW,
	["Idle"] = ACT_VM_IDLE,
	["Reload"] = ACT_VM_RELOAD,
	["ReloadEmpty"] = ACT_VM_RELOAD,
}

function SWEP:Deploy()
	self:SetHoldType("rpg")
end

function SWEP:ShootEffects()
end

function SWEP:FireBullet()
	local pl = self:GetOwner()

	if (SERVER) then
		local ammoType = self.AmmoTypes[self:GetAmmoType()]

		local rocket = ents.Create("rust_rocket")
		rocket:SetPos(pl:GetShootPos())
		rocket:SetAngles(pl:GetAimVector():Angle() + Angle(90, 0, 90))
		rocket:Activate()
		rocket:SetOwner(pl)
		rocket:SetDamage(ammoType.Item == "high_velocity_rocket" and 100 or 300)
		rocket:Spawn()

		local phys = rocket:GetPhysicsObject()
		if (IsValid(phys)) then
			local velocity = ammoType.Item == "high_velocity_rocket" and 2000 or 1500
			phys:SetVelocity(pl:EyeAngles():Forward() * velocity)
		end

		pl:SetAnimation(PLAYER_ATTACK1)
	end
end