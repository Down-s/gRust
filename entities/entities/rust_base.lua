AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = ""
ENT.Author = "Down"

ENT.gRust = true
ENT.Damageable = true

ENT.BulletDamageScale = 0.1
ENT.MeleeDamageScale = 0.1
ENT.ExplosiveDamageScale = 0.1

AccessorFunc(ENT, "m_Respawn", "Respawn", FORCE_BOOL)

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "HP")
    self:NetworkVar("Bool", 0, "Interactable")
    self:NetworkVar("String", 0, "InteractText")
    self:NetworkVar("String", 1, "InteractIcon")
end

function ENT:SetMaxHP(hp)
    if (CLIENT) then return end
    self:SetMaxHealth(hp)
end

function ENT:GetMaxHP()
    return self:GetMaxHealth()
end

function ENT:CreateExtraOptions()
    if (self.LockBodygroup) then
        local PieMenu = gRust.CreatePieMenu()

        PieMenu:CreateOption()
            :SetTitle("Unlock")
            :SetDescription("Unlock this lock")
            :SetIcon("unlock")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return  self:GetBodygroup(self.LockBodygroup) != 0 and
                        self:GetSkin() == 1
            end)
            :SetCallback(function()
                net.Start("gRust.ToggleLock")
                    net.WriteEntity(self)
                net.SendToServer()
            end)
    
        PieMenu:CreateOption()
            :SetTitle("Lock")
            :SetDescription("Lock this lock")
            :SetIcon("lock")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return  self:GetBodygroup(self.LockBodygroup) != 0 and
                        self:GetSkin() == 0
            end)
            :SetCallback(function()
                net.Start("gRust.ToggleLock")
                    net.WriteEntity(self)
                net.SendToServer()
            end)
    
        PieMenu:CreateOption()
            :SetTitle("Remove Lock")
            :SetDescription("Remove this lock and place it in your inventory")
            :SetIcon("give")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return  self:GetBodygroup(self.LockBodygroup) != 0 and
                        self:GetSkin() == 0
            end)
            :SetCallback(function()
                net.Start("gRust.RemoveLock")
                    net.WriteEntity(self)
                net.SendToServer()
            end)
    
        PieMenu:CreateOption()
            :SetTitle("Create Key")
            :SetDescription("Craft a key for this lock to allow friends to enter")
            :SetFooter(function()
                return string.format("25 x Wood (%s)", string.Comma(LocalPlayer():ItemCount("wood")))
            end)
            :SetIcon("key")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return self:GetBodygroup(self.LockBodygroup) == 2
            end)
            :SetCallback(function()
            end)
    
        PieMenu:CreateOption()
            :SetTitle("Change Lock Code")
            :SetDescription("Change the code to something else")
            :SetIcon("changecode")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return self:GetBodygroup(self.LockBodygroup) == 1
            end)
            :SetCallback(function()
                gRust.InputQuery.Keypad("MASTER CODE", function(code)
                    net.Start("gRust.ChangeLockCode")
                        net.WriteEntity(self)
                        net.WriteUInt(tonumber(code), 14)
                    net.SendToServer()
                end)
            end)
    
        PieMenu:CreateOption()
            :SetTitle("Unlock With Code")
            :SetDescription("This lock has a pass code which you must neter to unlock it")
            :SetIcon("unlock")
            :SetCondition(true, function()
                if (!IsValid(self)) then return false end
                return  self:GetBodygroup(self.LockBodygroup) == 1
            end)
            :SetCallback(function()
                gRust.InputQuery.Keypad("ENTER CODE", function(code)
                    net.Start("gRust.EnterLockCode")
                        net.WriteEntity(self)
                        net.WriteUInt(tonumber(code), 14)
                    net.SendToServer()
                end)
            end)

        return PieMenu
    end
end

function ENT:Initialize()
    if (CLIENT) then
        self.ExtraOptions = self:CreateExtraOptions()
    else
        self:SetupSockets()

        if (self.MaxHP and !self:CreatedByMap()) then
            self:SetMaxHP(self.MaxHP)
            self:SetHP(self.MaxHP)
        end

        if (self.Model) then
            self:SetModel(self.Model)
            self:PhysicsInitStatic(SOLID_VPHYSICS)
            self:SetMoveType(MOVETYPE_NONE)
            self:SetSolid(SOLID_VPHYSICS)
        end
    end
