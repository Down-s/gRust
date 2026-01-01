AddCSLuaFile()

SWEP.UseHands = true
SWEP.m_WeaponDeploySpeed = 1

SWEP.ViewModelPos = Vector(0, 0, 0)
SWEP.ViewModelAng = Vector(0, 0, 0)
SWEP.ViewModelFOV = 50
SWEP.SwayScale = -0.5
SWEP.BobScale = 0

SWEP.ItemDamageScale = 1

SWEP.BobbingScale = 1

SWEP.DownPos = Vector(-5, 0, -4)
SWEP.DownAng = Angle(0, 0, 0)

SWEP.Range = 1
SWEP.HoldType = "pistol"
SWEP.AmmoTypes = {}

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)

    if (CLIENT) then
        local PieMenu = gRust.CreatePieMenu()
        for k, v in ipairs(self.AmmoTypes) do
            PieMenu:CreateOption()
            :SetTitle(gRust.GetItemRegister(v.Item):GetName())
            :SetIcon(v.Icon)
            :SetCondition(false, function()
                return LocalPlayer():HasItem(v.Item)
            end)
            :SetCallback(function()
                net.Start("gRust.SetAmmoType")
                net.WriteUInt(k, 8)
                net.SendToServer()
            end)
        end
    
        self.AmmoPieMenu = PieMenu
    end
end

function SWEP:Deploy()
	if (CLIENT) then
		self.BeltIndex = gRust.Hotbar.SelectedSlot
    end

    self.DeployStart = CurTime()
end

function SWEP:IsDeploying()
    return self.DeployStart and self.DeployStart + self:SequenceDuration() > CurTime()
end

function SWEP:OnItemSet()
end

function SWEP:SetItem(item, beltIndex)
    self.Item = item
    self.BeltIndex = beltIndex
    item:SetClip(item:GetClip() or 0)
    self:SetClip1(item:GetClip() or 0)

    if (#self.AmmoTypes != 0) then
        item.AmmoType = item.AmmoType or 1
        self:SetAmmoType(item.AmmoType)
    end

    self:OnItemSet(item)
end

function SWEP:GetItem()
	return SERVER and self.Item or self:GetOwner().Belt[gRust.Hotbar and gRust.Hotbar.SelectedSlot]
end

function SWEP:GetBeltIndex()
    for k, v in ipairs(self:GetOwner().Belt) do
        if (v == self:GetItem()) then
            return k
        end
    end

    return -1
end

function SWEP:LoseCondition(loss)
    local item = self:GetItem()
    local condition = item:GetCondition()

    if (condition - loss <= 0) then
        self:GetOwner():EmitSound("item.break")
        self:Remove()
        item:SetCondition(0)
        return
    end

    item:SetCondition(condition - loss)
end

function SWEP:SetClip(clip)
	if (CLIENT) then return end

	self:SetClip1(clip) -- Using GetClip() on the client is synced too early
	self:GetItem():SetClip(clip)
	self:GetOwner().Belt:SyncSlot(self:GetBeltIndex())
end

function SWEP:GetClip()
	return self:GetItem():GetClip()
end

function SWEP:ChangeAmmoType(index)
    local currentAmmoType = self.AmmoTypes[self:GetAmmoType()]
    local newAmmoType = self.AmmoTypes[index]
    if (currentAmmoType == newAmmoType) then return end
    local pl = self:GetOwner()
    if (!pl:HasItem(newAmmoType.Item)) then return end

    pl:UnloadBullets(pl.Belt, self:GetBeltIndex())
    self:SetClip1(0)
    self:GetItem().AmmoType = index
    self:SetAmmoType(index)

    self:OnReload()
end

function SWEP:UnloadAmmo()
    local pl = self:GetOwner()
    local ammoType = self:GetAmmoType()
    local ammo = self:GetClip()

    local item = gRust.CreateItem(self.AmmoTypes[ammoType].Item, ammo)
    pl:AddItem(item)

    self:SetClip(0)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "AmmoType")
end

