DEFINE_BASECLASS("rust_container")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetModel(self.BaseModel)

    self:SetInteractable(true)
    self:SetInteractText("OPEN")
    self:SetInteractIcon("open")

    if (self.MaxHP) then
        self:SetMaxHP(self.MaxHP)
        self:SetHP(self.MaxHP)
    end
    
    self.Containers = {}
    self:CreateContainers()

    self.Authorized = {}

    self.IdleOffset = self:EntIndex()
    self.RangeSqr = self.Range * self.Range
end

function ENT:CreateContainers()
    local CustomCheck = function(me, pl)
        return !pl:IsBuildBlocked()
    end

    local weapon = gRust.CreateInventory(1)
    weapon:SetEntity(self)
    weapon.CanAcceptItem = function(me, item)
        local register = item:GetRegister()
        if (!register) then return false end
        
        local class = register:GetWeapon()
        if (!class) then return false end
        
        local swep = weapons.GetStored(class)
        if (!swep) then return false end
        
        return true
    end
    weapon.OnUpdated = function(me)
        local item = me[1]
        if (IsValid(item)) then
            self:SetWeaponID(item:GetIndex())

            local register = item:GetRegister()
            local class = register:GetWeapon()
            local swep = weapons.Get(class)

            self.WeaponItem = item
            self.WeaponData = swep
        else
            self:SetWeaponID(0)

            self.WeaponItem = nil
            self.WeaponData = nil
        end
    end
    weapon.CustomCheck = CustomCheck

    local ammo = gRust.CreateInventory(6)
    ammo:SetEntity(self)
    ammo.CanAcceptItem = function(me, item)
        return item:GetRegister():IsInCategory("Ammo")
    end
    ammo.CustomCheck = CustomCheck
end

function ENT:Think()
    self:UpdateRotation()

    self.NextTargetCheck = self.NextTargetCheck or 0
    if (self.NextTargetCheck < CurTime()) then
        self:CheckForTargets()
        self.NextTargetCheck = CurTime() + 1
    end

    self.NextFire = self.NextFire or 0
    if (self.WeaponData and self.NextFire < CurTime()) then
        local target = self:GetTarget()
        if (IsValid(target)) then
            self:FireAt(target)
        end

        self.NextFire = CurTime() + (60 / self.WeaponData.RPM)
    end

    self:NextThink(CurTime())
    return true
end

function ENT:CheckForTargets()
    local target
    for _, pl in player.Iterator() do
        if (self:CanTargetPlayer(pl)) then
            target = pl
            break
        end
    end

    self:SetTarget(target)
end

function ENT:IsAuthorized(pl)
    return self.Authorized[pl:SteamID()] or (IsValid(self.ToolCupboard) and self.ToolCupboard:IsPlayerAuthorized(pl))
end

function ENT:CanTargetPlayer(pl)
    if (!pl:Alive()) then return false end
    if (pl:Health() <= 0) then return false end
    if (self:IsAuthorized(pl)) then return false end
    if (pl:GetPos():DistToSqr(self:GetPos()) > self.RangeSqr) then return false end
    if (self:GetPeacekeeper() and !pl:IsCombatBlocked()) then return false end
    if (pl:GetMoveType() == MOVETYPE_NOCLIP) then return false end
    
    local tr = {}
    tr.start = self:GetMuzzlePos()
    tr.endpos = pl:EyePos()
    tr.filter = {self, pl}
    tr = util.TraceLine(tr)
    
    if (tr.Hit and tr.Entity != pl) then return false end

    local forward = (self.Rotation + self:GetAngles()):Forward()
    local dir = (pl:GetPos() - self:GetPos()):GetNormalized()
    local dot = forward:Dot(dir)
    
    return dot > 0.5
end

function ENT:FireAt(target)
    local item = self.WeaponItem
    if (IsValid(item)) then
        if ((item:GetClip() or 0) <= 0) then
            self:Reload()
            return
        end
    end

    local dir = (self.Rotation + self:GetAngles()):Forward()

    local bullet = {}
    bullet.Num = 1
    bullet.Src = self:GetMuzzlePos()
    bullet.Dir = dir
    bullet.Spread = Vector(0.025, 0.025, 0)
    bullet.Tracer = 3
    bullet.TracerName = "Tracer"
    bullet.Force = 1
    bullet.Damage = self.WeaponData.Damage * 0.85
    bullet.AmmoType = "Pistol"
    bullet.Callback = function(attacker, tr, dmginfo)
        if (tr.Entity:IsPlayer()) then
            tr.Entity:TakeDamageInfo(dmginfo)
        end
    end

    self:EmitSound(self.WeaponData.ShootSound)
    self:FireBullets(bullet)

    if (IsValid(item)) then
        item:SetClip(item:GetClip() - 1)
        self.Containers[1]:SyncSlot(1)
    end

    self:DoEffects()
end

util.AddNetworkString("gRust.AutoTurret.ShootEffects")
function ENT:DoEffects()
    local rf = RecipientFilter()
    local entities = ents.FindInPVS(self:GetPos())
    for k, v in ipairs(entities) do
        if (v:IsPlayer()) then
            rf:AddPlayer(v)
        end
    end

    net.Start("gRust.AutoTurret.ShootEffects")
        net.WriteEntity(self)
    net.Send(rf)
end

function ENT:Reload()
    local item = self.WeaponItem
    if (!IsValid(item)) then return end
    
    local ammoContainer = self.Containers[2]
    if (!ammoContainer) then return end

    local ammoTypes = {}
    for k, v in ipairs(self.WeaponData.AmmoTypes) do
        ammoTypes[v.Item] = true
    end

    local ammoType
    for i = 1, ammoContainer:GetSize() do
        local v = ammoContainer[i]
        if (IsValid(v) and ammoTypes[ammoType or v:GetId()]) then
            local ammo = v:GetRegister()

            local clip = item:GetClip() or 0
            local take = math.min(v:GetQuantity(), self.WeaponData.ClipSize - clip)
            item:SetClip(clip + take)
            ammoContainer:Remove(i, take)
            ammoContainer:SyncSlot(i)

            ammoType = ammo:GetId()

            if (item:GetClip() >= self.WeaponData.ClipSize) then
                break
            end
        end
    end

    self.Containers[1]:SyncSlot(1)
end

function ENT:OnTakeDamage(dmg)
    BaseClass.OnTakeDamage(self, dmg)

    local attacker = dmg:GetAttacker()
    if (attacker:IsPlayer()) then
        local dist = attacker:GetPos():DistToSqr(self:GetPos())
        if (dist <= self.RangeSqr and !self:IsAuthorized(attacker)) then
            self:SetTarget(attacker)
        end
    end
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)

    buffer:WriteShort(self:GetWeaponID() or 0)

    buffer:WriteShort(table.Count(self.Authorized))
    for k, v in pairs(self.Authorized) do
        buffer:WriteString(k)
    end
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)

    self:SetWeaponID(buffer:ReadShort())
    
    local count = buffer:ReadShort()
    for i = 1, count do
        self.Authorized[buffer:ReadString()] = true
    end

    timer.Simple(1, function()
        if (self.Containers) then
            self.Containers[1]:OnUpdated()
        end
    end)
end

util.AddNetworkString("gRust.AutoTurret.Peacekeeper")
net.Receive("gRust.AutoTurret.Peacekeeper", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) or ent:GetClass() != "rust_turret") then return end
    if (!ent:IsAuthorized(pl)) then return end

    ent:SetPeacekeeper(!ent:GetPeacekeeper())
end)