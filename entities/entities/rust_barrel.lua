AddCSLuaFile()

ENT.Base = "rust_base"
DEFINE_BASECLASS("rust_base")

ENT.SelectAmount = 2

ENT.BulletDamageScale = 1.0
ENT.MeleeDamageScale = 1.25
ENT.ExplosiveDamageScale = 1.0

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/barrel", {
        {
            itemid = "scrap",
            amount = { 2, 2 },
            chance = 1.0,
        },
        {
            itemid = "rope",
            amount = { 1, 2 },
            chance = 0.15,
        },
        {
            itemid = "metal_blade",
            amount = { 1, 1 },
            chance = 0.15,
        },
        {
            itemid = "sewing_kit",
            amount = { 3, 4 },
            chance = 0.08,
        },
        {
            itemid = "tarp",
            amount = { 1, 1 },
            chance = 0.08,
        },
        {
            itemid = "empty_propane_tank",
            amount = { 1, 1 },
            chance = 0.08,
        },
        {
            itemid = "metal_pipe",
            amount = { 1, 4 },
            chance = 0.01,
        },
        {
            itemid = "sheet_metal",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "electric_fuse",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "gears",
            amount = { 2, 2 },
            chance = 0.01,
        },
        {
            itemid = "road_signs",
            amount = { 2, 3 },
            chance = 0.01,
        },
        {
            itemid = "metal_spring",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "water_barrel",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "paddle",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "shorts",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "wooden_floor_spikes",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "wooden_barricade_cover",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "rug_bear_skin",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "bandana_mask",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "wooden_barricade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "spinning_wheel",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "salvaged_shelves",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "wood_shutters",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "water_bucket",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "beanie_hat",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "stone_barricade",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "acoustic_guitar",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "improvised_balaclava",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "rug",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "large_planter_box",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "tuna_can_lamp",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "baseball_cap",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "large_wooden_sign",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "boonie_hat",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "mail_box",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "huge_wooden_sign",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "stone_fireplace",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "tank_top",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "leather_gloves",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "igniter",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "binoculars",
            amount = { 1, 1 },
            chance = 0.01,
        },
        {
            itemid = "table",
            amount = { 1, 1 },
            chance = 0.01,
        },
    })

    gRust.CreateConfigValue("environment/barrel.respawn_time", 300)
    gRust.CreateConfigValue("environment/barrel.respawn_chance", 0.5)
    
    ENT.HitSound = true

    ENT.Barrels = {
        function(barrel)
            barrel:SetHP(35)
            barrel:SetMaxHP(35)
            barrel:SetColor(Color(200, 165, 115))
        end,
        function(barrel)
            barrel:SetHP(50)
            barrel:SetMaxHP(50)
            barrel:SetColor(Color(80, 120, 205))
        end,
    }
    ENT.LootTable = gRust.GetConfigValue("loot_tables/barrel")
    ENT.RespawnTime = gRust.GetConfigValue("environment/barrel.respawn_time")
    
    function ENT:Initialize()
        self:SetModel("models/environment/misc/barrel_v2.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:PrecacheGibs()
        
        self:SetupBarrel()

        if (self:CreatedByMap()) then
            self:SetRespawn(true)
        end
    end

    function ENT:SetupBarrel()
        if (math.random(1, 2) == 1) then
            self:SetHP(35)
            self:SetMaxHP(35)
            self:SetColor(Color(200, 165, 115))
        else
            self:SetHP(50)
            self:SetMaxHP(50)
            self:SetColor(Color(80, 120, 205))
        end
    end
    
    function ENT:OnKilled()
        local loot = gRust.SelectLootFromTable(self.LootTable, self.SelectAmount)
        for _, v in pairs(loot) do
            local pos = self:LocalToWorld(self:OBBCenter())
            local ang = AngleRand()
            local ent = gRust.CreateItemBag(v, pos, ang)
        end
    
        if (self:GetRespawn()) then
            self:CreateRespawn()
        end

        self:GibBreakServer(VectorRand() * 100)
        self:Remove()
    end
end    
