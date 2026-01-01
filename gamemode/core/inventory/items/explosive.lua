gRust.ItemRegister("timed_explosive_charge")
:SetName("Timed Explosive Charge")
:SetDescription("The Timed Explosive Charge, mostly knowns as C4, is an item often used when raiding other players. Once thrown, the charge will stick to walls, floors, doors and deployable items. Once attached to a target, the timed explosives will automatically detonate in a dependable and quick manner (in comparison to it's unreliable counterpart, the Satchel Charge). However, it does damage only to the structure it's attached to. If attached to a door, for example, it would destroy it without damaging the door frame or nearby walls. This item deals the most damage out of all explosive devices, and is the most ideal/useful for evicting your neighbors. It's important to protect this item from your enemies, as it can prove fatal once it's in the wrong hands.")
:SetIcon("materials/items/throwable/c4.png")
:SetStack(10)
:SetWeapon("rust_c4")
:SetModel("models/weapons/darky_m/rust/w_c4.mdl")
:SetMaterial("Stone")
:AddToCategory("Tools")
:SetRecipe(
    "explosives", 20,
    "cloth", 5,
    "tech_trash", 2
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("satchel_charge")
:SetName("Satchel Charge")
:SetDescription("The Satchel Charge is a midgame raiding tool that can be used to destroy player-made buildings for the purpose of entering and looting another player's base. The Satchel charge becomes armed when placed, has a random time until detonation, and has a small chance to malfunction, requiring the user to pick up and rearm the Charge. Note that sometimes the charge will re-ignite when the dud is picked up, going off with a very short fuse!")
:SetIcon("materials/items/throwable/satchel.png")
:SetStack(10)
:SetWeapon("rust_satchel")
:SetModel("models/weapons/darky_m/rust/w_satchel.mdl")
:SetMaterial("Stone")
:AddToCategory("Tools")
:SetRecipe(
    "beancan_grenade", 4,
    -- TODO: Add small stashes
    --"small_stash", 5,
    "rope", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(5)
:SetResearchCost(125)
:SetTier(1)
:Register()

gRust.ItemRegister("beancan_grenade")
:SetName("Beancan Grenade")
:SetDescription("The Beancan Grenade is an early-game tool. They're used to craft Satchel Charges, but can be used by themselves in raiding. The Beancan Grenade has a random detonation period and can kill a player if it's within the range. The Beancan Grenade has a 15% chance to be a dud. However, Beancan Grenades have a 50% chance to explode when you attempt to pick them up again after a dud.")
:SetIcon("materials/items/throwable/beancan.png")
:SetStack(5)
:SetWeapon("rust_beancan")
:SetModel("models/weapons/darky_m/rust/w_beancan.mdl")
:SetMaterial("Metal")
:AddToCategory("Weapons")
:SetRecipe(
    "gun_powder", 60,
    "metal_fragments", 20
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(10)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("f1_grenade")
:SetName("F1 Grenade")
:SetDescription("End game grenade often used in combat. Unlike the Beancan Grenade, the F1 Grenade is much more reliable as it does not dud or randomly explode.")
:SetIcon("materials/items/throwable/f1_grenade.png")
:SetStack(5)
:SetWeapon("rust_f1grenade")
:SetModel("models/weapons/darky_m/rust/w_f1.mdl")
:SetMaterial("Metal")
:AddToCategory("Weapons")
:SetRecipe(
    "gun_powder", 30,
    "metal_fragments", 25
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(10)
:SetResearchCost(75)
:SetTier(2)
:Register()