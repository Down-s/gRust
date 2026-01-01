AddCSLuaFile()

DEFINE_BASECLASS("rust_swep")

SWEP.Base = "rust_swep"
SWEP.Author = "Down"

SWEP.Primary.Automatic = false
SWEP.HoldType = "grenade"

SWEP.UseDelay = 5
SWEP.UseAnimation = ACT_VM_PRIMARYATTACK
SWEP.Redeploy = false

SWEP.HP = 5
SWEP.Bleeding = 0
SWEP.Radiation = 0
SWEP.Healing = 0

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:PrimaryAttack()
    if (!IsFirstTimePredicted()) then return end

    self:SetNextPrimaryFire(CurTime() + self.UseDelay)
    self:SendWeaponAnim(self.UseAnimation)
    self:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RELOAD_PISTOL)
    
    if (CLIENT) then return end

    self.NextUse = CurTime() + self.UseDelay
    self:SetNextPrimaryFire(CurTime() + self.UseDelay + 1)
end

function SWEP:HealPlayer(pl)
    if (self.HP) then
        pl:SetHealth(math.min(pl:Health() + self.HP, pl:GetMaxHealth()))
    end

    if (self.Bleeding) then
        pl:SetBleeding(math.max(pl:GetBleeding() + self.Bleeding, 0))
    end

    if (self.Radiation) then
        pl:SetRadiation(math.max(pl:GetRadiation() + self.Radiation, 0))
    end

    if (self.Healing) then
        pl:SetHealing(math.max(pl:GetHealing() + self.Healing, 0))
    end

    pl.Belt:Remove(self:GetBeltIndex(), 1)
end

function SWEP:Think()
    if (self.NextUse and self.NextUse < CurTime()) then
        self.NextUse = nil
        self:HealPlayer(self:GetOwner())
        
        timer.Simple(1, function()
            if (IsValid(self)) then
                if (self.Redeploy) then
                    self:SendWeaponAnim(ACT_VM_DRAW)
                else
                    self:SendWeaponAnim(ACT_VM_IDLE)
                end
            end
        end)
    end
end