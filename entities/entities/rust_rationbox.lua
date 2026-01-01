AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = { 2, 3 }

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/rationbox", {
        {
            itemid = "chocolate_bar",
            amount = { 1, 2 },
            chance = 0.21,
        },
        {
            itemid = "can_of_tuna",
            amount = { 1, 2 },
            chance = 0.21,
        },
        {
            itemid = "apple",
            amount = { 1, 2 },
            chance = 0.21,
        },
        {
            itemid = "granola_bar",
            amount = { 1, 2 },
            chance = 0.21,
        },
        {
            itemid = "pickles",
            amount = { 1, 4 },
            chance = 0.13,
        },
    })

    gRust.CreateConfigValue("environment/rationbox.respawn_time", 300)
    gRust.CreateConfigValue("environment/rationbox.respawn_chance", 0.5)

    ENT.Model = "models/environment/crates/rationbox.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/rationbox")
    ENT.RespawnTime = gRust.GetConfigValue("environment/rationbox.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/rationbox.respawn_chance")
end