AddCSLuaFile()

ENT.Base = "rust_barrel"
ENT.SelectAmount = 2

if (SERVER) then
    gRust.CreateConfigValue("loot_tables/oilbarrel", {
        {
            itemid = "crude_oil",
            amount = { 15, 19 },
            chance = 1.0,
        },
        {
            itemid = "low_grade_fuel",
            amount = { 5, 9 },
            chance = 1.0,
        }
    })

    ENT.LootTable = gRust.GetConfigValue("loot_tables/oilbarrel")

    function ENT:SetupBarrel()
        self:SetHP(50)
        self:SetMaxHP(50)
        self:SetColor(Color(170, 62, 60))
        self:SetBodygroup(1, 1)
    end
end