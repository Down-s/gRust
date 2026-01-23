AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = 1

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/crate.primitive", {
        {
            itemid = "scrap",
            amount = { 3, 3 },
            chance = 1.0,
        },
        {
            itemid = "mailbox",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "paddle",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "salvaged_shelves",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "shorts",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "improvised_balaclava",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "table",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "wooden_barricade_cover",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "beanie_hat",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "large_planter_box",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "stone_fireplace",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "baseball_cap",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "water_bucket",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "huge_wooden_sign",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "wooden_barricade",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "bandana_mask",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "tank_top",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "spinning_wheel",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "binoculars",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "water_barrel",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "wood_shutters",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "stone_barricade",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "igniter",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "wooden_floor_spikes",
            amount = { 1, 2 },
            chance = 0.05,
        },
        {
            itemid = "rug_bear_skin",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "tuna_can_lamp",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "large_wooden_sign",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "boonie_hat",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "leather_gloves",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "rug",
            amount = 100,
            chance = 0.05,
        },
        {
            itemid = "acoustic_guitar",
            amount = 100,
            chance = 0.05,
        },
    })

    gRust.CreateConfigValue("environment/crate.primitive.respawn_time", 300)
    gRust.CreateConfigValue("environment/crate.primitive.respawn_chance", 0.5)

    ENT.Model = "models/environment/crates/primitive_toolbox.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/crate.primitive")
    ENT.RespawnTime = gRust.GetConfigValue("environment/crate.primitive.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/crate.primitive.respawn_chance")
end