AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_lootbox")

ENT.SelectAmount = 5
ENT.RemoveOnEmpty = true

gRust.CreateConfigValue("loot_tables/crate.locked", {
    {
        itemid = "pistol_bullet",
        amount = { 15, 48 },
        chance = 0.56,
    },
    {
        itemid = "mlrs_aiming_module",
        amount = 1,
        chance = 0.5,
    },
    {
        itemid = "metal_pipe",
        amount = { 5, 20 },
        chance = 0.45,
    },
    {
        itemid = "rifle_body",
        amount = { 1, 5 },
        chance = 0.45,
    },
    {
        itemid = "smg_body",
        amount = { 1, 5 },
        chance = 0.45,
    },
    {
        itemid = "tech_trash",
        amount = { 2, 13 },
        chance = 0.45,
    },
    {
        itemid = "hq_metal",
        amount = { 15, 96 },
        chance = 0.45,
    },
    {
        itemid = "556_rifle_ammo",
        amount = { 8, 50 },
        chance = 0.4,
    },
    {
        itemid = "jacket",
        amount = 1,
        chance = 0.34,
    },
    {
        itemid = "metal_chest_plate",
        amount = 1,
        chance = 0.31,
    },
    {
        itemid = "targeting_computer",
        amount = { 1, 5 },
        chance = 0.28,
    },
    {
        itemid = "metal_facemask",
        amount = 1,
        chance = 0.25,
    },
    {
        itemid = "bolt_rifle",
        amount = 1,
        chance = 0.23,
    },
    {
        itemid = "assault_rifle",
        amount = 1,
        chance = 0.23,
    },
    {
        itemid = "cctv_camera",
        amount = { 1, 4 },
        chance = 0.23,
    },
    {
        itemid = "mp5a4",
        amount = 1,
        chance = 0.23,
    },
    {
        itemid = "8x_scope",
        amount = 1,
        chance = 0.14,
    },
    {
        itemid = "timed_explosive_charge",
        amount = { 1, 4 },
        chance = 0.14,
    },
    {
        itemid = "armored_door",
        amount = 1,
        chance = 0.14,
    },
    {
        itemid = "explosives",
        amount = { 1, 4 },
        chance = 0.14,
    },
    {
        itemid = "armored_double_door",
        amount = 1,
        chance = 0.14,
    },
    {
        itemid = "reinforced_glass_window",
        amount = { 1, 3 },
        chance = 0.13,
    },
    {
        itemid = "weapon_lasersight",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "hmlmg",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "thompson",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "heavy_plate_helmet",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "heavy_plate_pants",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "heavy_plate_jacket",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "custom_smg",
        amount = 1,
        chance = 0.13,
    },
    {
        itemid = "prototype_17",
        amount = 1,
        chance = 0.11,
    },
    {
        itemid = "m92_pistol",
        amount = 1,
        chance = 0.11,
    },
    {
        itemid = "supply_signal",
        amount = 1,
        chance = 0.07,
    },
    {
        itemid = "m39_rifle",
        amount = 1,
        chance = 0.07,
    },
    {
        itemid = "lr300_assault_rifle",
        amount = 1,
        chance = 0.07,
    },
    {
        itemid = "incendiary_556_rifle_ammo",
        amount = 1,
        chance = 0.06,
    },
    {
        itemid = "hv_556_rifle_ammo",
        amount = 1,
        chance = 0.06,
    },
    {
        itemid = "explosive_556_rifle_ammo",
        amount = 1,
        chance = 0.06,
    },
    {
        itemid = "rocket",
        amount = 1,
        chance = 0.06,
    },
    {
        itemid = "l96_rifle",
        amount = 1,
        chance = 0.05,
    },
    {
        itemid = "16x_scope",
        amount = 1,
        chance = 0.05,
    },
    {
        itemid = "spas12_shotgun",
        amount = 1,
        chance = 0.04,
    },
    {
        itemid = "12_gauge_buckshot",
        amount = { 8, 11 },
        chance = 0.04,
    },
    {
        itemid = "large_water_catcher",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "rf_transmitter",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "prison_cell_gate",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "strengthened_glass_window",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "muzzle_brake",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "locker",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "large_furnace",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "metal_barricade",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "prison_cell_wall",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "industrial_crafter",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "high_external_stone_wall",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "homemade_landmine",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "roadsign_kilt",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "storage_monitor",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "and_switch",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "semi_auto_rifle",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "concrete_barricade",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "muzzle_boost",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "salvaged_axe",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "longsword",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "ptz_cctv_camera",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "roadsign_jacket",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "large_medkit",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "rf_pager",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "f1_grenade",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "hbhf_sensor",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "powered_water_purifier",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "tesla_coil",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "small_oil_refinery",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "smart_alarm",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "rand_switch",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "flamethrower",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "small_generator",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "memory_cell",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "smart_switch",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "roadsign_horse_armor",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "ladder_hatch",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "hoodie",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "extended_magazine",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "rf_receiver",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "night_vision_goggles",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "high_quality_horse_shoes",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "rocket_launcher",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "drone",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "metal_horizontal_embrasure",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "laser_detector",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "medium_rechargeable_battery",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "boots",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "modular_car_lift",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "flashbang",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "molotov_cocktail",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "elevator",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "counter",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "hazmat_suit",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "chainsaw",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "medical_syringe",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "garage_door",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "large_rechargeable_battery",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "electric_furnace",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "metal_vertical_embrasure",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "auto_turret",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "triangle_ladder_hatch",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "rf_broadcaster",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "python_revolver",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "high_external_stone_gate",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "holosight",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "wind_turbine",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "computer_station",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "search_light",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "roadsign_gloves",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "salvaged_icepick",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "coffee_can_helmet",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "water_pump",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "semi_auto_pistol",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "smoke_grenade",
        amount = { 1, 2 },
        chance = 0.02,
    },
    {
        itemid = "pump_shotgun",
        amount = 1,
        chance = 0.02,
    },
    {
        itemid = "m249",
        amount = 1,
        chance = 0.02,
    },
})

