AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_python.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_python.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-4.385, -5.453, 2.475)
SWEP.IronSightsAng = Vector(0.1, 0.07, 0)
SWEP.IronSightsFOV = 70

SWEP.Damage = 55
SWEP.RPM = 400
SWEP.AimCone = 0.5
SWEP.ClipSize = 6
SWEP.Range = 4096

SWEP.MuzzleEffect = ""

SWEP.ShootSound = "darky_rust.python-attack"
SWEP.ShootSoundSilenced = "darky_rust.python-attack-silenced"

SWEP.RecoilAmount = 0.5
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-2.5*50, 0.4*2, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "pistol_bullet",
		Projectile = ProjectileType.Normal,
		Icon = "pistolbullet",
	},
	{
		Item = "hv_pistol_ammo",
		Projectile = ProjectileType.HighVelocity,
		Icon = "pistolbullet",
	},
	{
		Item = "incendiary_pistol_bullet",
		Projectile = ProjectileType.Incendiary,
		Icon = "pistolbullet",
	}
}

local SIMPLESIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/xhair_highvis.png")
local HOLOSIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/holosight.reticle.standard.png")

SWEP.Attachments = {
	["simple_handmade_sight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_ms_holosight.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.09, -1.9-1.0, -0.65+3.9))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-4.405, -5.453, 1.042))
			:SetIronSightsAng(Angle(0.1, 0.07, 0))
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
			:SetPosition(Vector(-0.15, -1.5-1.0, -0.8+3.9))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.8)
			:SetIronSightsPos(Vector(-4.341, -5.5, 1.492))
			:SetIronSightsAng(Angle(0.3, 0.2, 0))
			:SetRectilePosition(Vector(0.4, -0.08, 0.3))
			:SetRectileAngle(Angle(0, -90, 0))
			:SetRectileScale(0.01)
			:SetRectileDrawCallback(function()
				surface.SetDrawColor(255, 0, 0)
				surface.SetMaterial(HOLOSIGHT_MATERIAL)
				surface.DrawTexturedRect(-40, -40, 80, 80)
			end),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.2, 7.4))
			:SetAngle(Angle(0, 90, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.16, -2.3-1.0, -1+3.9))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(1.0),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.06, -0.4-1.2, 1.9+2))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(1.0),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.2, 7.4))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(0.9),
}