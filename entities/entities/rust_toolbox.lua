AddCSLuaFile()

ENT.Base = "rust_lootbox"

DEFINE_BASECLASS("rust_lootbox")

ENT.Slots = 12
ENT.SelectAmount = 1

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/toolbox", {
        {
            itemid = "scrap",
            amount = 5,
            chance = 1.0,
        },
        {
            itemid = "hatchet",
            amount = 1,
            chance = 0.08,
        },
        {
            itemid = "pickaxe",
            amount = 1,
            chance = 0.08,
        },
        {
            itemid = "wooden_arrow",
            amount = 5,
            chance = 0.07,
        },
        {
            itemid = "salvaged_cleaver",
            amount = 1,
            chance = 0.05,
        },
        {
            itemid = "hunting_bow",
            amount = 1,
            chance = 0.05,
        },
        {
            itemid = "salvaged_sword",
            amount = 1,
            chance = 0.05,
        },
        {
            itemid = "targeting_computer",
            amount = 1,
            chance = 0.03,
        },
        {
            itemid = "cctv_camera",
            amount = 1,
            chance = 0.03,
        },
        {
            itemid = "crossbow",
            amount = 1,
            chance = 0.03,
        },
        {
            itemid = "combat_knife",
            amount = 1,
            chance = 0.02,
        },
        {
            itemid = "pistol_bullet",
            amount = 15,
            chance = 0.02,
        },
        {
            itemid = "low_grade_fuel",
            amount = { 20, 39 },
            chance = 0.01,
        },
        {
            itemid = "556_rifle_ammo",
            amount = 12,
            chance = 0.01,
        },
        {
            itemid = "incendiary_pistol_bullet",
            amount = 10,
            chance = 0.01,
        },
        {
            itemid = "hv_pistol_ammo",
            amount = 10,
            chance = 0.003,
        },
        {
            itemid = "incendiary_556_rifle_ammo",
            amount = 8,
            chance = 0.003,
        },
        {
            itemid = "explosive_556_rifle_ammo",
            amount = 8,
            chance = 0.001,
        },
        {
            itemid = "hv_556_rifle_ammo",
            amount = 10,
            chance = 0.001,
        }
    })

    gRust.CreateConfigValue("environment/toolbox.respawn_time", 300)
    gRust.CreateConfigValue("environment/toolbox.respawn_chance", 0.5)

    ENT.Model = "models/environment/crates/toolbox.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/toolbox")
    ENT.RespawnTime = gRust.GetConfigValue("environment/toolbox.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/toolbox.respawn_chance")
end

function ENT:OnStartLooting(pl)
    gRust.PlaySound("toolbox.open")
    BaseClass.OnStartLooting(self, pl)
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("toolbox.close")
    BaseClass.OnStopLooting(self, pl)
end