AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"

SWEP.IronSightsPos = Vector(-6.115, -6.896, 3.703)
SWEP.IronSightsAng = Vector(-0.3, 0.012, 0)
SWEP.IronSightsFOV = 52.5

SWEP.Damage = 50
SWEP.RPM = 450
SWEP.AimCone = 0.2
SWEP.ClipSize = 30
SWEP.Range = 4096
SWEP.BulletVelocity = 10000

SWEP.RecoilAmount = 5.5
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-2.5531914893617, 3, 0),
	Angle(-3.4042553191489, -1.25, 0),
	Angle(-2.9787234042553, -1, 0),
	Angle(-2.3404255319149, -1.75, 0),
	Angle(-2.7659574468085, -1.25, 0),
	Angle(-2.5531914893617, -1.5, 0),
	Angle(-2.1276595744681, -2.75, 0),
	Angle(-2.7659574468085, -1.25, 0),
	Angle(-2.3404255319149, 2.25, 0),
	Angle(-1.2765957446809, 3.5, 0),
	Angle(-1.063829787234, 3.25, 0),
	Angle(-0.85106382978723, 3.25, 0),
	Angle(-1.063829787234, 3, 0),
	Angle(-1.2765957446809, 2.75, 0),
	Angle(-2.1276595744681, -1.25, 0),
	Angle(-1.2765957446809, -2.75, 0),
	Angle(-0.63829787234043, -3, 0),
	Angle(-0.42553191489362, -2.75, 0),
	Angle(-0.42553191489362, -3, 0),
	Angle(-0.63829787234043, -2.75, 0),
	Angle(-0.63829787234043, -3, 0),
	Angle(-0.42553191489362, -3, 0),
	Angle(-0.42553191489362, -3.25, 0),
	Angle(-1.2765957446809, -2.5, 0),
	Angle(-2.5531914893617, 1, 0),
	Angle(-0.85106382978723, 2.75, 0),
	Angle(-0.63829787234043, 3.5, 0),
	Angle(-0.42553191489362, 3.75, 0),
	Angle(-0.21276595744681, 3.75, 0),
	Angle(-0.21276595744681, 3.5, 0),	
	Angle(0, -0.25, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "556_rifle_ammo",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	},
	{
		Item = "hv_556_rifle_ammo",
		Projectile = ProjectileType.HighVelocity,
		Icon = "riflebullet",
	},
	{
		Item = "incendiary_556_rifle_ammo",
		Projectile = ProjectileType.Incendiary,
		Icon = "riflebullet",
	},
	{
		Item = "explosive_556_rifle_ammo",
		Projectile = ProjectileType.Explosive,
		Icon = "riflebullet",
	}
}

local SIMPLESIGHT_MATERIAL = Material( "models/darky_m/rust_weapons/mods/xhair_highvis.png" )
local HOLOSIGHT_MATERIAL = Material( "models/darky_m/rust_weapons/mods/holosight.reticle.standard.png" )
SWEP.Attachments = {
	["simple_handmade_sight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_ms_holosight.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.05, -2.8, 0.2))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-6.1, -4.6, 2.44))
			:SetIronSightsAng(Vector(-0.02, 0.012, 0))
			:SetRectilePosition(Vector(0.519, 0, 0))
			:SetRectileAngle(Angle(-90, 0, 90))
			:SetRectileScale(0.01)
			:SetRectileDrawCallback(function()
				surface.SetDrawColor(0, 0, 0)
				surface.SetMaterial(SIMPLESIGHT_MATERIAL)
				surface.DrawTexturedRect(-70, -70, 140, 140)
			end),
		["holosight"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_holo.mdl")
				:SetBone("main")
				:SetPosition(Vector(-0.15, -2.5, -0.2))
				:SetAngle(Angle(180, -90, 0))
				:SetIronSightsPos(Vector(-6.073, -2.6, 2.785))
				:SetIronSightsAng(Angle(0, 0, 0))
				:SetRectilePosition(Vector(0.47, -0.123, 0.3))
				:SetRectileAngle(Angle(0, -90, 0))
				:SetRectileScale(0.01)
				:SetRectileDrawCallback(function()
					surface.SetDrawColor(255, 0, 0)
					surface.SetMaterial(HOLOSIGHT_MATERIAL)
					surface.DrawTexturedRect(-40, -40, 80, 80)
				end),
		["silencer"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_silencer.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 0.5, 29))
				:SetAngle(Angle(0, 0, 180)),
		["weapon_flashlight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
				:SetBone("main")
				:SetPosition(Vector(-0.08, 2.03, 18.5))
				:SetAngle(Angle(0, -90, 180))
				:SetScale(1.1),
		["8x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.148, -3.13, 1.281))
				:SetAngle(Angle(0, 0, -90)),
		["16x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
				:SetBone("main")
				:SetPosition(Vector(-0.06, -1.354, 3.079))
				:SetAngle(Angle(180, 0, -90)),
		["weapon_lasersight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 1.568, 15.238))
				:SetAngle(Angle(0, -90, 180))
				:SetScale(1.1),
		["muzzle_brake"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 0.6, 26))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.5),
		["muzzle_boost"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 0.6, 26))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.5),
}