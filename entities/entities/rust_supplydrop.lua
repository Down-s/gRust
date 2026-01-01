AddCSLuaFile()

ENT.Base = "rust_lootbox"

ENT.Slots = 12
ENT.SelectAmount = { 3, 5 }
ENT.ShouldSave = true

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/supply_drop", {
        {
            itemid = "pistol_ammo",
            amount = { 15, 93 },
            chance = 0.86,
        },
        {
            itemid = "556_rifle_ammo",
            amount = { 12, 128 },
            chance = 0.53,
        },
        {
            itemid = "scrap",
            amount = { 140, 159 },
            chance = 0.33,
        },
        {
            itemid = "hq_metal",
            amount = { 32, 39 },
            chance = 0.33,
        },
        {
            itemid = "f1_grenade",
            amount = { 6, 9 },
            chance = 0.29,
        },
        {
            itemid = "satchel_charge",
            amount = { 2, 2 },
            chance = 0.29,
        },
        {
            itemid = "incendiary_pistol_bullet",
            amount = { 10, 30 },
            chance = 0.27,
        },
        {
            itemid = "pump_shotgun",
            amount = { 1, 1 },
            chance = 0.22,
        },
        {
            itemid = "thompson",
            amount = { 1, 1 },
            chance = 0.22,
        },
        {
            itemid = "semi_automatic_rifle",
            amount = { 1, 1 },
            chance = 0.22,
        },
        {
            itemid = "custom_smg",
            amount = { 1, 1 },
            chance = 0.22,
        },
        {
            itemid = "coffee_can_helmet",
            amount = { 1, 1 },
            chance = 0.20,
        },
        {
            itemid = "hv_pistol_ammo",
            amount = { 10, 30 },
            chance = 0.14,
        },
        {
            itemid = "timed_explosive_charge",
            amount = { 1, 1 },
            chance = 0.14,
        },
        {
            itemid = "incendiary_556_rifle_ammo",
            amount = { 8, 24 },
            chance = 0.13,
        },
        {
            itemid = "m92_pistol",
            amount = { 1, 1 },
            chance = 0.10,
        },
        {
            itemid = "m39_rifle",
            amount = { 1, 1 },
            chance = 0.10,
        },
        {
            itemid = "mp5a4",
            amount = { 1, 1 },
            chance = 0.10,
        },
        {
            itemid = "spas_12_shotgun",
            amount = { 1, 1 },
            chance = 0.09,
        },
        {
            itemid = "tech_trash",
            amount = { 4, 4 },
            chance = 0.08,
        },
        {
            itemid = "gears",
            amount = { 5, 5 },
            chance = 0.08,
        },
        {
            itemid = "sheet_metal",
            amount = { 5, 5 },
            chance = 0.08,
        },
        {
            itemid = "metal_pipe",
            amount = { 5, 5 },
            chance = 0.08,
        },
        {
            itemid = "hv_556_rifle_ammo",
            amount = { 10, 30 },
            chance = 0.07,
        },
        {
            itemid = "explosive_556_rifle_ammo",
            amount = { 8, 24 },
            chance = 0.07,
        },
        {
            itemid = "lr300_assault_rifle",
            amount = { 1, 1 },
            chance = 0.02,
        },
    })

    ENT.Model = "models/rust/env_loot_supplydrop.mdl"
    ENT.LootTable = gRust.GetConfigValue("loot_tables/supply_drop")

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetInteractable(true)
        self:SetInteractText("OPEN")
        self:SetInteractIcon("open")

        local phys = self:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:Wake()
            phys:SetMass(100)
            phys:SetDamping(15, 50)
        end
    
        self.Containers = {}
        self:CreateContainers()
    end

    function ENT:PhysicsCollide(data, phys)
        self:SetBodygroup(1, 1)
    end
end