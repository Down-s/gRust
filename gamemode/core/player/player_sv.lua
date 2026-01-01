local WalkSpeed     = 140
local RunSpeed      = 240
local CrouchSpeed   = 50
local JumpPower     = 190

function GM:PlayerSpawn(pl)
    --
    -- Setup
    --

    pl:SetHealth(math.random(50, 60))
    pl:SetMaxHealth(100)
    pl:SetCalories(200)
    pl:SetHydration(200)
    pl:SetRadiation(0)
    pl:SetBleeding(0)
    pl:SetSpawnTime(CurTime())

    pl:SetWalkSpeed(WalkSpeed)
    pl:SetRunSpeed(RunSpeed)
    pl:SetJumpPower(JumpPower)

    pl:CrosshairDisable()
    pl:SetCanZoom(false)

    --
    -- Playermodel
    --

    pl:SetModel(pl:GetDefaultPlayerModel(model))

    local steamid64 = pl:SteamID64() or "76561111111111111"
    local r = ((tonumber(string.sub(steamid64, 5, 5)) * 255) / 9) / 255
	local g = ((tonumber(string.sub(steamid64, 14, 14)) * 255) / 9) / 255
	local b = ((tonumber(string.sub(steamid64, 16, 16)) * 255) / 9) / 255
	pl:SetPlayerColor(Vector(r, g, b))

    pl:SetupHands()

    if (pl:IsNetworkReady()) then
        pl:Give("rust_hands")

        local belt = gRust.CreateInventory(6)
        belt:AddReplicatedPlayer(pl)
        belt:SetEntity(pl)
        
        local inventory = gRust.CreateInventory(24)
        inventory:AddReplicatedPlayer(pl)
        inventory:SetEntity(pl)

        local attire = gRust.CreateInventory(7)
        attire:AddReplicatedPlayer(pl)
        attire:SetEntity(pl)

        pl:OnReady()

        GAMEMODE:PlayerLoadout(pl)
    end

    pl.LastInflictor = nil
    pl.LastAttacker = nil
end

hook.Add("InitPostEntity", "gRust.LoadPlayerSpawns", function()
    gRust.SpawnPoints = ents.FindByClass("info_player_start")
end)

