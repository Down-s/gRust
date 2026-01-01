SWEP.Base = "rust_swep"

SWEP.DownPos = Vector(0, 0, -3.5)

function SWEP:SetupDataTables()
    --BaseClass.SetupDataTables(self)
    --self:NetworkVar("Float", 0, "NextThrow")
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self.NextAttack = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    self.NextThrow = nil
end

function SWEP:PrimaryAttack()
    if ((self.NextAttack or 0) > CurTime()) then return end
    if (!IsValid(self:GetItem())) then return end
    self.NextThrow = CurTime() + 0
    self.NextAttack = CurTime() + 1.4

    self:EmitSound("darky_rust.throw-item-small")

    self:SendWeaponAnim(ACT_VM_THROW)
    timer.Simple(1, function()
        if (!IsValid(self)) then return end
        self:SendWeaponAnim(ACT_VM_DRAW)
    end)
end

function SWEP:Throw()
    local pl = self:GetOwner()
    
    if (SERVER) then
        local ent = ents.Create("rust_bomb")
        if (!IsValid(ent)) then return end
    
        ent:SetModel(self.WorldModel)
        ent:SetPos(pl:GetShootPos())
        ent:SetAngles(pl:EyeAngles() + Angle(-90, 0, 0))
        ent:SetOwner(pl)
        ent:SetFuse(self.Delay)
        ent:SetExplodeSound(self:GetExplodeSound())
        ent:SetBeepSound(self.BeepSound)
        ent:SetStick(self.Stick)
        ent:SetBeepDelay(0.8)
        ent:SetRadius(self.Radius * METERS_TO_UNITS)
        ent:SetDamage(self.Damage)
        ent:SetOwner(pl)
        ent.RaidEfficiency = self.RaidEfficiency
        ent:Spawn()
    
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(pl:GetAimVector() * 1000)
        end
    end
end

function SWEP:Think()
    if (self.NextThrow and self.NextThrow < CurTime()) then
        local pl = self:GetOwner()
        if (pl.Belt[self:GetBeltIndex()] != self.Item) then return end

        self.NextThrow = nil
        self:Throw()

        if (SERVER) then
            pl.Belt:Remove(self:GetBeltIndex(), 1)
        end
    end
end