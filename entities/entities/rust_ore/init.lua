AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

gRust.CreateConfigValue("farming/harvest.ore", 1)

local OreTypes = {
    {
        Item = "stones",
        Skin = 0,
    },
    {
        Item = "metal_ore",
        Skin = 1,
        Rare = "hq_metal_ore",
    },
    {
        Item = "sulfur_ore",
        Skin = 2,
    }
}

util.PrecacheModel("models/environment/ores/ore_node_stage1.mdl")
util.PrecacheModel("models/environment/ores/ore_node_stage2.mdl")
util.PrecacheModel("models/environment/ores/ore_node_stage3.mdl")
util.PrecacheModel("models/environment/ores/ore_node_stage4.mdl")

function ENT:Initialize()
    self:SetStage(1)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetPos(self:GetPos() - self:GetUp() * 10)
    self:SetHealth(100)

    if (!self.OreType) then
        self:SetOreType(math.random(1, #OreTypes))
    end

    self:PlaceWeakSpot()
end

function ENT:SetStage(i)
    self:SetModel("models/environment/ores/ore_node_stage" .. i .. ".mdl")
    self.Stage = i
end

function ENT:SetOreType(oretype)
    local data = OreTypes[oretype]
    self:SetSkin(data.Skin)
    self.OreType = oretype
end

function ENT:GetOreType()
    return self.OreType or 1
end

function ENT:GetStage()
    return self.Stage
end

local MAX_WEAKSPOT_STRIDE = 35
function ENT:PlaceWeakSpot()
    local radius = 128
    local theta0 = math.Clamp((self.lastTheta0 or 90) + math.random(-MAX_WEAKSPOT_STRIDE, MAX_WEAKSPOT_STRIDE), 40, 140) -- Vertical
    local theta1 = math.Clamp((self.lastTheta1 or 45) + math.random(-MAX_WEAKSPOT_STRIDE, MAX_WEAKSPOT_STRIDE), 0, 360) -- Horizontal

    self.lastTheta0 = theta0
    self.lastTheta1 = theta1

    theta0 = math.rad(theta0)
    theta1 = math.rad(theta1)
    local point = Vector(math.cos(theta0) * math.cos(theta1), math.cos(theta0) * math.sin(theta1), math.sin(theta0))
    point = point * radius

    local tr = {}
    tr.start = self:GetPos() + point
    tr.endpos = self:GetPos()
    tr.collisiongroup = COLLISION_GROUP_WORLD
    tr.filter = function(ent)
        return ent == self
    end
    --debugoverlay.Line(tr.start, tr.endpos, 5, Color(255, 0, 0), true)
    tr = util.TraceLine(tr)
    --debugoverlay.Sphere(tr.HitPos, 5, 5, Color(255, 0, 0), true)

    self:SetWeakSpot(tr.HitPos + tr.HitNormal)
    self.FlareNormal = tr.HitNormal
end

PrecacheParticleSystem("ManhackSparks")
function ENT:OnTakeDamage(dmg)
    local pl = dmg:GetAttacker()
    if (!IsValid(pl) or !pl:IsPlayer()) then return end
    local weapon = pl:GetActiveWeapon()
    if (!IsValid(weapon) or dmg:GetInflictor() ~= weapon) then return end
    if (!weapon.OreGather or weapon.OreGather <= 0) then return end

    local HarvestAmount = weapon.OreGather
    dmg:SetDamage(weapon.OreGather)
    local damage = math.sqrt(weapon.OreGather) * 3.5
    
    local oldStage = self:GetStage()
    if (self:Health() - damage <= 0) then
       HarvestAmount = HarvestAmount * 3
    elseif (self:Health() - damage <= 25) then
        self:SetStage(4)
        HarvestAmount = HarvestAmount * 2
    elseif (self:Health() - damage <= 50) then
        self:SetStage(3)
        HarvestAmount = HarvestAmount * 1.5
    elseif (self:Health() - damage <= 75) then
        self:SetStage(2)
        HarvestAmount = HarvestAmount * 1.25
    end

    local FlarePos = self:GetWeakSpot()
    if (FlarePos ~= nil) then
        if (dmg:GetDamagePosition():DistToSqr(FlarePos) < 250) then
            self.BonusLevel = self.BonusLevel and (self.BonusLevel + 1) or 1
            HarvestAmount = HarvestAmount * (1 + math.Clamp((self.BonusLevel or 0) * 0.125, 0, 1))
            dmg:ScaleDamage(1 + math.Clamp(self.BonusLevel * 0.125, 0, 1))

            if (self:Health() - damage <= 0) then
                pl:EmitSound("flare.finish")
            else
                pl:EmitSound("flare.hit")
            end

            local effectdata = EffectData()
            effectdata:SetOrigin(FlarePos)
            effectdata:SetNormal(self.FlareNormal)
            effectdata:SetMagnitude(0.1)
            effectdata:SetScale(0.05)
            effectdata:SetRadius(0.1)
            util.Effect("ManhackSparks", effectdata, true, true)

            self:PlaceWeakSpot()
        else
            if (oldStage ~= self:GetStage()) then
                self:PlaceWeakSpot()
            end
        end
    end

    if (oldStage ~= self:GetStage()) then
        pl:EmitSound(string.format("farming/ore_break_%i.wav", math.random(1, 4)))
    end

    self:SetHealth(self:Health() - damage)

    HarvestAmount = HarvestAmount * gRust.GetConfigValue("farming/harvest.ore", 1)

    local oreType = OreTypes[self:GetOreType()]
    local item = gRust.CreateItem(oreType.Item, HarvestAmount)
    pl:AddItem(item, ITEM_HARVEST)

    if (self:Health() <= 0) then
        if (oreType.Rare) then
            local item = gRust.CreateItem(oreType.Rare, 2)
            pl:AddItem(item, ITEM_HARVEST)
        end

        hook.Run("gRust.OreHarvested", pl, self)

        self:Remove()
    end
end