function GM:PlayerSelectSpawn(pl, transition)
    gRust.NextSpawnPoint = (gRust.NextSpawnPoint or 0) + 1
    if (gRust.NextSpawnPoint > #gRust.SpawnPoints) then
        gRust.NextSpawnPoint = 1
    end

    return gRust.SpawnPoints[gRust.NextSpawnPoint]
end

function GM:PlayerInitialSpawn(pl)
    pl:RegisterSyncVar("Health", SyncVar.Float)
end

hook.Add("OnPlayerBeltUpdated", "gRust.PlayerBeltUpdated", function(pl)
    local belt = pl.Belt
    local ent = belt.Entity
    if (!IsValid(ent)) then return end

    local weps = {}
    for i = 1, belt:GetSize() do
        local item = belt[i]
        if (item and item:IsWeapon()) then
            local wepClass = item:GetRegister():GetWeapon()
            weps[wepClass] = true

            if (!ent:HasWeapon(wepClass)) then
                ent:Give(wepClass)
            end
        end
    end

    local weapons = ent:GetWeapons()
    for i = 2, #weapons do
        local v = weapons[i]
        if (!weps[v:GetClass()]) then
            ent:StripWeapon(v:GetClass())
        end
    end
end)

function GM:PlayerLoadout(pl)
    --
    -- Loadout
    --
    
    local Rock = gRust.CreateItem("rock")
    Rock:SetQuantity(1)
    pl.Belt:Set(1, Rock)
end

function GM:PlayerSetHandsModel(pl, ent)
    --[[local simpleModel = player_manager.TranslateToPlayerModelName(pl:GetModel())
    local info = player_manager.TranslatePlayerHands(simpleModel)
    if (info) then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end]]
    
    ent:SetModel("models/player/darky_m/rust/c_arms_human.mdl")
end

local USE_WHITELIST = {
    ["func_button"] = true,
}

function GM:PlayerUse(pl, ent)
    return USE_WHITELIST[ent:GetClass()] or false
end

function GM:GetFallDamage(pl, speed)
    return speed * 0.05
end

function GM:KeyPress(pl, key)
    if (key == IN_JUMP) then
        if (pl:InVehicle()) then
            local vehicle = pl:GetVehicle()
            local eyeAngles = pl:EyeAngles()
            eyeAngles.z = 0
            
            pl:ExitVehicle()

            pl:SetCollisionGroup(COLLISION_GROUP_PLAYER)
            pl:CollisionRulesChanged()

            pl:SetPos(vehicle:GetPos() + vehicle:GetUp() * 48)
            pl:SetEyeAngles(eyeAngles)
        end
    end
end

function GM:CanExitVehicle(vehicle, pl)
    return false
end

local function FillLootBag(deathBag, index, inventory)
    if (!deathBag.Containers) then return end
    local container = deathBag.Containers[index]

    for i = 1, inventory:GetSize() do
        container[i] = inventory[i]
    end
end

function GM:PlayerDeath(pl, inflictor, attacker)
    pl:SetBleeding(0)
    pl:SetHealing(0)

    local activeItem = pl.Belt[pl.SelectedSlot or 0]
    if (IsValid(activeItem)) then
        local register = activeItem:GetRegister()
        if (register:IsWeapon()) then
            local ent = gRust.CreateItemBag(activeItem, pl:EyePos(), pl:EyeAngles())
            local phys = ent:GetPhysicsObject()
            phys:SetVelocity(pl:EyeAngles():Forward() * 128)

            pl.Belt[pl.SelectedSlot] = nil
        end
    end

    if (!pl.Belt:IsEmpty() or !pl.Inventory:IsEmpty() or !pl.Attire:IsEmpty()) then
        local deathBag = ents.Create("rust_deathbag")
        deathBag:SetPos(pl:GetPos())
        deathBag:Spawn()
        deathBag:SetPlayerName(pl:Name())
    
        FillLootBag(deathBag, 1, pl.Inventory)
        FillLootBag(deathBag, 2, pl.Attire)
        FillLootBag(deathBag, 3, pl.Belt)
    end

    pl.Inventory:Clear()
    pl.Attire:Clear()
    pl.Belt:Clear()
    pl.Inventory:SetEntity(nil)
    pl.Attire:SetEntity(nil)
    pl.Belt:SetEntity(nil)
    pl.Inventory:ClearReplicatedPlayers()
    pl.Attire:ClearReplicatedPlayers()
    pl.Belt:ClearReplicatedPlayers()

    pl.LastDeath = CurTime()
end

function GM:PlayerDeathThink(pl)
    if (pl:IsBot()) then return end
    return (CurTime() - (pl.LastDeath or 0)) > 2.5
end

function GM:PlayerDisconnected(pl)
    if (pl:Alive() and (CurTime() - pl:GetSpawnTime()) > 300) then
        local sleepingPlayer = ents.Create("rust_sleepingplayer")
        sleepingPlayer:SetPos(pl:GetPos())
        sleepingPlayer.OwnerID = pl:SteamID()
        sleepingPlayer:Spawn()
        sleepingPlayer.PlayerHealth = pl:Health()
        sleepingPlayer.PlayerCalories = pl:GetCalories()
        sleepingPlayer.PlayerHydration = pl:GetHydration()
        sleepingPlayer.PlayerRadiation = pl:GetRadiation()
        sleepingPlayer.PlayerBleeding = pl:GetBleeding()
        sleepingPlayer.CombatBlockEnd = pl:GetCombatBlockEnd()

        FillLootBag(sleepingPlayer, 1, pl.Inventory)
        FillLootBag(sleepingPlayer, 2, pl.Attire)
        FillLootBag(sleepingPlayer, 3, pl.Belt)
    end
end

function GM:PlayerDeathSound(pl)
    return true
end

util.AddNetworkString("gRust.PlayerReady")
net.Receive("gRust.PlayerReady", function(len, pl)
    if (pl.NetworkReady) then return end
    hook.Run("gRust.RegisterSyncVars", pl)

    pl:Give("rust_hands")

    local belt = gRust.CreateInventory(6)
    belt:AddReplicatedPlayer(pl)
    belt:SetEntity(pl)
    
    local inventory = gRust.CreateInventory(24)
    inventory:AddReplicatedPlayer(pl)
    inventory:SetEntity(pl)

    local attire = gRust.CreateInventory(7)
    attire:AddReplicatedPlayer(pl)
    attire:SetEntity(pl)

    pl:OnReady()

    hook.Run("PrePlayerNetworkReady", pl)
    hook.Run("PlayerNetworkReady", pl)
    hook.Run("PostPlayerNetworkReady", pl)
    pl.NetworkReady = true

    local foundSleepingPlayer = false
    for k, v in ipairs(ents.FindByClass("rust_sleepingplayer")) do
        local owner = v.OwnerID
        if (owner == pl:SteamID()) then
            pl:SetPos(v:GetPos())

            for i = 1, v.Containers[1]:GetSlots() do
                pl.Inventory[i] = v.Containers[1][i]
            end

            for i = 1, v.Containers[2]:GetSlots() do
                pl.Attire[i] = v.Containers[2][i]
            end

            for i = 1, v.Containers[3]:GetSlots() do
                pl.Belt[i] = v.Containers[3][i]
            end

            pl:SetPos(v:GetPos())

            local health = v.PlayerHealth or 100
            local calories = v.PlayerCalories or 200
            local hydration = v.PlayerHydration or 200
            local radiation = v.PlayerRadiation or 0
            local bleeding = v.PlayerBleeding or 0
            local combatBlockEnd = v.CombatBlockEnd or 0

            v:Remove()

            pl:SetHealth(health)
            pl:SetCalories(calories)
            pl:SetHydration(hydration)
            pl:SetRadiation(radiation)
            pl:SetBleeding(bleeding)
            pl:SetCombatBlockEnd(combatBlockEnd)

            pl.Inventory:SyncAll()
            pl.Attire:SyncAll()
            pl.Belt:SyncAll()

            foundSleepingPlayer = true
        end
    end

    if (!foundSleepingPlayer) then
        GAMEMODE:PlayerLoadout(pl)
    end
end)

-- Meta functions

local PLAYER = FindMetaTable("Player")

--
-- Playermodel
--

local PlayerModels = {
	[0] = "models/player/Group01/male_04.mdl",
	[1] = "models/player/Group01/female_01.mdl",
	[2] = "models/player/Group01/female_05.mdl",
	[3] = "models/player/Group01/female_04.mdl",
	[4] = "models/player/Group01/female_03.mdl",
	[5] = "models/player/Group01/male_03.mdl",
	[6] = "models/player/Group01/male_07.mdl",
	[7] = "models/player/Group01/male_06.mdl",
	[8] = "models/player/Group01/male_01.mdl",
	[9] = "models/player/Group01/male_02.mdl"
}

function PLAYER:GetDefaultPlayerModel()
    local model = PlayerModels[tonumber(string.sub(self:SteamID64(), 17))]
    if (!model) then
        model = PlayerModels[math.random(#PlayerModels)]
    end

    return model
end

--
-- Health system
--

function PLAYER:SetHealth(amount)
    self:SetSyncVar("Health", amount)
end

function PLAYER:AddHealth(amount)
    self:SetHealth(math.Clamp(self:Health() + amount, 0, self:GetMaxHealth()))

    if (self:Alive() and self:Health() <= 0) then
        self:Kill()
    end
end

function PLAYER:Heal(amount)
    self:SetHealth(math.min(self:Health() + amount, self:GetMaxHealth()))
end

function PLAYER:Hurt(amount)
    if (!self:Alive()) then return end
    self:AddHealth(-amount)
end

function GM:PlayerShouldTakeDamage(pl, attacker)
    return false
end

function GM:EntityTakeDamage(ent, dmg)
    if (ent:IsPlayer()) then
        if (ent:HasGodMode()) then return end
        if (ent:IsInSafeZone() and !ent:IsCombatBlocked()) then return end
        if (dmg:GetDamageType() == DMG_CRUSH) then return end

        ent.LastAttacker = dmg:GetAttacker()
        ent.LastInflictor = dmg:GetInflictor()
        ent:Hurt(dmg:GetDamage())
    end
end

local HITGROUP_SCALES = {
    [HITGROUP_HEAD] = 1.25,
    [HITGROUP_CHEST] = 0.75,
    [HITGROUP_STOMACH] = 0.65,
    [HITGROUP_GEAR] = 0.85,
    [HITGROUP_LEFTARM] = 0.60,
    [HITGROUP_RIGHTARM] = 0.60,
    [HITGROUP_LEFTLEG] = 0.60,
    [HITGROUP_RIGHTLEG] = 0.60,
    [HITGROUP_GENERIC] = 0.8,
}

function GM:ScalePlayerDamage(pl, hitGroup, dmg)
    if (hitGroup == HITGROUP_HEAD) then
        dmg:GetAttacker():EmitSound("combat/headshot.wav")
    else
        dmg:GetAttacker():EmitSound("combat.hitmarker")
    end

    dmg:ScaleDamage(HITGROUP_SCALES[hitGroup] or 1)
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if (listener:GetPos():DistToSqr(talker:GetPos()) <= 250000) then
        return true, true
    end
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
    if (teamOnly) then
        return listener.TeamID == speaker.TeamID
    end

    return true
end

function GM:PlayerShouldTaunt(pl, act)
    return false
end

--
-- Misc
--

function PLAYER:SetSpawnTime(time)
    self.SpawnTime = time
end

function PLAYER:GetSpawnTime()
    return self.SpawnTime or 0
end

--
-- Inventory
--

ITEM_GENERIC = 0
ITEM_HARVEST = 1
ITEM_PICKUP = 2
ITEM_CRAFT = 3

util.AddNetworkString("gRust.AddItemNotify")
function PLAYER:AddItem(item, reason)
    if (isstring(item)) then
        item = gRust.CreateItem(item)
    end

    -- TODO: Clean up this mess
    
    reason = reason or ITEM_GENERIC
    local baseItem = item:Copy()

    local rem
    local register = item:GetRegister()
    if (register:IsWeapon() or register:IsDeployable()) then
        rem = self.Inventory:InsertItem(item, true)
        
        if (rem) then
            rem = self.Belt:InsertItem(rem)
            if (rem) then
                rem = self.Inventory:InsertItem(rem)
            end
        end
    else
        rem = self.Belt:InsertItem(item, true)
        if (rem) then
            rem = self.Inventory:InsertItem(rem)
            if (rem) then
                rem = self.Belt:InsertItem(rem)
            end
        end
    end

    if (rem) then
        local pos = self:EyePos() + self:GetAimVector() * 32
        local ang = self:EyeAngles()

        local ent = gRust.CreateItemBag(rem, pos, ang)
        timer.Simple(0, function()
            local phys = ent:GetPhysicsObject()
            if (IsValid(phys)) then
                phys:SetVelocity(self:GetAimVector() * 100)
            end
        end)
    end

    if (reason ~= ITEM_GENERIC) then
        net.Start("gRust.AddItemNotify")
            net.WriteItem(baseItem)
        net.Send(self)
    end
end

util.AddNetworkString("gRust.RemoveItemNotify")
function PLAYER:RemoveItem(item, quantity, reason)
    local beltAmount = self.Belt:ItemCount(item)
    if (beltAmount > 0) then
        self.Belt:RemoveItem(item, quantity)
        quantity = quantity - beltAmount
    end
    
    if (quantity > 0 and self.Inventory:ItemCount(item) > 0) then
        self.Inventory:RemoveItem(item, quantity)
    end

    if (quantity > 0 and self.Attire:ItemCount(item) > 0) then
        self.Attire:RemoveItem(item, quantity)
    end

    if (reason ~= ITEM_GENERIC) then
        local register = gRust.GetItemRegister(item)
        net.Start("gRust.RemoveItemNotify")
            net.WriteUInt(register:GetIndex(), gRust.ItemIndexBits)
            net.WriteUInt(quantity, register.StackBits)
        net.Send(self)
    end
end

-- Slightly more efficient than storing the color tags in the message string
util.AddNetworkString("gRust.ChatMessage")
function PLAYER:ChatMessage(...)
    local args = {...}

    net.Start("gRust.ChatMessage")
        net.WriteUInt(#args, 4)
        for i = 1, #args do
            net.WriteType(args[i])
        end
    net.Send(self)
end

function gRust.BroadcastChatMessage(...)
    local args = {...}

    net.Start("gRust.ChatMessage")
        net.WriteUInt(#args, 4)
        for i = 1, #args do
            net.WriteType(args[i])
        end
    net.Broadcast()
end

util.AddNetworkString("gRust.PushEntity")
net.Receive("gRust.PushEntity", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (!ent.gRust) then return end
    if (!ent.Pushable) then return end
    if (ent:GetPos():DistToSqr(pl:GetPos()) > 32768) then return end
    if (pl.LastPush and CurTime() - pl.LastPush < 0.5) then return end

    pl.LastPush = CurTime()

    local tr = util.TraceLine({
        start = pl:EyePos(),
        endpos = pl:EyePos() + pl:GetAimVector() * 256,
        filter = pl
    })

    if (!tr.Hit or tr.Entity ~= ent) then return end

    local phys = ent:GetPhysicsObject()
    if (!IsValid(phys)) then return end

    phys:ApplyForceOffset(-tr.HitNormal * phys:GetMass() * 100, tr.HitPos)
end)