local DOWN_SPEED = 10
function SWEP:HandleBobbing(pos, ang)
    local pl = self:GetOwner()
    local Forward = ang:Forward()
    local Right = ang:Right()
    local Up = ang:Up()

    do
        self.DownProgress = self.DownProgress or 0
        if (pl:IsSprinting() or (not pl:IsOnGround() and not pl:InVehicle())) then
            self.DownProgress = Lerp(FrameTime() * DOWN_SPEED, self.DownProgress, 1)
            self.IsDown = true
        else
            self.DownProgress = Lerp(FrameTime() * DOWN_SPEED, self.DownProgress, 0)
            self.IsDown = false
        end
    
        local Down = self.DownProgress
        pos = pos + (Forward * self.DownPos.x) * Down
        pos = pos + (Right * self.DownPos.y) * Down
        pos = pos + (Up * self.DownPos.z) * Down 
    
        ang:RotateAroundAxis(Right, self.DownAng.x * Down)
        ang:RotateAroundAxis(Forward, self.DownAng.y * Down)
        ang:RotateAroundAxis(Up, self.DownAng.z * Down)
    end

    do
        local Velocity = pl:GetVelocity():Length()
        local Multiplier = Velocity / pl:GetWalkSpeed() * 0.5

        if (pl:IsOnGround()) then
            self.BobProgress = Lerp(FrameTime() * 10, self.BobProgress or 0, 1)
        else
            self.BobProgress = Lerp(FrameTime() * 10, self.BobProgress or 0, 0)
        end

        local Speed = 12.5
		ang:RotateAroundAxis(ang:Up(), math.sin(SysTime() * Speed) * (2 * Multiplier) * self.BobProgress * self.BobbingScale)
		ang:RotateAroundAxis(ang:Forward(), math.sin(SysTime() * Speed) * (3 * Multiplier) * self.BobProgress * self.BobbingScale)
    end

    return pos, ang
end

function SWEP:HandleSpacing(pos, ang)
    local tr = {}
    tr.start = pos
    tr.endpos = tr.start + ang:Forward() * 36
    tr.filter = self:GetOwner()
    --tr.mask = MASK_SOLID_BRUSHONLY
    tr = util.TraceLine(tr)

    if (tr.Hit) then
        self.SpacingProgress = Lerp(FrameTime() * 10, self.SpacingProgress or 0, 1)
        self.SpacingFraction = tr.Fraction
    else
        self.SpacingProgress = Lerp(FrameTime() * 10, self.SpacingProgress or 0, 0)
    end

    pos = pos - ang:Forward() * ((1 - (self.SpacingFraction or 0)) * self.SpacingProgress * 10)

    return pos, ang
end

function SWEP:GetViewModelPosition(pos, ang)
    pos = pos + self.ViewModelPos.x * ang:Right()
    pos = pos + self.ViewModelPos.y * ang:Forward()
    pos = pos + self.ViewModelPos.z * ang:Up()

    ang:RotateAroundAxis(ang:Right(), self.ViewModelAng.x)
    ang:RotateAroundAxis(ang:Forward(), self.ViewModelAng.y)
    ang:RotateAroundAxis(ang:Up(), self.ViewModelAng.z)

    pos, ang = self:HandleBobbing(pos, ang)
    pos, ang = self:HandleSpacing(pos, ang)

    return pos, ang
end

function SWEP:CheckAmmoMenu()
    local pl = self:GetOwner()

    if (pl:KeyDown(IN_RELOAD)) then
        if (!self.ReloadTime) then
            self.ReloadTime = CurTime() + 0.35
        end

        if (self.ReloadTime <= CurTime() and !self.AmmoPieMenuOpen) then
            self.AmmoPieMenu:Open()
            self.AmmoPieMenuOpen = true
        end
    else
        if (self.ReloadTime and self.ReloadTime < CurTime()) then
            self.AmmoPieMenu:Close()
            self.AmmoPieMenuOpen = false
        end

        self.ReloadTime = nil
    end
end

function SWEP:Think()
    if (CLIENT) then
        self:CheckAmmoMenu()
    end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

local TRACE_MINS = Vector(-2, -2, -2)
local TRACE_MAXS = Vector(2, 2, 2)
function SWEP:TraceRange(range)
    range = range or self.Range
    local pl = self:GetOwner()

    pl:LagCompensation(true)
    local tr = util.TraceHull({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * (range * METERS_TO_UNITS),
        mins = TRACE_MINS,
        maxs = TRACE_MAXS,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })
    pl:LagCompensation(false)

    return tr
end