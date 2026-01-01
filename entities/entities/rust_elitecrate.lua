AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = { 2, 3 }

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/elite_crate", {
        {
            itemid = "scrap",
            amount = { 25, 25 },
            chance = 1.0,
        },
        {
            itemid = "hq_metal",
            amount = { 15, 70 },
            chance = 0.28,
        },
        {
            itemid = "tech_trash",
            amount = { 2, 9 },
            chance = 0.28,
        },
        {
            itemid = "smg_body",
            amount = { 1, 3 },
            chance = 0.28,
        },
        {
            itemid = "rifle_body",
            amount = { 1, 3 },
            chance = 0.28,
        },
        {
            itemid = "metal_pipe",
            amount = { 5, 15 },
            chance = 0.28,
        },
        {
            itemid = "targeting_computer",
            amount = { 1, 3 },
            chance = 0.16,
        },
        {
            itemid = "cctv_camera",
            amount = { 1, 3 },
            chance = 0.13,
        },
        {
            itemid = "12_gauge_buckshot",
            amount = { 5, 11 },
            chance = 0.10,
        },
        {
            itemid = "double_barrel_shotgun",
            amount = { 1, 1 },
            chance = 0.09,
        },
        {
            itemid = "f1_grenade",
            amount = { 1, 4 },
            chance = 0.04,
        },
        {
            itemid = "supply_signal",
            amount = { 1, 2 },
            chance = 0.04,
        },
        {
            itemid = "bolt_action_rifle",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "mp5a4",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "assault_rifle",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "pistol_bullet",
            amount = { 15, 48 },
            chance = 0.03,
        },
        {
            itemid = "weapon_lasersight",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "armored_door",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "8x_zoom_scope",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "metal_facemask",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "timed_explosive_charge",
            amount = { 1, 2 },
            chance = 0.03,
        },
        {
            itemid = "longsword",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "armored_double_door",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "metal_chest_plate",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "reinforced_glass_window",
            amount = { 1, 1 },
            chance = 0.03,
        },
        {
            itemid = "explosives",
            amount = { 1, 2 },
            chance = 0.03,
        },
        {
            itemid = "556_rifle_ammo",
            amount = { 8, 50 },
            chance = 0.02,
        },
        {
            itemid = "waterpipe_shotgun",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "beancan_grenade",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "compound_bow",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "silencer",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "revolver",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "salvaged_cleaver",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "weapon_flashlight",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "crossbow",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "mace",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "simple_handmade_sight",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "nailgun",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "combat_knife",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "thompson",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "low_grade_fuel",
            amount = { 35, 35 },
            chance = 0.02,
        },
        {
            itemid = "custom_smg",
            amount = { 1, 1 },
            chance = 0.02,
        },
        {
            itemid = "holosight",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "muzzle_brake",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "chainsaw",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "heavy_plate_helmet",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "roadsign_gloves",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "small_oil_refinery",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "smoke_grenade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "metal_vertical_embrasure",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "homemade_landmine",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "night_vision_goggles",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "horizontal_embrasure",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "extended_magazine",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "memory_cell",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "smart_alarm",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "heavy_plate_pants",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "large_furnace",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "locker",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "hazmat_suit",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "road_sign_jacket",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "boots",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "medium_rechargeable_battery",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "strengthened_glass_window",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "rand_switch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "smart_switch",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "large_medkit",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "auto_turret",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "road_sign_kilt",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "prison_cell_gate",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "coffee_can_helmet",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "electric_furnace",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "medical_syringe",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "high-external_stone_gate",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "rocket_launcher",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "concrete_barricade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "small_generator",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "semi_automatic_pistol",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "semi_automatic_rifle",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "triangle_ladder_hatch",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "large_water_catcher",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "computer_station",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "ptz_cctv_camera",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "muzzle_boost",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "ladder_hatch",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "heavy_plate_jacket",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "large_rechargeable_battery",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "garage_door",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "python_revolver",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_icepick",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "drone",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "prison_cell_wall",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "powered_water_purifier",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "counter",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "pump_shotgun",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "water_pump",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "hoodie",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "hbhf_sensor",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "search_light",
            amount = { 1, 2 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_axe",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "prototype_17",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "m92_pistol",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "m39_rifle",
            amount = { 1, 1 },
            chance = 0.004,
        },
        {
            itemid = "lr300_assault_rifle",
            amount = { 1, 1 },
            chance = 0.004,
        },
        {
            itemid = "m4_shotgun",
            amount = { 1, 1 },
            chance = 0.004,
        },
        {
            itemid = "12_gauge_slug",
            amount = { 1, 1 },
            chance = 0.004,
        },
        {
            itemid = "l96_rifle",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "16x_zoom_scope",
            amount = { 1, 1 },
            chance = 0.003,
        },
        {
            itemid = "spas_12_shotgun",
            amount = { 1, 1 },
            chance = 0.003,
        },
    })

    gRust.CreateConfigValue("environment/elite_crate.respawn_time", 300)
    gRust.CreateConfigValue("environment/elite_crate.respawn_chance", 0.4)

    ENT.Model = "models/environment/crates/elite_crate.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/elite_crate")
    ENT.RespawnTime = gRust.GetConfigValue("environment/elite_crate.respawn_time")
    ENT.RespawnChance = gRust.GetConfigValue("environment/elite_crate.respawn_chance")
end