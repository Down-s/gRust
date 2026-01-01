AddCSLuaFile()

SWEP.Base = "rust_shotgun"
DEFINE_BASECLASS("rust_shotgun")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_grenadelauncher.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_grenadelauncher.mdl"

SWEP.ShootSound = "darky_rust.grenade-launcher-attack"
SWEP.ShootSoundSilenced = "darky_rust.grenade-launcher-attack"

SWEP.IronSightsPos = Vector(-5.1, -3.89, 6.4)
SWEP.IronSightsAng = Vector(-4, 0, 8.5)
SWEP.IronSightsFOV = 60

SWEP.HoldType       = "shotgun"

SWEP.Damage = 140
SWEP.RPM = 150
SWEP.ShellInsertTime = 0.4
SWEP.ClipSize = 6
SWEP.AimCone = 0.2
SWEP.Bullets = 16
SWEP.BulletVelocity = 10000

SWEP.RecoilAmount = 500
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-0.1, -0.08, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "40mm_he_grenade",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	},
	{
		Item = "40mm_shotgun_round",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	}
}

SWEP.Animations = {
	["Fire"] = ACT_VM_PRIMARYATTACK,
	["FireADS"] = ACT_VM_PRIMARYATTACK_1,
	["Draw"] = ACT_VM_DRAW,
	["Idle"] = ACT_VM_IDLE,
	["Reload"] = ACT_VM_RELOAD,
	["ReloadEmpty"] = ACT_VM_RELOAD,
}

function SWEP:FireBullet(aimCone)
	local ammoType = self.AmmoTypes[self:GetAmmoType()]
	if (ammoType.Item == "40mm_shotgun_round") then
		self:EmitSound("darky_rust.spas12-attack")
		BaseClass.FireBullet(self, aimCone)
	else
		if (CLIENT) then return end

		local pl = self:GetOwner()
        local ent = ents.Create("rust_bomb")
        if (!IsValid(ent)) then return end
    
        ent:SetModel("models/weapons/darky_m/rust/gl_ammo.mdl")
        ent:SetPos(pl:EyePos() + pl:GetAimVector() * 16)
        ent:SetAngles(pl:EyeAngles())
        ent:SetOwner(pl)
        ent:SetExplodeSound("darky_rust.beancan-grenade-explosion")
		ent:SetImpact(true)
        ent:SetBeepDelay(0.8)
        ent:SetRadius(128)
        ent:SetDamage(self.Damage)
        ent:SetOwner(pl)
        ent.RaidEfficiency = self.RaidEfficiency
        ent:Spawn()
    
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(pl:GetAimVector() * 1500)
        end
	end
end