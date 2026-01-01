SWEP.Base = "rust_swep"

DEFINE_BASECLASS("rust_swep")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"

SWEP.ViewModelFOV = 60

SWEP.HoldType           = "ar2"

SWEP.ShootSound = "darky_rust.ak74u-attack"
SWEP.ShootSoundSilenced = "darky_rust.ak74u-attack-silenced" 
SWEP.ShellEffect = "EjectBrass_762Nato"
SWEP.MuzzleEffect = "CS_MuzzleFlash"

SWEP.IronSightsPos = Vector(-6.115, -6.896, 3.703)
SWEP.IronSightsAng = Vector(-0.3, 0.012, 0)
SWEP.IronSightsFOV = 50
SWEP.IronSightsTime  = 0.035

SWEP.DownPos = Vector(0, 0, 0)
SWEP.DownAng = Angle(-10, 0, 0)

SWEP.Damage = 50
SWEP.Bullets = 1
SWEP.RPM = 450
SWEP.AimCone = 0.2
SWEP.ClipSize = 30
SWEP.Range = 4096
SWEP.BulletVelocity = 5000

SWEP.Primary.Automatic = true

SWEP.RecoilAmount = 1.0
SWEP.RecoilLerpTime = 0.1
SWEP.RecoilTable = {}

SWEP.AmmoTypes = {}
SWEP.Attachments = {}

SWEP.Animations = {
	["Fire"] = ACT_VM_PRIMARYATTACK,
	["FireADS"] = ACT_VM_PRIMARYATTACK_1,
	["Draw"] = ACT_VM_DRAW,
	["Idle"] = ACT_VM_IDLE,
	["Reload"] = ACT_VM_RELOAD,
	["ReloadEmpty"] = ACT_VM_RELOAD,
}

if (SERVER) then
	gRust.CreateConfigValue("combat/projectiles.enable", true, true)
end

local ENABLE_PROJECTILES = gRust.GetConfigValue("combat/projectiles.enable")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Float", 0, "NextReload")
end

function SWEP:Deploy()
	BaseClass.Deploy(self)
	self:UpdateAttachments()
	self:SetHoldType(self.HoldType)
	
	if (self.SetNextReload) then
		self:SetNextReload(0)
	end
end

function SWEP:Reload()
end

function SWEP:OnReload()
	local nextReload = self.GetNextReload and self:GetNextReload() or 0
	if (nextReload > CurTime()) then return end
	if (self:Clip1() >= self.ClipSize) then return end
	local pl = self:GetOwner()
	local ammoType = self.AmmoTypes[self:GetAmmoType()]
	if (!ammoType) then return end
	if (!pl:HasItem(ammoType.Item)) then return end

	pl:SetAnimation(PLAYER_RELOAD)
	self:PlayAnimation("Reload")

	if (self.SetNextReload) then
		self:SetNextReload(CurTime() + (self.ReloadTime or self:SequenceDuration()))
	end
end

function SWEP:FinishReload()
	local pl = self:GetOwner()
	local ammoType = self.AmmoTypes[self:GetAmmoType()]
	if (!ammoType) then return end
	local refill = math.min(self.ClipSize - self:Clip1(), pl:ItemCount(ammoType.Item))
	self:SetClip(self:Clip1() + refill)
	pl:RemoveItem(ammoType.Item, refill)
end

function SWEP:IsReloading()
	if (!self.GetNextReload) then return false end
	return self:GetNextReload() != 0
end

function SWEP:Think()
	BaseClass.Think(self)
	self:CheckForAttachmentChanges()

	if (SERVER) then
		local pl = self:GetOwner()
		if (pl:KeyDown(IN_RELOAD)) then
			self.NextReloadTime = self.NextReloadTime or CurTime() + 0.3
		else
			if (self.NextReloadTime) then
				if (self.NextReloadTime > CurTime()) then
					self:OnReload()
				end
	
				self.NextReloadTime = nil
			end
		end

		local nextReload = self:GetNextReload()
		if (nextReload != 0 and nextReload <= CurTime()) then
			self:SetNextReload(0)
			self:FinishReload()
		end
	else
		self:UpdateFlashlight()
	end