end

function ENT:Interact()
end

if (SERVER) then
    gRust.CreateConfigValue("building/decay.enabled", true)
    gRust.CreateConfigValue("building/decay.scale", 1)

    local DECAY_ENABLED = gRust.GetConfigValue("building/decay.enabled")
    local DECAY_SCALE = gRust.GetConfigValue("building/decay.scale")
    
    function ENT:DoDecay(delta)
        if (!DECAY_ENABLED) then return end
        if (self:GetMaxHP() == 0) then return end
        
        local remove = (delta / self.Decay) * self:GetMaxHP() * DECAY_SCALE
        self:SetHP(self:GetHP() - remove)
    
        if (self:GetHP() <= 0) then
            self:Remove()
        end
    end
end

function ENT:CanPlayerAccess(pl)
    if (self:GetPos():DistToSqr(pl:GetPos()) > 20000) then return false end
    if (self:IsLocked() and !self:IsAuthorizedToLock(pl)) then return false end
    local tr = util.TraceLine({
        start = pl:EyePos(),
        endpos = self:LocalToWorld(self:OBBCenter()),
        filter = pl
    })

    if (IsValid(tr.Entity) and tr.Entity != self) then return false end

    return true
end

--
-- Health
--

function ENT:Health()
    return self:GetHP()
end

function ENT:Hurt(amount)
    local hp = self:GetHP()
    if (self:GetMaxHP() == 0) then return end

    local newHP = hp - amount
    if (newHP <= 0) then
        self:OnKilled()
    else
        self:SetHP(newHP)
    end
end

function ENT:OnTakeDamage(dmg)
    local hp = self:GetHP()
    if (self:GetMaxHP() == 0) then return end

    local attacker = dmg:GetAttacker()
    if (self.HitSound and IsValid(attacker) and attacker:IsPlayer()) then
        attacker:EmitSound("combat.hitmarker")
    end

    local scale = 1
    if (dmg:GetDamageType() == DMG_BULLET) then
        scale = self.BulletDamageScale
    elseif (dmg:GetDamageType() == DMG_BLAST) then
        scale = self.ExplosiveDamageScale
    else
        scale = self.MeleeDamageScale
    end

    local newHP = hp - (dmg:GetDamage() * scale)
    if (newHP <= 0) then
        self:OnKilled(dmg)
    else
        self:SetHP(newHP)
    end
end

function ENT:OnKilled(dmg)
    self:Remove()
end

--
-- Locks
--

ENT.LockBodygroups = {
    ["code_lock"] = 1,
    ["key_lock"] = 2,
}

function ENT:Lock()
    if (!self.LockData) then return end

    self:SetSkin(1)
end

function ENT:Unlock()
    if (!self.LockData) then return end

    self:SetSkin(0)
end

function ENT:IsLocked()
    if (!self.LockData) then return false end

    return self:GetSkin() == 1
end

function ENT:ToggleLock(pl)
    if (!self.LockData) then return end
    if (!self:IsAuthorizedToLock(pl)) then return end

    if (self:IsLocked()) then
        self:Unlock()

        if (self.LockData.Item == "key_lock") then
            self:EmitSound("keylock.unlock")
        elseif (self.LockData.Item == "code_lock") then
            self:EmitSound("codelock.unlock")
        end
    else
        self:Lock()

        if (self.LockData.Item == "key_lock") then
            self:EmitSound("keylock.lock")
        elseif (self.LockData.Item == "code_lock") then
            self:EmitSound("codelock.lock")
        end
    end
end

function ENT:AddLock(type)
    local bodygroup = self.LockBodygroups[type]

    self.LockData = {
        Authorized = {},
        Item = type,
    }

    self:SetBodygroup(self.LockBodygroup, bodygroup)
end

function ENT:RemoveLock()
    self.LockData = nil
    self:SetBodygroup(self.LockBodygroup, 0)
end

function ENT:AuthorizeToLock(pl)
    if (!self.LockData) then return end
    
    self.LockData.Authorized[pl:SteamID()] = true
end

