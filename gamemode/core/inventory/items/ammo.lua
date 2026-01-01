gRust.ItemRegister("pistol_bullet")
:SetName("Pistol Bullet")
:SetDescription("Standard ammunition for pistols and submachine guns.")
:SetStack(128)
:SetIcon("materials/items/ammo/pistol_bullet.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.Normal)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 5
)
:SetCraftable(true)
:SetCraftAmount(4)
:SetCraftTime(1)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("hv_pistol_ammo")
:SetName("HV Pistol Ammo")
:SetDescription("The high velocity pistol ammo is used by pistols and submachine guns. Its notable differences from regular pistol ammo include faster bullet travel and increased crafting cost.")
:SetStack(128)
:SetIcon("materials/items/ammo/hv_pistol_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.HighVelocity)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 20
)
:SetCraftable(true)
:SetCraftAmount(3)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("incendiary_pistol_bullet")
:SetName("Incendiary Pistol Bullet")
:SetDescription("Slower, slightly more effective pistol bullet that also deals fire damage. Useful against Heavy Plate armor.")
:SetStack(128)
:SetIcon("materials/items/ammo/incendiary_pistol_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.Incendirary)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 20,
    "sulfur", 5
)
:SetCraftable(true)
:SetCraftAmount(3)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("556_rifle_ammo")
:SetName("5.56 Rifle Ammo")
:SetDescription("Standard high powered ammunition, used by any rifle in the game currently. Offers superior damage, range, accuracy, damage drop off and air resistance from the Pistol Bullet.")
:SetStack(128)
:SetIcon("materials/items/ammo/rifle_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.Normal)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 5
)
:SetCraftable(true)
:SetCraftAmount(3)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("explosive_556_rifle_ammo")
:SetName("Explosive 5.56 Rifle Ammo")
:SetDescription("A variant of the standard 5.56 rifle ammunition. The Explosive 5.56 round deals a small amount of additional explosion damage to a player upon direct impact as well as damaging nearby structures or players. The round is effective against low-tier structures such as Wood walls and Sheet Metal doors.")
:SetStack(128)
:SetIcon("materials/items/ammo/explosive_rifle_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.Explosive)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 20,
    "sulfur", 10
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(3)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("hv_556_rifle_ammo")
:SetName("HV 5.56 Rifle Ammo")
:SetDescription("A variant of the standard 5.56 rifle ammunition. The High Velocity (HV) 5.56 round will travel faster than the standard round at a more expensive crafting cost. The round experiences little bullet drop. This type of ammo is best used with Bolt Action Rifle and L96 Rifle.")
:SetStack(128)
:SetIcon("materials/items/ammo/hv_rifle_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.HighVelocity)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 20
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(3)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("incendiary_556_rifle_ammo")
:SetName("Incendiary 5.56 Rifle Ammo")
:SetDescription("A variant of the standard 5.56 rifle ammunition. The 5.56 Incendiary round will ignite on impact dealing both bullet and fire damage to a player. The round is however subject to increased bullet drop.")
:SetStack(128)
:SetIcon("materials/items/ammo/incendiary_rifle_ammo.png")
:SetMaterial("Metal")
:SetProjectileType(ProjectileType.Incendiary)
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 10,
    "gun_powder", 20,
    "sulfur", 5
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(3)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("arrow")
:SetName("Arrow")
:SetDescription("The Wooden Arrow is one of four ammo types for the crossbow and the bow. It has lower range and velocity than the High Velocity Arrow, but it does more damage compared to it.")
:SetStack(64)
:SetModel("models/weapons/darky_m/rust/bone_arrow.mdl")
:SetIcon("materials/items/ammo/arrow.png")
:SetMaterial("Wood")
:AddToCategory("Ammo")
:SetRecipe(
    "wood", 25,
    "stones", 10
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(3)
:Register()

gRust.ItemRegister("nailgun_nails")
:SetName("Nailgun Nails")
:SetDescription("Early game cheap and easy to acquire ammo for the Nailgun. Has a unique trajectory and velocity that is worse than regular arrows shot from a Hunting Bow, thus giving it a really small effective range. Work best up close and not beyond 10 meters.")
:SetStack(64)
:SetIcon("materials/items/ammo/nailgun_nails.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "metal_fragments", 8
)
:SetCraftable(true)
:SetCraftAmount(5)
:SetCraftTime(2)
:Register()

gRust.ItemRegister("handmade_shell")
:SetName("Handmade Shell")
:SetDescription("The handmade shell is an early-game shotgun ammunition that fires a spread of 20 low-damage pellets. It's highly damaging in close quarters, but its lethality quickly drops off as range increases. In comparison to 12 gauge buckshot, the handmade shell has significantly more pellets, but less damage overall.")
:SetStack(64)
:SetIcon("materials/items/ammo/handmade_shell.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "stones", 5,
    "gun_powder", 5
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(2)
:Register()

gRust.ItemRegister("rocket")
:SetName("Rocket")
:SetDescription("In Rust, rockets are the ammunition for rocket launchers, rockets will cause splash damage that can hit up to 4 walls at once. This type of ammunition is particularly effective against buildings. In terms of trajectory, rockets are launched forward with a considerable speed upon firing. However, the trajectory eventually falls off due to the in-game gravity effect. Rockets are currently one of the best tools for raiding and destroying buildings. Rockets are also deadly against players due to its high damage and range of splash damage.")
:SetStack(3)
:SetIcon("materials/items/ammo/rocket.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "metal_pipe", 2,
    "gun_powder", 150,
    "explosives", 10
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(10)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("high_velocity_rocket")
:SetName("High Velocity Rocket")
:SetDescription("The High Velocity Rocket is essentially a rocket with much less damage than the standard rocket. However, it is also much cheaper, and as the name suggests it has a higher velocity than the standard rocket, so it could be useful for rocketing targets at extreme range. Because of its lower cost and damage, it is useful for situations where a full rocket would be overkill.")
:SetStack(3)
:SetIcon("materials/items/ammo/high_velocity_rocket.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "metal_pipe", 1,
    "gun_powder", 100
)
:SetCraftable(true)
:SetCraftAmount(2)
:SetCraftTime(10)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("40mm_he_grenade")
:SetName("40mm HE Grenade")
:SetDescription("Ammunition for a 40mm Grenade Launcher.")
:SetStack(2)
:SetIcon("materials/items/ammo/40mm_he_grenade.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "gun_powder", 20,
    "metal_pipe", 1,
    "explosives", 1
)
:SetCraftable(false)
:Register()

gRust.ItemRegister("40mm_shotgun_round")
:SetName("40mm Shotgun Round")
:SetDescription("The 40mm shotgun round is an ammunition type for the Multiple Grenade Launcher. It fires a wide spread of 12 pellets that can do a massive amount of damage at close range, being able to one-shot a fully geared player if all pellets connect.")
:SetStack(2)
:SetIcon("materials/items/ammo/40mm_shotgun_round.png")
:SetMaterial("Metal")
:AddToCategory("Ammo")
:SetRecipe(
    "gun_powder", 20,
    "metal_pipe", 1,
    "explosives", 1
)
:SetCraftable(false)
:Register()