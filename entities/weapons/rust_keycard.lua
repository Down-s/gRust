AddCSLuaFile()

DEFINE_BASECLASS("rust_swep")

SWEP.Base = "rust_swep"

SWEP.WorldModel = "models/darky_m/rust/puzzle/access_card.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_keycard.mdl"

SWEP.DownPos = Vector(0, 0, -3.5)

function SWEP:OnItemSet()
    local id = self:GetItem():GetRegister():GetId()

    if (id == "green_keycard") then
        self:GetOwner():GetViewModel():SetSkin(0)
        self.Level = 0
    elseif (id == "blue_keycard") then
        self:GetOwner():GetViewModel():SetSkin(1)
        self.Level = 1
    elseif (id == "red_keycard") then
        self:GetOwner():GetViewModel():SetSkin(2)
        self.Level = 2
    end
end

function SWEP:PrimaryAttack()
    if (self:GetItem():GetCondition() <= 0) then return end
    
    self:SetNextPrimaryFire(CurTime() + 1.5)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    if (SERVER) then
        local pl = self:GetOwner()
        local ent = pl:GetEyeTraceNoCursor().Entity
        if (ent:GetClass() != "rust_cardreader") then return end
        if (ent:GetPos():DistToSqr(pl:EyePos()) > 4096) then return end
        if (!ent:GetPower()) then return end
        if (ent.Door:GetOpen()) then return end
        if (ent.Level != self.Level) then return end
    
        ent:AcceptKeycard()
    
        self:LoseCondition(0.25)
        pl.Belt:SyncSlot(self:GetBeltIndex())
    end
end