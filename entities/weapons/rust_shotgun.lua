AddCSLuaFile()

SWEP.Base = "rust_gun"
DEFINE_BASECLASS("rust_gun")

--SWEP.ReloadDelay = 1.5 -- time between start of reload and first shell insert
SWEP.ShellInsertTime = 0.5 -- time between shell inserts
SWEP.InsertDelay = 0.5
SWEP.AimCone = 0.15
SWEP.ClipSize = 8
SWEP.Bullets = 10

SWEP.Primary.Automatic = false

SWEP.Animations = {
	["Fire"] = ACT_VM_PRIMARYATTACK,
	["FireADS"] = ACT_VM_PRIMARYATTACK,
	["Draw"] = ACT_VM_DRAW,
	["Idle"] = ACT_VM_IDLE,
	["ReloadStart"] = ACT_SHOTGUN_RELOAD_START,
    ["ReloadFinish"] = ACT_SHOTGUN_RELOAD_FINISH,
	["InsertShell"] = ACT_VM_RELOAD,
    ["Pump"] = ACT_SHOTGUN_PUMP,
}

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "AmmoType")
    self:NetworkVar("Float", 0, "NextShell")
    self:NetworkVar("Bool", 0, "Pump")
    self:NetworkVar("Bool", 1, "Reloading")
end

function SWEP:Deploy()
    self:SetNextShell(0)
    self:SetPump(false)
    self:SetReloading(false)
    return BaseClass.Deploy(self)
end

function SWEP:CanReload()
    local ammoType = self.AmmoTypes[self:GetAmmoType()]
    if (!ammoType) then return false end
    if (self:GetPump()) then return false end
    
    return self:GetOwner():HasItem(ammoType.Item) and self:Clip1() < self.ClipSize
end

function SWEP:CanPrimaryAttack()
	return self:Clip1() > 0 and self:GetNextShell() == 0
end

function SWEP:Reload()
end

function SWEP:StartReload()
    if (!self:CanReload()) then return end
    if (self:GetReloading()) then return end

    self:PlayAnimation("ReloadStart")
    self:SetNextShell(CurTime() + self:SequenceDuration())
    self:SetReloading(true)
end

function SWEP:InsertShell()
    if (!self:CanReload()) then return end

    local pl = self:GetOwner()
    self:PlayAnimation("InsertShell")
    self:SetNextShell(CurTime() + self:SequenceDuration())

    timer.Simple(self.InsertDelay, function()
        if (!IsValid(self)) then return end

        local ammoType = self.AmmoTypes[self:GetAmmoType()]
        self:SetClip(self:Clip1() + 1)
        pl:RemoveItem(ammoType.Item, 1)
    end)
end

function SWEP:Think()
    if (CLIENT) then
        self:CheckAmmoMenu()
        return
    end

    local pl = self:GetOwner()
    if (pl:KeyDown(IN_RELOAD)) then
        self.NextReloadTime = self.NextReloadTime or CurTime() + 0.3
    elseif (self.NextReloadTime) then
        if (self.NextReloadTime > CurTime()) then
            self:StartReload()
        end

        self.NextReloadTime = nil
    end

    local nextShell = self:GetNextShell()
    if (nextShell != 0 and nextShell <= CurTime()) then
        if (self:CanReload()) then
            self:SetNextShell(CurTime() + self.ShellInsertTime)
            self:InsertShell()
        else
            self:PlayAnimation("ReloadFinish")
            self:SetReloading(false)
            self:SetNextShell(0)
        end
    end

    if (self:GetPump() and self.PumpTime <= CurTime()) then
        self:SetPump(false)
        self:PlayAnimation("Pump")
    end
end

function SWEP:FireBullet(aimCone)
    self:SetPump(true)
    self.PumpTime = CurTime() + 0.3
    return BaseClass.FireBullet(self, aimCone)
end