gRust.ItemRegister("salvaged_cleaver")
:SetName("Salvaged Cleaver")
:SetDescription("A slow, but powerful melee weapon. This is decent for PVPing but it's main use comes at farming components. The salvaged cleaver is one of the few melee weapons capable of destroying any barrel in a single hit. It is also fairly cheap, this makes it an ideal weapon to use when farming large amounts of barrels, especially if they are spread out.")
:SetIcon("materials/items/weapons/salvaged_cleaver.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_salvagedcleaver")
:SetModel("models/weapons/darky_m/rust/w_salvaged_Cleaver.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_fragments", 50,
    "road_signs", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("salvaged_sword")
:SetName("Salvaged Sword")
:SetDescription("Usually considered as the 'best' melee weapon because of its ability to take out most targets with one blow to the head, the Salvaged Sword is a cheap and durable weapon that most keep as a backup plan in the event of a fight turning to close quarters.")
:SetIcon("materials/items/weapons/salvaged_sword.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_salvagedsword")
:SetModel("models/weapons/darky_m/rust/w_salvaged_sword.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_fragments", 15,
    "metal_blade", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(20)
:SetTier(1)
:Register()

gRust.ItemRegister("bone_club")
:SetName("Bone Club")
:SetDescription("The Bone Club is a cheap, simple to craft melee weapon of the early game. Despite its shortcomings, the Bone Club serves as an upgrade to the Rock, being better at both harvesting resources and fighting.")
:SetIcon("materials/items/weapons/bone_club.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_boneclub")
:SetModel("models/weapons/darky_m/rust/w_boneclub.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "bone_fragments", 20
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(10)
:Register()

gRust.ItemRegister("wooden_spear")
:SetName("Wooden Spear")
:SetDescription("The Wooden Spear will inflict damage and cause the 'Bleeding' effect on the target. The Wooden Spear is throwable. After being thrown it will become stuck in the place it had hit (in the target). You can pick it up by pressing the 'Use' button (default 'E'). Can be upgraded to Stone Spear.")
:SetIcon("materials/items/weapons/wooden_spear.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_woodenspear")
:SetModel("models/weapons/darky_m/rust/w_wooden_spear.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "wood", 300
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("stone_spear")
:SetName("Stone Spear")
:SetDescription("The Stone Spear is slightly more durable and does more damage than the Wooden Spear. The Stone Spear will cause critical bleeding (high percentage bleeding). The Stone Spear, like the Wooden Spear, is throwable. After being thrown it will become stuck in the place it had hit (even in the target). You can pick it up by pressing the Use button (default 'E').")
:SetIcon("materials/items/weapons/stone_spear.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_stonespear")
:SetModel("models/weapons/darky_m/rust/w_stone_spear.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "wooden_spear", 1,
    "stones", 20
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(10)
:Register()

gRust.ItemRegister("assault_rifle")
:SetName("Assault Rifle")
:SetDescription("The Assault Rifle is an accurate, powerful, and fully automatic rifle that fires 5.56 rifle rounds. It has a moderate rate of fire which allows for proficiency at close to medium range. Strong recoil makes it more difficult to fire in full-auto at long range, but experienced users may be able to control it more effectively. The Assault Rifle is generally used as an end-game multipurpose weapon, able to take fights at any range.")
:SetIcon("materials/items/weapons/assault_rifle.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_assaultrifle")
:SetModel("models/weapons/darky_m/rust/w_ak47u.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 50,
    "wood", 200,
    "rifle_body", 1,
    "metal_spring", 4
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("m39_rifle")
:SetName("M39 Rifle")
:SetDescription("The M39 Rifle is the uncraftable military-grade equivalent to the Semi-Auto Rifle. Offers a higher magazine capacity, higher damage, and better accuracy. Its downsides are its slightly lower rate of fire and its rarity. It can cover a wider range of roles thanks to the superior stats it has.")
:SetIcon("materials/items/weapons/m39.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_m39")
:SetModel("models/weapons/darky_m/rust/w_m39.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_spring", 2,
    "hq_metal", 50,
    "rifle_body", 1
)
:Register()

gRust.ItemRegister("m92_pistol")
:SetName("M92 Pistol")
:SetDescription("The M92 pistol is a powerful weapon with low recoil and high fire rate and damage. It can't be crafted by the player, rather it has to be found inside crates, or purchased from the Bandit Camp.")
:SetIcon("materials/items/weapons/m92.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_m92")
:SetModel("models/weapons/darky_m/rust/w_m92.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 16,
    "semi_automatic_body", 1,
    "metal_pipe", 1,
    "metal_spring", 1
)
:Register()

gRust.ItemRegister("m249")
:SetName("M249")
:SetDescription("The M249 Light Machine Gun can only be found in Helicopter Crates and Bradley Crates. It has a magazine capacity of 100 5.56 bullets, the largest in the game. It does more damage than the Assault Rifle and has a slightly faster rate of fire while being way easier to control recoil-wise, allowing for very accurate and deadly bursts in long-range when coupled with a Holographic sight or an 8x scope.")
:SetIcon("materials/items/weapons/m249.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_m249")
:SetModel("models/weapons/darky_m/rust/w_m249.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 40,
    "metal_spring", 6,
    "gears", 6,
    "rifle_body", 1
)
:Register()

gRust.ItemRegister("mp5a4")
:SetName("MP5A4")
:SetDescription("The MP5A4 is a craftable, military-grade 30-round submachine gun. Dealing moderate to low damage with low recoil which makes it extremely effective at close range. However, the MP5A4 has one of the widest spreads in the game, limiting its use to short range. Although, like the LR300, this can be countered with a lasersight, making it viable for medium-range combat. The MP5 is currently the only craftable military-grade weapon.")
:SetIcon("materials/items/weapons/mp5.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_mp5")
:SetModel("models/weapons/darky_m/rust/w_mp5.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 15,
    "smg_body", 1,
    "metal_spring", 2
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("nailgun")
:SetName("Nailgun")
:SetDescription("A low powered low range early game weapon using nailgun nails as ammunition. The nailgun is easily accessible, very cheap and makes a good secondary weapon when in early game.")
:SetIcon("materials/items/weapons/nailgun.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_nailgun")
:SetModel("models/weapons/darky_m/rust/w_nailgun.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_fragments", 75,
    "scrap", 15
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetTier(1)
:Register()

gRust.ItemRegister("python_revolver")
:SetName("Python Revolver")
:SetDescription("The Python deals a great amount of damage per shot, but it has only 6 bullets in one magazine. It is pretty useful for shorter - medium distances. If combined with something like a Thompson, or even a Nailgun, the Python is pretty useful.")
:SetIcon("materials/items/weapons/python.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_python")
:SetModel("models/weapons/darky_m/rust/w_python.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_pipe", 3,
    "metal_spring", 1,
    "hq_metal", 10
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("revolver")
:SetName("Revolver")
:SetDescription("The Revolver is cheap, prime for early game use. Although inaccurate, the Revolver's quick rate of fire allows it hold its own against players at most stages. Being a revolver, it has a low capacity of just 8 shots, but it's still an upgrade from its 1- and 2- shot alternatives. Taking a Revolver to a fight against opponents with metal armor is quite risky, as such opponents will take many more shots than normal to take out (even more so considering the small capacity). It is best advised to only use the Revolver against opponents with similar armaments or as a sidearm to another weapon.")
:SetIcon("materials/items/weapons/revolver.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_revolver")
:SetModel("models/weapons/darky_m/rust/w_revolver.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_pipe", 1,
    "cloth", 25,
    "metal_fragments", 125
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("semi_automatic_pistol")
:SetName("Semi-Automatic Pistol")
:SetDescription("The semi-automatic pistol (commonly referred to as the 'P250' or 'P2') is a fast firing, medium damage weapon that has a moderate bullet velocity and steep damage drop-off. It is an extremely popular weapon due to it's effectiveness at short-medium distances and it's low cost. It can be easily used as a primary weapon or as a compliment to pretty much any other gun.")
:SetIcon("materials/items/weapons/sap.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_sap")
:SetModel("models/weapons/darky_m/rust/w_sap.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_pipe", 1,
    "cloth", 25,
    "metal_fragments", 125
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(1)
:Register()

gRust.ItemRegister("semi_automatic_rifle")
:SetName("Semi-Automatic Rifle")
:SetDescription("The Semi-Automatic Rifle is a staple of low quality weapons due to its high cost-efficiency. With its medium-tier damage, comparatively low recoil and high accuracy, the Semi-Automatic Rifle is the jack of all trades, but master of none.")
:SetIcon("materials/items/weapons/sar.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_sar")
:SetModel("models/weapons/darky_m/rust/w_sar.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "semi_automatic_body", 1,
    "metal_spring", 1,
    "metal_fragments", 450,
    "hq_metal", 4
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("custom_smg")
:SetName("Custom SMG")
:SetDescription("The Custom SMG is a quick-firing, low damage submachine gun with moderate recoil. Its moderate spread and low bullet velocity limit the use of the weapon to close and possibly moderate ranges, but its maximum range can be extended through the use of attachments like the Silencer or Weapon Lasersight to increase accuracy. The Custom SMG is the least expensive submachine gun, and fires the quickest out of every weapon in the game. With no movement penalty, like other SMGs, this weapon is most effectively used while on the move.")
:SetIcon("materials/items/weapons/custom_smg.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_smg")
:SetModel("models/weapons/darky_m/rust/w_smg.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 8,
    "smg_body", 1,
    "metal_spring", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("thompson")
:SetName("Thompson")
:SetDescription("The Thompson provides a mid-range alternative to other submachine guns while still offering close-range firepower. Its high accuracy and damage allow the user to take targets further away than other SMGs. With the recent QoL update, the Thompson can now take underbarrel attachments, such as the Flashlight and Laser, marginally buffing it in comparison to the other SMGs.")
:SetIcon("materials/items/weapons/thompson.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_thompson")
:SetModel("models/weapons/darky_m/rust/w_thompson.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 10,
    "wood", 100,
    "smg_body", 1,
    "metal_spring", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("lr300_assault_rifle")
:SetName("LR-300 Assault Rifle")
:SetDescription("The LR-300 is a rare, military grade assault rifle. Dealing moderate-high damage combined with its low recoil and high ammo capacity render the LR-300 a weapon to be reckoned with. However, with its moderate rate of fire and relatively high spread, its use at long ranges may be of question. It was previously considered to be one of the rarest weapons in the game, now much more readily available due to it's availability at the Bandit Camp's Black Market merchant.")
:SetIcon("materials/items/weapons/lr300.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_lr300")
:SetModel("models/weapons/darky_m/rust/w_lr300.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 40,
    "metal_spring", 2,
    "rifle_body", 1
)
:Register()

gRust.ItemRegister("crossbow")
:SetName("Crossbow")
:SetDescription("The Crossbow is a low-tier weapon that can fire either a high-velocity or regular arrow a decent distance. It is capable of relatively high damage, and is a great option when paired with a Waterpipe Shotgun or Eoka Pistol or Nailgun.")
:SetIcon("materials/items/weapons/crossbow.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_crossbow")
:SetModel("models/weapons/darky_m/rust/w_crossbow.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "wood", 200,
    "metal_fragments", 75,
    "rope", 2
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetTier(1)
:Register()

gRust.ItemRegister("hunting_bow")
:SetName("Hunting Bow")
:SetDescription("An old school weapon for new school fun. Useful for short to medium range combat. Arrows shot have a chance to break when they hit, so be sure to carry more than one arrow. Can use either regular Arrows or High-Velocity Arrows which are able to go farther faster, but do less damage. Best used to hunt animals and other humans.")
:SetIcon("materials/items/weapons/hunting_bow.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_huntingbow")
:SetModel("models/weapons/darky_m/rust/w_bow.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "wood", 200,
    "cloth", 50
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("bolt_action_rifle")
:SetName("Bolt Action Rifle")
:SetDescription("The Bolt Action Rifle is a powerful late game rifle that offers high accuracy and high damage at the cost of speed. Having the most damage and least spread of any weapon, it is often used as a designated sniper rifle, and is commonly fitted with a scope to increase the sight range for the user. Its slow rate of fire greatly limits its use in close quarters combat, and its limited capacity forces users to take shots very carefully. Having a very fast bullet velocity, users need not lead targets or compensate for gravity as much as with other weapons firing a slower bullet.")
:SetIcon("materials/items/weapons/bolt_rifle.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_boltrifle")
:SetModel("models/weapons/darky_m/rust/w_boltrifle.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 20,
    "rifle_body", 1,
    "metal_pipe", 3,
    "metal_spring", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(45)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("waterpipe_shotgun")
:SetName("Waterpipe Shotgun")
:SetDescription("The Waterpipe Shotgun is a low-tier gun that deals a decent amount of damage from close range. Can be loaded with the 12 Gauge Slug to deal less damage but shoot further. It is an early game weapon of choice for many and is often paired with a bow.")
:SetIcon("materials/items/weapons/waterpipe.png")
:SetStack(1)
:SetCondition(true)
:SetSlots(4)
:SetWeapon("rust_waterpipe")
:SetModel("models/weapons/darky_m/rust/w_waterpipe.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "wood", 150,
    "metal_fragments", 75
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("rocket_launcher")
:SetName("Rocket Launcher")
:SetDescription("The Rocket Launcher is a utility weapon which is primarily used for raiding and base defense. It fires a single rocket at a time and must be reloaded between uses. When loaded with regular Rockets, it can be utilized as an end-game raiding tool, capable of damaging multiple building parts at once. If loaded with Incendiary Rockets, the Rocket Launcher may be used as an area denial tool to spread fire to an area to prevent movement through it. Regular rockets or High Velocity Rockets may also be used as an efficient, but expensive, weapon to be used against players, as its high damage usually means an instant kill.")
:SetIcon("materials/items/weapons/rocket_launcher.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_rpg")
:SetModel("models/weapons/darky_m/rust/w_rocketlauncher.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 40,
    "metal_pipe", 4
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(60)
:SetResearchCost(500)
:SetTier(2)
:Register()

gRust.ItemRegister("double_barrel_shotgun")
:SetName("Double Barrel Shotgun")
:SetDescription("The Double Barrel Shotgun is a lower tier, close ranged weapon capable of one-hitting enemies within its effective range. It's best used in conjunction with other, longer range guns and against only one or two enemies at a time since it can only shoot two shells before requiring a lengthy reload.")
:SetIcon("materials/items/weapons/dbarrel.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_dbarrel")
:SetModel("models/weapons/darky_m/rust/w_doublebarrel.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_fragments", 175,
    "metal_pipe", 2
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(40)
:SetResearchCost(125)
:SetTier(1)
:Register()

gRust.ItemRegister("pump_shotgun")
:SetName("Pump Shotgun")
:SetDescription("The Pump Shotgun is a mid-tier, close ranged weapon. With a magazine size of 6 and relatively fast firing rate it is ideal for close quarters raiding and combat. Its effective range varies only slightly on the ammo that is being used, but can be increased by using Slugs instead of Buckshot or Hand Made Shells.")
:SetIcon("materials/items/weapons/pump_shotgun.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_pumpshotgun")
:SetModel("models/weapons/darky_m/rust/w_sawnoffshotgun.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 15,
    "metal_pipe", 2,
    "metal_spring", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(40)
:SetResearchCost(125)
:SetTier(2)
:Register()

gRust.ItemRegister("spas_12_shotgun")
:SetName("Spas-12 Shotgun")
:SetDescription("Semi Automatic shotgun that fires much faster than the craftable Pump shotgun, losing to it in base damage. Houses 3 attachment slots and has an internal ammo capacity of 6 shots. Able to use any kind of shotgun ammo, including handmade shells.")
:SetIcon("materials/items/weapons/spas12.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_spas12")
:SetModel("models/weapons/darky_m/rust/w_spas12.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 20,
    "metal_pipe", 4,
    "metal_spring", 4
)
:Register()

gRust.ItemRegister("combat_knife")
:SetName("Combat Knife")
:SetDescription("The best tool for harvesting animal corpses quickly and efficiently. It's also one of the best melee weapons in the game due its fast swing rate and high damage - it can also be swung while sprinting, without slowing down the user.")
:SetIcon("materials/items/weapons/combat_knife.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_combatknife")
:SetModel("models/weapons/darky_m/rust/w_combatknife.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "metal_fragments", 25,
    "hq_metal", 1
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(15)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("grenade_launcher")
:SetName("Multiple Grenade Launcher")
:SetDescription("A 40MM six barrel, semi automatic grenade launcher. Explosive, Shotgun and Smoke 40mm grenades can all be loaded into the launcher.")
:SetIcon("materials/items/weapons/grenade_launcher.png")
:SetStack(1)
:SetCondition(true)
:SetWeapon("rust_grenadelauncher")
:SetModel("models/weapons/darky_m/rust/w_grenadelauncher.mdl")
:SetMaterial("Gun")
:AddToCategory("Weapons")
:SetRecipe(
    "hq_metal", 25,
    "metal_pipe", 4
)
:SetCraftable(false)
:Register()