gRust.CreateConfigValue("environment/crate.locked.respawn_time", 1800)
gRust.CreateConfigValue("environment/crate.locked.respawn_chance", 1.0)
gRust.CreateConfigValue("environment/crate.locked.hack_time", 900)

ENT.Model = "models/environment/crates/locked_crate.mdl"
ENT.LootTable = gRust.GetConfigValue("loot_tables/crate.locked")
ENT.RespawnTime = gRust.GetConfigValue("environment/crate.locked.respawn_time")
ENT.RespawnChance = gRust.GetConfigValue("environment/crate.locked.respawn_chance")

local COMPUTER_POS = Vector(-5, 5, 56.325)
local COMPUTER_ANG = Angle(0, 170, 0)

function ENT:Initialize()
    self:SetInteractable(true)
    self:SetInteractText("START HACKING")
    self:SetInteractIcon("boosts")
    self:SetRespawn(true)

    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:CreateContainers()
end

function ENT:Interact()
    if (!self.Hacking and !self.Hacked) then
        self:StartHacking()
    end
end

function ENT:StartHacking()
    if (self.Hacking or self.Hacked) then return end
    self.Computer = ents.Create("rust_hackingcomputer")
    self.Computer:SetPos(self:LocalToWorld(COMPUTER_POS))
    self.Computer:SetAngles(self:LocalToWorldAngles(COMPUTER_ANG))
    self.Computer:SetParent(self)
    self.Computer:Spawn()

    self.Computer:SetFinishTime(CurTime() + gRust.GetConfigValue("environment/crate.locked.hack_time"))
    self.Hacking = true

    self:SetInteractable(false)
end

function ENT:FinishHacking()
    if (!self.Hacking) then return end
    self.Hacking = false
    self.Hacked = true

    self:SetInteractable(true)
    self:SetInteractText("OPEN")
    self:SetInteractIcon("open")
end

function ENT:Think()
    BaseClass.Think(self)
    if (self.Hacking and !self.Hacked) then
        if (self.Computer:GetFinishTime() <= CurTime()) then
            self:FinishHacking()
        end
    end
end

function ENT:IsLootable()
    return self.Hacked
end

function ENT:OnRemove()
    BaseClass.OnRemove(self)

    if (IsValid(self.Computer)) then
        self.Computer:Remove()
    end
end