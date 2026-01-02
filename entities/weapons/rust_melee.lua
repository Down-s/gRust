AddCSLuaFile()

DEFINE_BASECLASS("rust_swep")

SWEP.Base = "rust_swep"
SWEP.Author = "Down"

SWEP.SwingSound = ""
SWEP.HitSound = ""
SWEP.Throwable = true

SWEP.Primary.Automatic = true

SWEP.Damage         = 10
SWEP.AttackSpeed    = 46
SWEP.Range          = 1.25
SWEP.Draw           = 1
SWEP.Throw          = true
SWEP.AttackDelay    = 0.475

SWEP.Damage         = 10
SWEP.AttackRate     = 46
SWEP.AttackSize     = 0.2
SWEP.Range          = 1.3
SWEP.OreGather      = 5 
SWEP.TreeGather     = 10
SWEP.FleshGather    = 10

SWEP.PrimaryAttacks = {
    {
        StartAct = ACT_VM_SWINGMISS,
        EndAct = ACT_VM_SWINGHIT,
    }
}

SWEP.HoldType       = "melee2"

-- Setup

function SWEP:SetupDataTables()
    --BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 0, "NextAttack")
    self:NetworkVar("Float", 1, "NextThrow")
end

-- Weapon

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextAttack(0)
    self:SetNextThrow(0)
    self:SetHoldType(self.HoldType)
    self.Thrown = false
    self.IsThrowing = false

    return true
end

function SWEP:Throw()
    if (!IsValid(self:GetItem())) then return end

    if (self.Thrown) then return end
    if (!IsFirstTimePredicted()) then return end

    self.Thrown = true
    self.IsThrowing = false

    local pl = self:GetOwner()

    if (SERVER) then
        if (!pl.Belt[self:GetBeltIndex()]) then return end
        pl.Belt:Remove(self:GetBeltIndex(), 1)
        
        local pos = pl:GetShootPos()
        local ang = pl:EyeAngles()
        local ent = gRust.CreateItemBag(self.Item, pos, ang)
        ent:SetPhysicsAttacker(pl)
        ent.Thrower = pl
        ent.ThrowDamage = self.Damage
        ent.ImpactSound = self.HitSound
    
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(pl:EyeAngles():Forward() * 1500)
        end
    end
end

function SWEP:PrimaryAttack()
    if (!IsValid(self:GetItem())) then return end
    
    local pl = self:GetOwner()

    if (self.IsThrowing) then
        if (self:GetNextThrow() == 0) then
            self:SetNextThrow(CurTime() + 0.275)
            self:SendWeaponAnim(ACT_VM_THROW)
            self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    	    pl:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_THROW)
        end
        
        return
    end

    self.AttackIndex = math.Round(util.SharedRandom("Rust_SWEP_AttackIndex", 1, #self.PrimaryAttacks, CurTime()))

    self:SendWeaponAnim(self.PrimaryAttacks[self.AttackIndex].StartAct)
    pl:SetAnimation(PLAYER_ATTACK1)

    self:SetNextPrimaryFire(CurTime() + (60 / self.AttackRate))
    self:SetNextAttack(CurTime() + self.AttackDelay)

    self:EmitSound(self.SwingSound)
end

function SWEP:Hit(tr)
    local pl = self:GetOwner()
    
    self:EmitSound(self.HitSound)
    
    local ent = tr.Entity
    if (IsValid(ent)) then
        local dmg = DamageInfo()
        dmg:SetAttacker(pl)
        dmg:SetInflictor(self)
        dmg:SetDamage(self.Damage)
        dmg:SetDamageType(DMG_CLUB)
        dmg:SetDamagePosition(tr.HitPos)
        
        if (SERVER) then
            if (ent:IsPlayer()) then
                hook.Run("ScalePlayerDamage", ent, tr.HitGroup, dmg)
            end
            
            ent:TakeDamageInfo(dmg)
        end
    end

    if (SERVER) then
		self:LoseCondition(0.005)
		self:GetOwner().Belt:SyncSlot(self:GetBeltIndex())
    end

    -- local pos1 = tr.HitPos + tr.HitNormal
    -- local pos2 = tr.HitPos - tr.HitNormal

    -- local effectdata = EffectData()
    -- effectdata:SetEntity(ent)
    -- effectdata:SetOrigin(tr.HitPos)
    -- effectdata:SetStart(pos1)
    -- effectdata:SetNormal(tr.HitNormal)
    -- effectdata:SetScale(1)
    -- util.Effect("Impact", effectdata)
end

function SWEP:CheckThrow()
    local pl = self:GetOwner()

    if (pl:KeyDown(IN_ATTACK2)) then
        local nextAttack = self:GetNextAttack()
        if (!self.IsThrowing and !self.Thrown and nextAttack == 0) then
            self.IsThrowing = true
            self:SendWeaponAnim(ACT_VM_PULLPIN)
            self:SetHoldType("melee")
        end
    else
        if (self.IsThrowing) then
            self.IsThrowing = false
            self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
            self:SetNextPrimaryFire(math.max(CurTime() + self:SequenceDuration(), self:GetNextPrimaryFire()))
            self:SetHoldType(self.HoldType)
        end

        self.Thrown = false
    end

    if (self:GetNextThrow() != 0 and self:GetNextThrow() <= CurTime() and self.IsThrowing and !self.Thrown) then
        self:Throw()
    end
end

function SWEP:Think()
    BaseClass.Think(self)

    -- No need for prediction in singleplayer
    if (game.SinglePlayer() and CLIENT) then return end
    
    self:CheckThrow()

    local pl = self:GetOwner()
    if (!IsValid(pl)) then return end
    if (!IsValid(self:GetItem())) then return end
    
    local nextAttack = self:GetNextAttack()
    if (nextAttack == 0 or nextAttack > CurTime()) then return end

    local tr = self:TraceRange()

    if (tr.Hit) then
        self:SendWeaponAnim(self.PrimaryAttacks[self.AttackIndex].EndAct)

        self:Hit(tr)
    end

    pl:HaltSprint(0.6)
    self:SetNextAttack(0)
end