gRust.ItemRegister("bandage")
:SetName("Bandage")
:SetDescription("Bandages are crafted medical supplies that stop bleeding and heal a small amount of health. It is common to chain-use bandages when the player has no access to other medical supplies, as hemp can be picked while running around the map and used for an easy health boost.")
:SetIcon("materials/items/medical/bandages.png")
:SetStack(3)
:SetWeapon("rust_bandage")
--:SetModel("models/weapons/darky_m/rust/w_rock.mdl")
:SetMaterial("Cloth")
:AddToCategory("Medical")
:SetRecipe(
    "cloth", 4
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(5)
:Register()

gRust.ItemRegister("medical_syringe")
:SetName("Medical Syringe")
:SetDescription("The Medical Syringe is the best medical supply used for combat situations. It instant heals you a portion of your health and slowly heals the rest. It also reduces your radiation poisoning which is very useful while navigating the red puzzle building with high levels of radiation. As of July 2021, the Medical Syringe can be used to revive people in Wounded state. It revives faster than holding E on the wounded player, however this gives you a disadvantage to look around and spot enemies as you will cancel the heal animation.")
:SetIcon("materials/items/medical/syringe.png")
:SetStack(2)
:SetCondition(true)
:SetWeapon("rust_medicalsyringe")
--:SetModel("models/weapons/darky_m/rust/w_rock.mdl")
:SetMaterial("Cloth")
:AddToCategory("Medical")
:SetRecipe(
    "cloth", 15,
    "metal_fragments", 10,
    "low_grade_fuel", 10
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(10)
:SetResearchCost(75)
:SetTier(2)
:Register()

gRust.ItemRegister("large_medkit")
:SetName("Large Medkit")
:SetDescription("The Large Medkit is medical supplies that stops bleeding when used, provides 10 instant health and heals to max health overtime. You can use the Large Medkit by pressing it on your Inventory and click the Use button or move it to your toolbar and press the slot key to use. It does not have an Use animation so bleeding can be stopped immediately. As of July 2021, the Large Medkit can revive you with a chance of 100% while in Wounded state, it must be placed in your toolbar to be consumed. Your revival chance also depends on your Hunger and Hydration status, if both are full, they will give a total of 40% chance to revive you.")
:SetIcon("materials/items/medical/large_medkit.png")
:SetStack(1)
:SetMaterial("Cloth")
:SetBleeding(-100)
:SetInstantHealth(10)
:SetHealing(100)
:AddToCategory("Medical")
:SetRecipe(
    "medical_syringe", 2,
    "low_grade_fuel", 10
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(15)
:SetResearchCost(75)
:SetTier(2)
:Register()