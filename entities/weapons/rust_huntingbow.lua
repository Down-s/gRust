AddCSLuaFile()

DEFINE_BASECLASS("rust_swep")

SWEP.Base = "rust_swep"
SWEP.Author = "Down"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_bow.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_bow.mdl"

SWEP.Primary.Automatic = false

SWEP.DownPos = Vector(0, 0, 0)
SWEP.DownAng = Angle(-10, 0, 0)
SWEP.ViewModelFOV       = 64

SWEP.Damage = 40
SWEP.RPM = 60
SWEP.AimCone = 1
SWEP.ClipSize = 1

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
end

-- Weapon

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetHoldType(self.HoldType)
    self.NextDeploy = CurTime() + 1

    return true
end

function SWEP:FireArrow()
    if (SERVER) then
        local pl = self:GetOwner()
    
        local ang = pl:GetAimVector():Angle()

        local arrowang = pl:GetAimVector():Angle()
        arrowang:RotateAroundAxis(arrowang:Right(), 270)

        local pos = pl:GetShootPos()

        local ent = gRust.CreateItemBag(gRust.CreateItem("arrow"), pos, ang)
        ent:SetPhysicsAttacker(pl, 10)
        ent:SetAngles(arrowang)
        ent:SetStick(true)
        ent.Thrower = pl
        ent.ThrowDamage = self.Damage
        ent.ImpactSound = self.HitSound
        ent.Trail = util.SpriteTrail(ent, 0, collor_white, false, 12, 0, 0.15, 0.05, "trails/laser")
    
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(self:GetOwner():EyeAngles():Forward() * 4000)
        end

        self:GetItem():SetClip(self:GetItem():GetClip() - 1)
        self:GetOwner().Belt:SyncSlot(self:GetBeltIndex())
    end
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()

    if (self.Deployed && !self.Attacked && self.NextFire < SysTime()) then
        self:EmitSound("darky_rust.bow-attack-" .. math.random(1, 3))
        self.Deployed = false
        self.Attacked = true

        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:FireArrow()
    end
end

function SWEP:Think()
    BaseClass.Think(self)

    if (!IsFirstTimePredicted()) then return end
    
    local pl = self:GetOwner()
    if (!IsValid(pl)) then return end

    if (pl:KeyDown(IN_ATTACK2)) then
        if (!self.Deployed && !self.Attacked && self.NextDeploy < SysTime()) then
            if (self:GetItem():GetClip() <= 0) then
                if (!pl:HasItem("arrow", 1)) then return end

                if (SERVER) then
                    pl:RemoveItem("arrow", 1)
                    
                    self:GetItem():SetClip(1)
                    self:GetOwner().Belt:SyncSlot(self:GetBeltIndex())
                end
            end

            if (SERVER && !IsFirstTimePredicted()) then
                pl:EmitSound("audioclips/weapons/bow/bow_draw.wav", 100)
            end

            self:SendWeaponAnim(ACT_VM_DEPLOY)
            self.NextFire = SysTime() + 1.5
            self.NextDeploy = SysTime() + 0.75
            self.Deployed = true
        end
    else
        if (self.Deployed && !self.Attacked) then
            self:EmitSound("audioclips/weapons/bow/bow_draw_cancel.wav", 100)
            self:SendWeaponAnim(ACT_VM_UNDEPLOY)
        end
        
        self.Attacked = false
        self.Deployed = false
    end
end