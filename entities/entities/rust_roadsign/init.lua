AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

gRust.CreateConfigValue("environment/roadsign.respawn_time", 300)
gRust.CreateConfigValue("environment/roadsign.respawn_chance", 0.75)

ENT.RespawnTime = gRust.GetConfigValue("environment/roadsign.respawn_time")
ENT.RespawnChance = gRust.GetConfigValue("environment/roadsign.respawn_chance")

ENT.Models = {
    "models/environment/roadsigns/roadsign_a.mdl",
    "models/environment/roadsigns/roadsign_b.mdl",
    "models/environment/roadsigns/roadsign_c.mdl",
    "models/environment/roadsigns/roadsign_d.mdl",
    "models/environment/roadsigns/roadsign_e.mdl",
    "models/environment/roadsigns/roadsign_f.mdl",
    "models/environment/roadsigns/roadsign_g.mdl",
}

ENT.Loot = {
    {
        Item = "road_signs",
        Amount = 1,
        Pos = Vector(0, 0, 96),
        Ang = Angle(0, 0, 0),
    },
    {
        Item = "metal_pipe",
        Amount = 1,
        Pos = Vector(0, 0, 48),
        Ang = Angle(0, 0, 0),
    }
}

function ENT:Initialize()
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    local mdl = self.Models[math.random(1, #self.Models)]
    self:SetModel(mdl)

    self:SetHP(self.MaxHP)
    self:SetMaxHP(self.MaxHP)
end

function ENT:OnKilled(dmg)
    for i = 1, #self.Loot do
        local loot = self.Loot[i]

        local item = gRust.CreateItem(loot.Item, loot.Amount)
        local pos = self:LocalToWorld(loot.Pos)
        local ang = self:LocalToWorldAngles(loot.Ang)
        local bag = gRust.CreateItemBag(item, pos, ang)
    end

    BaseClass.OnKilled(self, dmg)
end