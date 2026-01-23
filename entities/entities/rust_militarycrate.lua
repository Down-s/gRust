AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = 2

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/crate.military", {
        {
            itemid = "scrap",
            amount = { 8, 8 },
            chance = 1,
        },
        {
            itemid = "smg_body",
            amount = 100,
            chance = 0.17,
        },
        {
            itemid = "tech_trash",
            amount = { 100, 100 },
            chance = 0.17,
        },
        {
            itemid = "metal_pipe",
            amount = 100,
            chance = 0.17,
        },
        {
            itemid = "high_quality_metal",
            amount = { 100, 100 },
            chance = 0.17,
        },
        {
            itemid = "rifle_body",
            amount = 100,
            chance = 0.16,
        },
        {
            itemid = "targeting_computer",
            amount = 100,
            chance = 0.09,
        },
        {
            itemid = "cctv_camera",
            amount = 100,
            chance = 0.07,
        },
        {
            itemid = "supply_signal",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "large_medkit",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "holosight",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "locker",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "storage_monitor",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "hazmat_suit",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "boots",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "muzzle_boost",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "heavy_plate_helmet",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "modular_car_lift",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "prison_cell_gate",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "industrial_crafter",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "semi_auto_pistol",
            amount = { 10, 20 },
            chance = 0.01,
        },
        {
            itemid = "smart_switch",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "small_oil_refinery",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "large_rechargeable_battery",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "electric_furnace",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "roadsign_gloves",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "rf_receiver",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "metal_barricade",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "rand_switch",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "metal_vertical_embrasure",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "strengthened_glass_window",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "water_pump",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "metal_horizontal_embrasure",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "night_vision_goggles",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "laser_detector",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "rocket_launcher",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "longsword",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "and_switch",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "smoke_grenade",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "search_light",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "high_quality_horse_shoes",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "garage_door",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "flashbang",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "road_sign_jacket",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "extended_magazine",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "f1_grenade",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "heavy_plate_jacket",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "semi_auto_rifle",
            amount = { 10, 20 },
            chance = 0.01,
        },
        {
            itemid = "wind_turbine",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "auto_turret",
            amount = 100,
            chance = 0.01,
        },
        {
            itemid = "muzzle_brake",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "rf_transmitter",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "small_generator",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "counter",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "roadsign_horse_armor",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "high_external_stone_gate",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "salvaged_axe",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "chainsaw",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "hbhf_sensor",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "drone",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "custom_smg",
            amount = { 10, 20 },
            chance = 0.005,
        },
        {
            itemid = "homemade_landmine",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "concrete_barricade",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "high_external_stone_wall",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "elevator",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "ladder_hatch",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "hoodie",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "molotov_cocktail",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "rf_broadcaster",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "pump_shotgun",
            amount = { 1, 3 },
            chance = 0.005,
        },
        {
            itemid = "powered_water_purifier",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "python_revolver",
            amount = { 10, 20 },
            chance = 0.005,
        },
        {
            itemid = "large_water_catcher",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "tesla_coil",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "heavy_plate_pants",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "medium_rechargeable_battery",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "thompson",
            amount = { 10, 20 },
            chance = 0.005,
        },
        {
            itemid = "medical_syringe",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "memory_cell",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "prison_cell_wall",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "coffee_can_helmet",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "road_sign_kilt",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "smart_alarm",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "ptz_cctv_camera",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "large_furnace",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "computer_station",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "salvaged_icepick",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "triangle_ladder_hatch",
            amount = 100,
            chance = 0.005,
        },
        {
            itemid = "flame_thrower",
            amount = { 0, 2 },
            chance = 0.005,
        },
        {
            itemid = "rf_pager",
            amount = 100,
            chance = 0.005,
        },
    })

    gRust.CreateConfigValue("environment/crate.military.respawn_time", 300)
    gRust.CreateConfigValue("environment/military.respawn_chance", 0.5)

    ENT.Model = "models/environment/crates/crate2.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/crate.military")
    ENT.RespawnTime = gRust.GetConfigValue("environment/crate.military.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/military.respawn_chance")
end