end

function SWEP:CheckForAttachmentChanges()
	-- TODO: Find something more efficient
	local item = self:GetItem()
	if (!item) then return end

	local inv = item:GetInventory()
	if (!inv) then return end

	local attachments = {}
	local slots = inv:GetSlots()
	
	for i = 1, slots do
		local item = inv[i]
		if (!item) then continue end

		attachments[#attachments + 1] = item:GetIndex()
	end

	if (self.OldAttachments) then
		local old = self.OldAttachments
		for i = 1, slots do
			if (attachments[i] != old[i]) then
				self:UpdateAttachments()
				break
			end
		end
	end

	self.OldAttachments = attachments
end

function SWEP:PlayAnimation(name)
	local anim = self.Animations[name]
	if (anim and anim != ACT_INVALID) then
		self:SendWeaponAnim(anim)
	end
end

function SWEP:GetSequence(name)
	return self.Animations[name]
end

function SWEP:ShootEffects()
	local pl = self:GetOwner()
	local ent = (pl != LocalPlayer() or pl:ShouldDrawLocalPlayer()) and self or pl:GetViewModel()

	local effect = self.MuzzleEffect
	if (effect and effect != "") then
		local attachment = ent:GetAttachment(1)
		if (!attachment) then return end

		local fx = EffectData()
		fx:SetOrigin(attachment.Pos)
		fx:SetEntity(ent)
		fx:SetAngles(attachment.Ang)
		fx:SetScale(2)
		fx:SetAttachment(1)
		util.Effect(effect, fx)
	end

	local effect = self.ShellEffect
	if (effect and effect != "") then
		local attachment = ent:GetAttachment(2)
		if (!attachment) then return end

		local fx = EffectData()
		fx:SetOrigin(attachment.Pos)
		fx:SetEntity(ent)
		fx:SetAngles(attachment.Ang)
		fx:SetFlags(50)
		fx:SetAttachment(2)
		util.Effect(effect, fx)
	end
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self:SetHoldType(self.HoldType)
	hook.Add("Think", self, self.UpdateVars)
end

function SWEP:CanPrimaryAttack()
	return !self:GetOwner():IsBot() and self:Clip1() > 0
end

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
	if (!IsValid(self:GetItem())) then return end
	local pl = self:GetOwner()
	local aimCone = self.AimCone
	local animation = "Fire"

	if (self.IronSightsDelta > 0.1) then
		if (self.Bullets == 1) then
			aimCone = Lerp(self.IronSightsDelta, aimCone, 0)
		end

		animation = "FireADS"
	end

	local rpm = self.RPM * (self.Stats and self.Stats.RateOfFireMultiplier or 1)
	self:SetNextPrimaryFire(CurTime() + (60 / rpm))

	local shootSound = (self.Stats and self.Stats.Silenced) and self.ShootSoundSilenced or self.ShootSound
	local shootVolume = (self.Stats and self.Stats.Silenced) and 50 or 100

	self:PlayAnimation(animation)
	self:EmitSound(shootSound, 100, shootVolume, 1, CHAN_WEAPON)
	pl:SetAnimation(PLAYER_ATTACK1)

	if (SERVER) then
		local clip = self:Clip1() - 1
		self:SetClip1(clip)
		self:GetItem():SetClip(clip)
		local breakRate = (1 / self.ClipSize) * 0.075
		self:LoseCondition(breakRate)
		pl.Belt:SyncSlot(self:GetBeltIndex())
		
		local RF = RecipientFilter()
		RF:AddAllPlayers()
		RF:RemovePlayer(pl)
		
		net.Start("gRust.Gun.Shoot")
		net.WriteEntity(self)
		net.Send(RF)

		-- TODO: Find a more elegant solution
		if (game.SinglePlayer()) then
			self:CallOnClient("ShootEffects")
			self:CallOnClient("Recoil")
		end
	else
		if (IsFirstTimePredicted()) then
			self:ShootEffects()
			self:Recoil()
		end
	end

	pl:HaltSprint(0.6)

	pl:LagCompensation(true)
	self:FireBullet(aimCone)
	pl:LagCompensation(false)
end

function SWEP:FireBullet(aimcone)
	if (!IsFirstTimePredicted()) then return end
	local pl = self:GetOwner()
	
	local ammoType = self.AmmoTypes[self:GetAmmoType()]
	if (!ammoType) then return end

	local spread = Vector(aimcone, aimcone, 0) * 16
	local randSpreadX = util.SharedRandom("gRust.SpreadX", -spread.x, spread.x, CurTime() + pl:EntIndex())
	local randSpreadY = util.SharedRandom("gRust.SpreadY", -spread.y, spread.y, CurTime() + pl:EntIndex() * 2)
	local spreadAngle = Angle(randSpreadX, randSpreadY, 0)
	
	local aim = (pl:GetAimVector():Angle() + spreadAngle):Forward()
	local velocity = aim * self.BulletVelocity * (self.Stats and self.Stats.VelocityMultiplier or 1)
	-- local velocity = pl:GetAimVector() * self.BulletVelocity * (self.Stats and self.Stats.VelocityMultiplier or 1)
	local damage = self.Damage * (self.Stats and self.Stats.DamageMultiplier or 1)

	if (self.Bullets > 1 or !ENABLE_PROJECTILES) then
		local bullet = {}
		bullet.Num		= self.Bullets
		bullet.Src		= pl:GetShootPos()
		bullet.Dir		= pl:GetAimVector()
		bullet.Spread	= spread * 0.04
		bullet.Tracer	= 3
		bullet.Force	= 1
		bullet.Damage	= self.Damage / self.Bullets
		bullet.Attacker = pl
	
		pl:FireBullets(bullet)
	else
		gRust.CreateProjectile()
			:SetPosition(pl:GetShootPos())
			:SetVelocity(velocity)
			:SetWeapon(self)
			:SetOwner(pl)
			:SetProjectileType(ammoType.Projectile)
			:SetDamage(damage)
			:Fire()
	end
end

function SWEP:UpdateVars()
    if (self:IsReloading()) then
		self.IronSightsDelta = 0
		return
	end

	local pl = self:GetOwner()
    local ft = FrameTime()

    self.IronSightsRawDelta = self.IronSightsRawDelta or 0
    if (pl:KeyDown(IN_ATTACK2) and !self.IsDown and !self:IsDeploying()) then
        self.IronSightsRawDelta = Lerp(ft / self.IronSightsTime, self.IronSightsRawDelta, 1)

        self.BobbingScale = 0.25
        self.SwayScale = 0
    else
        self.IronSightsRawDelta = Lerp(ft / self.IronSightsTime, self.IronSightsRawDelta, 0)

        self.BobbingScale = 1
        self.SwayScale = -0.5
    end

    self.IronSightsDelta = self.IronSightsRawDelta
end

--
-- Attachments
--

local SCOPE_8X_CROSSHAIR = Material("models/darky_m/rust_weapons/mods/4x_crosshair")
local SCOPE_16X_CROSSHAIR = Material("models/darky_m/rust_weapons/mods/8x_crosshair")

function SWEP:UpdateAttachments()
	self.Stats = {
		IronSightsPos = self.IronSightsPos,
		IronSightsAng = self.IronSightsAng,
		Silenced = false,
		Flashlight = false,
		ZoomCrosshair = nil,
		ZoomFovMultiplier = 1,
		DamageMultiplier = 1,
		VelocityMultiplier = 1,
		AimConeMultiplier = 1,
		RecoilMultiplier = 1,
		RateOfFireMultiplier = 1,
	}

	self.ISPos = self.IronSightsPos
	self.ISAng = self.IronSightsAng

	if (CLIENT) then
		self.AttachmentEntities = self.AttachmentEntities or {}
		for k, v in ipairs(self.AttachmentEntities) do
			if (IsValid(v)) then
				v:Remove()
			end
		end
	end

	local item = self:GetItem()
	if (!item) then return end
	local attachments = item:GetInventory()
	if (!attachments) then return end

	for i = 1, attachments:GetSlots() do
		local attachment = attachments[i]
		if (!attachment) then continue end
		local id = attachment:GetId()
		local attachmentInfo = self.Attachments[id]
		if (!attachmentInfo) then continue end

		if (CLIENT) then
			local attachmentEntity = ClientsideModel(attachmentInfo.Model, RENDERGROUP_BOTH)
			attachmentEntity:SetNoDraw(true)
			attachmentEntity:SetParent(self)
			attachmentEntity.AttachmentInfo = attachmentInfo
			
			self.AttachmentEntities[#self.AttachmentEntities + 1] = attachmentEntity
		end

		--!
		--! Variables 
		--!

		if (attachmentInfo.IronSightsPos) then
			self.Stats.IronSightsPos = attachmentInfo.IronSightsPos
		end

		if (attachmentInfo.IronSightsAng) then
			self.Stats.IronSightsAng = attachmentInfo.IronSightsAng
		end

		-- TODO: Clean this up, maybe move it to a callback in the item register
		-- I don't want to add them to the attachment info because they are static and won't change per weapon
		if (id == "silencer") then
			self.Stats.Silenced = true
			self.Stats.DamageMultiplier = self.Stats.DamageMultiplier - (self.Stats.DamageMultiplier * 0.25)
			self.Stats.VelocityMultiplier = self.Stats.VelocityMultiplier - (self.Stats.VelocityMultiplier * 0.25)
		elseif (id == "holosight") then
			self.Stats.AimConeMultiplier = self.Stats.AimConeMultiplier - (self.Stats.AimConeMultiplier * 0.2)
		elseif (id == "weapon_flashlight") then
			self.Stats.Flashlight = true
		elseif (id == "8x_zoom_scope") then
			self.Stats.ZoomCrosshair = SCOPE_8X_CROSSHAIR
			self.Stats.RecoilMultiplier = self.Stats.RecoilMultiplier + (self.Stats.RecoilMultiplier * 0.5)
			self.Stats.ZoomFovMultiplier = 0.2
		elseif (id == "16x_zoom_scope") then
			self.Stats.ZoomCrosshair = SCOPE_16X_CROSSHAIR
			self.Stats.RecoilMultiplier = self.Stats.RecoilMultiplier + (self.Stats.RecoilMultiplier * 0.5)
			self.Stats.ZoomFovMultiplier = 0.1
		elseif (id == "weapon_lasersight") then
			self.Stats.AimConeMultiplier = self.Stats.AimConeMultiplier - (self.Stats.AimConeMultiplier * 0.2)
		elseif (id == "muzzle_brake") then
			self.Stats.DamageMultiplier = self.Stats.DamageMultiplier - (self.Stats.DamageMultiplier * 0.2)
			self.Stats.AimConeMultiplier = self.Stats.AimConeMultiplier + (self.Stats.AimConeMultiplier * 0.2)
			self.Stats.VelocityMultiplier = self.Stats.VelocityMultiplier - (self.Stats.VelocityMultiplier * 0.2)
			self.Stats.RecoilMultiplier = self.Stats.RecoilMultiplier - (self.Stats.RecoilMultiplier * 0.5)
		elseif (id == "muzzle_boost") then
			self.Stats.DamageMultiplier = self.Stats.DamageMultiplier - (self.Stats.DamageMultiplier * 0.1)
			self.Stats.RateOfFireMultiplier = self.Stats.RateOfFireMultiplier + (self.Stats.RateOfFireMultiplier * 0.1)
			self.Stats.VelocityMultiplier = self.Stats.VelocityMultiplier - (self.Stats.VelocityMultiplier * 0.1)
		end
	end

	self:CheckFlashlight()
end

function SWEP:CheckFlashlight()
end