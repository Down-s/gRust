AttireType = {
    Full = 0,
    Head = 1,
    Chest = 2,
    Legs = 3,
    Hands = 4,
    Feet = 5,
    Mask = 6,
    Eyes = 7,
}

local ATTIRE = {
    Position = Vector(0, 0, 0),
    Angles = Angle(0, 0, 0),
}
ATTIRE.__index = ATTIRE

gRust.AccessorFunc(ATTIRE, "Type", "Type", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "Model", "Model", FORCE_STRING)
gRust.AccessorFunc(ATTIRE, "Position", "Position")
gRust.AccessorFunc(ATTIRE, "Angles", "Angles")
gRust.AccessorFunc(ATTIRE, "Bone", "Bone", FORCE_STRING)
gRust.AccessorFunc(ATTIRE, "ProjectileResistance", "ProjectileResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "MeleeResistance", "MeleeResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "BiteResistance", "BiteResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "RadiationResistance", "RadiationResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "ColdResistance", "ColdResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "ExplosiveResistance", "ExplosiveResistance", FORCE_NUMBER)
gRust.AccessorFunc(ATTIRE, "Waterproof", "Waterproof", FORCE_BOOL)

function ATTIRE:PlayerEquip(pl, item)
    if (pl.EquippedAttire and pl.EquippedAttire[self.Type]) then return end
    pl.EquippedAttire = pl.EquippedAttire or {}
    pl.EquippedAttire[self.Type] = true

    if (self.Type == AttireType.Full) then
        pl:SetModel(self.Model)
    else
        net.Start("gRust.Attire.Add")
            net.WritePlayer(pl)
            net.WriteUInt(item:GetRegister():GetIndex(), gRust.ItemIndexBits)
        net.Broadcast()
    end
end

function ATTIRE:PlayerUnequip(pl)
    if (!pl.EquippedAttire or !pl.EquippedAttire[self.Type]) then return end
    pl.EquippedAttire[self.Type] = nil
    
    if (self.Type == AttireType.Full) then
        pl:SetModel(pl:GetDefaultPlayerModel())
    end
end

function ATTIRE:AddToEntity(ent)
    if (!IsValid(ent)) then return end

    local bone
    if (self.Bone) then
        bone = ent:LookupAttachment(self.Bone)
    end

    local mdl = ClientsideModel(self.Model, RENDERGROUP_OPAQUE)
    mdl:SetMoveType(MOVETYPE_NONE)
    if (bone) then
        local attachment = ent:GetAttachment(bone)
        if (attachment) then
            mdl:SetPos(attachment.Pos)
            -- mdl:SetAngles(attachment.Ang)
        end
    end
    mdl:SetParent(ent, bone)
    mdl:Spawn()
    mdl:SetLocalPos(self.Position)
    mdl:SetLocalAngles(self.Angles)

    hook.Add("Think", mdl, function()
        if ((mdl.NextCheck or 0) < CurTime()) then
            mdl.NextCheck = CurTime() + 1
            if (!IsValid(ent)) then
                mdl:Remove()
            end

            mdl:SetParent(ent, bone)
            mdl:SetLocalPos(self.Position)
            mdl:SetLocalAngles(self.Angles)
        end
    end)

    -- mdl:SetNoDraw(true)
    -- mdl:AddEffects(EF_BONEMERGE)
    -- mdl:SetupBones()

    return mdl
end

function ATTIRE:AddToPlayer(pl)
    if (SERVER) then
        gRust.LogError("Attempted to add attire to player on server!")
        return
    end

    if (pl != LocalPlayer()) then
        local mdl = self:AddToEntity(pl)
        pl.AttireEntities = pl.AttireEntities or {}
        pl.AttireEntities[self.Type] = mdl
    end

    hook.Run("PlayerAttireAdded", pl, self)
end

function gRust.CreateAttire(type)
    local meta = setmetatable({}, ATTIRE)
    meta.Type = type

    return meta
end

hook.Add("OnPlayerAttireUpdated", "gRust.RecalculateAttireProtection", function(pl)
    if (CLIENT and pl != LocalPlayer()) then return end
    pl:RecalculateAttireProtection()
end)

hook.Add("OnPlayerAttireAttached", "gRust.AddAttireToPlayer", function(pl)
    if (CLIENT and pl != LocalPlayer()) then return end
    pl:RecalculateAttireProtection()
end)

local PLAYER = FindMetaTable("Player")
function PLAYER:RecalculateAttireProtection()
    local projectile = 0
    local melee = 0
    local bite = 0
    local radiation = 0
    local cold = 0
    local explosive = 0
    local waterproof = false
    
    local attire = self.Attire
    for i = 1, attire:GetSlots() do
        local item = attire[i]
        if (!item) then continue end

        local register = item:GetRegister()
        local attire = register:GetAttire()

        projectile = projectile + (attire.ProjectileResistance or 0)
        melee = melee + (attire.MeleeResistance or 0)
        bite = bite + (attire.BiteResistance or 0)
        radiation = radiation + (attire.RadiationResistance or 0)
        cold = cold + (attire.ColdResistance or 0)
        explosive = explosive + (attire.ExplosiveResistance or 0)
        waterproof = waterproof or (attire.Waterproof or 0)
    end

    self.AttireProtection = {
        Projectile = projectile,
        Melee = melee,
        Bite = bite,
        Radiation = radiation,
        Cold = cold,
        Explosive = explosive,
        Waterproof = waterproof,
    }
end

local DamageTypes = {
    [DMG_BULLET] = "Projectile",
    [DMG_SLASH] = "Melee",
    [DMG_CLUB] = "Melee",
    [DMG_BURN] = "Bite",
    [DMG_RADIATION] = "Radiation",
    --[DMG_FREEZE] = "Cold",
    [DMG_BLAST] = "Explosive",
    [DMG_SHOCK] = "Explosive",
    [DMG_DROWN] = "Waterproof",
}

hook.Add("ScalePlayerDamage", "gRust.ScaleAttireDamage", function(pl, hitgroup, dmg)
    if (!pl.AttireProtection) then return end

    local damageType = dmg:GetDamageType()
    local protection = pl.AttireProtection
    
    local type = DamageTypes[damageType]
    if (!type) then return end

    local resistance = protection[type]
    if (!resistance) then return end

    local scale = 1 - resistance
    dmg:ScaleDamage(scale)
end)

hook.Add("ScalePlayerRadiation", "gRust.AttireRadiationProtection", function(pl, amount)
    if (!pl.AttireProtection) then return end
    
    if (amount <= 10) then
        local protection = pl.AttireProtection.Radiation or 0
    
        local scale = 0.5 - protection
        return amount * scale
    else
        local protection = pl.AttireProtection.Radiation or 0
    
        local scale = 1.0 - protection
        return amount * scale
    end
end)