function ENT:UnauthorizeToLock(pl)
    if (!self.LockData) then return end
    
    self.LockData.Authorized[pl:SteamID()] = nil
end

function ENT:IsAuthorizedToLock(pl)
    if (!self.LockData) then return true end

    return self.LockData.Authorized[pl:SteamID()] or false
end

--
-- Storage
--

function ENT:IsLootable()
    return false
end

function ENT:OnStartLooting(pl)
end

function ENT:OnStopLooting(pl)
end

function ENT:GetInventoryName()
    return "CONTAINER"
end

--
-- Socket system
--

function ENT:SetupSockets()
    local deploy = self.Deploy
    if (!deploy) then return end

    local sockets = deploy.Sockets
    if (!sockets) then return end

    for i = 1, #sockets do
        self:AddSocket(sockets[i])
    end
end

function ENT:AddSocket(socket)
    self.Sockets = self.Sockets or {}
    table.insert(self.Sockets, socket)
end

function ENT:GetClosestSocket(pos)
    local sockets = self.Sockets
    if (!sockets) then return end
    if (#sockets == 0) then return end
    if (#sockets == 1) then return sockets[1] end

    local closestSocket = nil
    local closestDist = math.huge

    for _, socket in ipairs(sockets) do
        local dist = self:LocalToWorld(socket:GetPosition()):DistToSqr(pos)
        if (dist < closestDist) then
            closestSocket = socket
            closestDist = dist
        end
    end

    return closestSocket
end

--
-- Respawn system
--

function ENT:CreateRespawn()
    if (CLIENT) then return end
    if (!self.RespawnTime) then return end

    local time = self.RespawnTime
    local chance = self.RespawnChance or 1
    local timerName = "gRust.Respawn." .. self:EntIndex() .. "." .. CurTime()

    local class = self:GetClass()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    local respawn = self:GetRespawn()

    timer.Create(timerName, time, 0, function()
        if (math.random() > chance) then return end

        local ent = ents.Create(class)
        ent:SetPos(pos)
        ent:SetAngles(ang)
        ent:SetRespawn(respawn)
        ent:Spawn()
        ent:Activate()
        
        timer.Remove(timerName)
    end)
end

--
-- Decay
--

if (SERVER) then
    local BUILD_RADIUS = gRust.GetConfigValue("building/tool_cupboard.radius") ^ 2
    
    local DECAY_THINK_DELAY = 15
    function ENT:DecayThink()
        self.NextDecayThink = self.NextDecayThink or CurTime() + DECAY_THINK_DELAY
        if (self.Decay and self.NextDecayThink <= CurTime()) then
            self.NextDecayThink = CurTime() + DECAY_THINK_DELAY
    
            local tc = self.ToolCupboard
            if (!IsValid(tc) or tc:GetPos():DistToSqr(self:GetPos()) > BUILD_RADIUS) then
                self:DoDecay(DECAY_THINK_DELAY)
            end
        end
    end

    function ENT:Think()
        self:DecayThink()
    end
end

--
-- Saving and Loading
--

function ENT:Save(f)
    f:WriteVector(self:GetPos())
    f:WriteAngle(self:GetAngles())

    if (self.MaxHP) then
        f:WriteFloat(self:GetHP())
    end

    if (self.LockData) then
        f:WriteBool(true)
        f:WriteString(self.LockData.Item)
        f:WriteBool(self:IsLocked())
        f:WriteUShort(table.Count(self.LockData.Authorized))
        for k, v in pairs(self.LockData.Authorized) do
            f:WriteString(k)
        end

        f:WriteBool(self.LockData.Code != nil)
        if (self.LockData.Code) then
            f:WriteShort(self.LockData.Code)
        end
    else
        f:WriteBool(false)
    end

    if (self.OwnerID) then
        f:WriteBool(true)
        f:WriteString(self.OwnerID)
    else
        f:WriteBool(false)
    end
end

function ENT:Load(f)
    self:SetPos(f:ReadVector())
    self:SetAngles(f:ReadAngle())

    if (self.MaxHP) then
        self:SetHP(f:ReadFloat())
    end
    
    if (f:ReadBool()) then
        self:AddLock(f:ReadString())
        if (f:ReadBool()) then
            self:Lock()
        else
            self:Unlock()
        end

        local count = f:ReadUShort()
        for i = 1, count do
            self.LockData.Authorized[f:ReadString()] = true
        end

        if (f:ReadBool()) then
            self.LockData.Code = f:ReadShort()
        end
    end

    if (f:ReadBool()) then
        self.OwnerID = f:ReadString()
    end
end

if (SERVER) then
    util.AddNetworkString("gRust.ToggleLock")
    net.Receive("gRust.ToggleLock", function(len, pl)
        if (!IsValid(pl)) then return end
        if (!pl:Alive()) then return end
        if ((pl.NextLockToggle or 0) > CurTime()) then return end
        pl.NextLockToggle = CurTime() + 0.5
        local ent = net.ReadEntity()
        if (!IsValid(ent)) then return end
        if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end
        if (!ent.gRust) then return end
        if (!ent:GetInteractable()) then return end
        if (pl:IsBuildBlocked()) then return end
        if (!ent:IsAuthorizedToLock(pl)) then return end
    
        ent:ToggleLock(pl)
    end)
    
    util.AddNetworkString("gRust.RemoveLock")
    net.Receive("gRust.RemoveLock", function(len, pl)
        if (!IsValid(pl)) then return end
        if (!pl:Alive()) then return end
        if ((pl.NextLockAction or 0) > CurTime()) then return end
        pl.NextLockAction = CurTime() + 0.1
        local ent = net.ReadEntity()
        if (!IsValid(ent)) then return end
        if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end
        if (!ent.gRust) then return end
        if (!ent:GetInteractable()) then return end
        if (pl:IsBuildBlocked()) then return end
    
        pl:AddItem(ent.LockItem)
        ent:RemoveLock()
    end)
    
    util.AddNetworkString("gRust.ChangeLockCode")
    net.Receive("gRust.ChangeLockCode", function(len, pl)
        if (!IsValid(pl)) then return end
        if (!pl:Alive()) then return end
        if ((pl.NextLockAction or 0) > CurTime()) then return end
        pl.NextLockAction = CurTime() + 0.1
        local ent = net.ReadEntity()
        if (!IsValid(ent)) then return end
        if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end
        if (!ent.gRust) then return end
        if (ent:GetBodygroup(ent.LockBodygroup) != 1) then return end
        if (!ent:GetInteractable()) then return end
        if (pl:IsBuildBlocked()) then return end
        if (!ent:IsAuthorizedToLock(pl)) then return end
    
        local code = net.ReadUInt(14)
        if (!code) then return end
    
        ent.LockData.Code = code
        pl:EmitSound("codelock.authorize")
        ent:Lock()
    end)
    
    util.AddNetworkString("gRust.EnterLockCode")
    net.Receive("gRust.EnterLockCode", function(len, pl)
        if (!IsValid(pl)) then return end
        if (!pl:Alive()) then return end
        if ((pl.NextLockAction or 0) > CurTime()) then return end
        pl.NextLockAction = CurTime() + 0.1
        local ent = net.ReadEntity()
        if (!IsValid(ent)) then return end
        if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end
        if (!ent.gRust) then return end
        if (ent:GetBodygroup(ent.LockBodygroup) != 1) then return end
        if (!ent:GetInteractable()) then return end
        if (ent:IsAuthorizedToLock(pl)) then return end
        
        local code = net.ReadUInt(14)
        if (!code) then return end
    
        if (ent.LockData.Code == code) then
            ent:AuthorizeToLock(pl)
            pl:EmitSound("codelock.authorize")
        else
            local dmg = DamageInfo()
            dmg:SetDamage(5)
            dmg:SetDamageType(DMG_SHOCK)
            dmg:SetAttacker(ent)
            dmg:SetInflictor(ent)
            pl:TakeDamageInfo(dmg)
    
            pl:ViewPunch(Angle(-3, 0, 0))
            pl:EmitSound("codelock.shock")
    
            local effectdata = EffectData()
            effectdata:SetOrigin(ent:LocalToWorld(ent:OBBCenter()))
            effectdata:SetMagnitude(1)
            effectdata:SetScale(1)
            effectdata:SetRadius(1)
            util.Effect("Sparks", effectdata)
        end
    end)
end