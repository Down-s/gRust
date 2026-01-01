AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = { 2, 4 }

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/crate", {
        {
            itemid = "scrap",
            amount = { 5, 5 },
            chance = 1.0,
        },
        {
            itemid = "metal_spring",
            amount = { 1, 1 },
            chance = 0.14,
        },
        {
            itemid = "road_signs",
            amount = { 2, 3 },
            chance = 0.14,
        },
        {
            itemid = "metal_pipe",
            amount = { 1, 4 },
            chance = 0.14,
        },
        {
            itemid = "semi_automatic_body",
            amount = { 1, 1 },
            chance = 0.14,
        },
        {
            itemid = "electric_fuse",
            amount = { 1, 1 },
            chance = 0.14,
        },
        {
            itemid = "gears",
            amount = { 2, 2 },
            chance = 0.14,
        },
        {
            itemid = "sheet_metal",
            amount = { 1, 1 },
            chance = 0.14,
        },
        {
            itemid = "diving_mask",
            amount = { 1, 1 },
            chance = 0.04,
        },
        {
            itemid = "hazmat_suit",
            amount = { 1, 1 },
            chance = 0.04,
        },
        {
            itemid = "diving_tank",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "wetsuit",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "diving_fins",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "large_solar_panel",
            amount = { 1, 2 },
            chance = 0.02,
        },
        {
            itemid = "small_rechargeable_battery",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "xor_switch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "or_switch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "electrical_branch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "splitter",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "blocker",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "timer",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "switch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "pressure_pad",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "rand_switch",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "door_controller",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "flasher_light",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "and_switch",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "siren_light",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "igniter",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "root_combiner",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "flare",
            amount = { 4, 5 },
            chance = 0.01,
        },
        {
            itemid = "shirt",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "sandbag_barricade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "ceiling_light",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "storage_adaptor",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "audio_alarm",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "watch_tower",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "wooden_ladder",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "fridge",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "chainlink_fence_gate",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "waterpipe_shotgun",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "shotgun_trap",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "floor_triangle_grill",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "electric_heater",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "riot_helmet",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "pickaxe",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "fluid_switch_pump",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "kayak",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "longsleeve_tshirt",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "combat_knife",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "drop_box",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "floor_grill",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "mace",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "reactive_target",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_cleaver",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "small_water_catcher",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "flame_turret",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "tshirt",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "fluid_splitter",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "miners_hat",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "speargun",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "double_barrel_shotgun",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "fluid_combiner",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "silencer",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "weapon_flashlight",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "satchel_charge",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "beancan_grenade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "telephone",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "industrial_splitter",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "high_external_wooden_wall",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "jacket",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_hammer",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_sword",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "revolver",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "industrial_conveyor",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "bucket_helmet",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "button",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "snap_trap",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "metal_window_bars",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "snow_jacket",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "mixing_table",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "chainlink_fence",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "industrial_combiner",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "high_external_wooden_gate",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "pants",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "bed1",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "chair",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "sprinkler",
            amount = { 1, 1 },
            chance = 0.005,
        },
        {
            itemid = "hatchet",
            amount = { 1, 1 },
            chance = 0.005,
        },
        {
            itemid = "barbed_wooden_barricade",
            amount = { 1, 1 },
            chance = 0.005,
        },
        {
            itemid = "compound_bow",
            amount = { 1, 1 },
            chance = 0.005,
        },
        {
            itemid = "medium_rechargeable_battery",
            amount = { 1, 1 },
            chance = 0.004,
        },
        {
            itemid = "laser_detector",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "large_rechargeable_battery",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "memory_cell",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "counter",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "rf_broadcaster",
            amount = { 1, 1 },
            chance = 0.002,
        },
        {
            itemid = "hbhf_sensor",
            amount = { 1, 1 },
            chance = 0.002,
        },
        {
            itemid = "rf_receiver",
            amount = { 1, 1 },
            chance = 0.002,
        },
        {
            itemid = "tesla_coil",
            amount = { 1, 1 },
            chance = 0.002,
        },
        {
            itemid = "small_generator",
            amount = { 1, 1 },
            chance = 0.002,
        },
        {
            itemid = "rf_transmitter",
            amount = { 1, 1 },
            chance = 0.001,
        },
        {
            itemid = "rf_pager",
            amount = { 1, 1 },
            chance = 0.001,
        },
    })

    gRust.CreateConfigValue("environment/crate.respawn_time", 300)
    gRust.CreateConfigValue("environment/crate.respawn_chance", 0.65)

    ENT.Model = "models/environment/crates/crate.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/crate")
    ENT.RespawnTime = gRust.GetConfigValue("environment/crate.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/crate.respawn_chance")
end