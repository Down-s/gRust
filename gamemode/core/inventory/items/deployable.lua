gRust.ItemRegister("tool_cupboard")
:SetName("Tool Cupboard")
:SetEntity("rust_toolcupboard")
:SetDescription("The Tool Cupboard is essential for any base because it prevents people who are not authorized from upgrading building blocks and placing and picking up deployables within a 25-meter radius (around 9 foundation blocks) from the cupboard. If you press 'E' on the cupboard you can authorize yourself so you are able to build in this area. If you hold 'E' on the cupboard you can clear the list of players authorized including yourself. Any player authorized from the cupboard will not be targeted by any flame turrets or shotgun traps within the cupboard's radius. Tool Cupboards can be locked with Key and Code Locks in order to disallow players from authorizing themselves without a passcode.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/tool_cupboard.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 1000
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("wooden_door")
:SetName("Wooden Door")
:SetEntity("rust_woodendoor")
:SetDescription("The Wooden Door is an early game building item that is made from wood and cheap to produce. Being the cheapest of all the doors, it is often used alongside a Lock to quickly secure a base. Its vulnerability to fire and weak explosive resistance makes the door a temporary solution to securing your base. Due to its flaws it should quickly be upgraded to a higher tier door such as Sheet Metal. The Wooden Door can take two kinds of locks the basic Lock and the Code Lock. To pick up the door, remove any locks, hold down the E (USE) key and select 'Pickup'. Note: There is currently a bug where a door sometimes can not be picked up until any type of Lock has been placed and removed.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/wooden_door.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 300
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("sheet_metal_door")
:SetName("Sheet Metal Door")
:SetEntity("rust_metaldoor")
:SetDescription("The Sheet Metal Door is the most common door found on bases due to its resistances to melee weapons and fire but relatively cheap cost to craft. Regardless, it is still relatively weak to explosives compared to its expensive indirect upgrade, the 'Armoured Door'.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/metal_door.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 150
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("armored_door")
:SetName("Armored Door")
:SetEntity("rust_armoreddoor")
:SetDescription("The Armored Door is the highest tier door and is the best option for base defense. If the door is put on a weaker door frame, the door frame will be targeted instead of the door itself. The door has a working hatch which allows you to see outside of the door and can be shot through in both directions.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/armored_door.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "hq_metal", 20,
    "gears", 5
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("furnace")
:SetName("Furnace")
:SetEntity("rust_furnace")
:SetDescription("The furnace is the cheapest item for smelting metal and sulfur ore.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/furnace.png")
:SetMaterial("Stone")
:AddToCategory("Items")
:SetRecipe(
    "stones", 200,
    "wood", 100,
    "low_grade_fuel", 50
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("key_lock")
:SetName("Key Lock")
:SetEntity("rust_keylock")
:SetDescription("Key locks are used to lock doors, hatches, storage boxes and tool cupboards. Once placed it should be locked by activating it and selecting \"Lock.\" For players other than the one who placed it to unlock it, they must have a key created by by the originating player. To remove a lock, unlock it and pick it up.")
:SetStack(1)
:SetIcon("materials/items/deployable/keylock.png")
:SetMaterial("Stone")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 75
)
:SetCraftable(true)
:SetCraftTime(15)
:Register()

gRust.ItemRegister("code_lock")
:SetName("Code Lock")
:SetEntity("rust_codelock")
:SetDescription("The code lock is used to lock doors, hatches, and storage crates. Players may set a new four-digit PIN if the lock is unlocked. Once locked, an LED on the keypad will change to red, indicating its status. Other players may attempt to gain access to a locked item by typing in a PIN in the keypad. If they are correct, a short beep will emit from the lock, and the player will subsequently have permanent access to the locked item (assuming the code isn't changed). If the player guesses incorrectly, a failure beep will play alongside an electric arc animation on the keypad, and the player will take increasing increments of damage until they wait long enough or die. Guest codes may be set on unlocked locks (make sure it's locked after setting the code!), which allows other players access to the locked item without the ability to unlock, remove, or change the code. Unlocked Code Locks may be removed or have a new password set by any player.")
:SetStack(1)
:SetIcon("materials/items/deployable/keypad.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 100
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("small_oil_refinery")
:SetName("Small Oil Refinery")
:SetEntity("rust_smalloilrefinery")
:SetDescription("The Small Oil Refinery is used to refine low grade fuel from crude oil. Each crude oil produces 3 low grade fuel. The cost of the refinery is quite expensive but can prove to be worth its cost in the long run.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/small_oil_refinery.png")
:SetMaterial("Metal")
:AddToCategory("Items")
:SetRecipe(
    "wood", 200,
    "metal_fragments", 500,
    "low_grade_fuel", 250
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(2)
:Register()

gRust.ItemRegister("large_wood_box")
:SetName("Large Wood Box")
:SetEntity("rust_largewoodbox")
:SetDescription("A Large Wood Box is your most popular and conventional way to store your belongings. Each box has enough storage for 48x separate items/stacks of items. They can have both locks and code locks placed on them to keep unwanted players at bay for a brief period. If destroyed, they will destroy a portion of their contents as well. Boxes can be placed on shelves to save space.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/large_wood_box.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "wood", 250,
    "metal_fragments", 50
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("wood_storage_box")
:SetName("Wood Storage Box")
:SetEntity("rust_woodstoragebox")
:SetDescription("A Wood Storage Box is a small box with the ability to store a maximum of 18 separate items or stacks of items inside of it. These can often times be used as a more space efficient way to store your items than the Large Wood Box, but can prove difficult to keep sorted as not all of your items are in one container. They can have both locks and codelocks placed on them to keep unwanted newmans at bay for a brief period. If destroyed, they will destroy a portion of their contents as well. Boxes can be placed on shelves to save space.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/wood_box.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "wood", 100
)
:SetCraftable(true)
:SetCraftTime(15)
:Register()

gRust.ItemRegister("wood_double_door")
:SetName("Wood Double Door")
:SetEntity("rust_wooddoubledoor")
:SetDescription("A Cheap door to secure your base. Its vulnerability to fire and weak explosive resistance makes the door a temporary solution to securing your base. Due to its flaws you should look at upgrading to a higher tier door such as Sheet Metal. The Wooden Door can take two kinds of locks the basic Key Lock and the Code Lock. To pick up the door, remove any locks and open, hold down the E (USE) key and select 'Pickup'.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/wood_double_door.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 350
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("sheet_metal_double_door")
:SetName("Sheet Metal Double Door")
:SetEntity("rust_metaldoubledoor")
:SetDescription("It has the same health as a sheet metal door. It requires double the materials, but allows for more space within your base. Ideal for loot rooms and other cramped areas.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/sheet_metal_double_door.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 200
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("armored_double_door")
:SetName("Armored Double Door")
:SetEntity("rust_armoreddoubledoor")
:SetDescription("The armored double door is the highest tier double door and is the best for base defense. Because of its high durability, if the door is placed in a weak wall frame, raiders may target the wall frame instead of the door itself. The door has working hatches and these hatches allow you to see outside of the door and can be shot through in both directions.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/armored_double_door.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "hq_metal", 25,
    "gears", 5
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(500)
:SetTier(3)
:Register()

gRust.ItemRegister("stone_barricade")
:SetName("Stone Barricade")
:SetEntity("rust_stonebarricade")
:SetDescription("Perfect for cover when engaging in gun fights. Decays rapidly when placed outside of building privilege.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/stone_barricade.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "stones", 100
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(20)
:Register()

gRust.ItemRegister("wooden_barricade_cover")
:SetName("Wooden Barricade Cover")
:SetEntity("rust_woodenbarricade")
:SetDescription("Perfect for cover when engaging in gun fights. Decays rapidly when placed outside of building privilege.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/wooden_barricade.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 250
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(20)
:Register()

gRust.ItemRegister("repair_bench")
:SetName("Repair Bench")
:SetEntity("rust_repairbench")
:SetDescription("Repair benches offer a cost-effective way to repair once-broken items back to a usable state. Each repair costs half of the original cost of a new version of the item, and does not use components. Every time an item is repaired, it loses some of it's maximum durability. This is represented with a red portion on the durability bar of the item. The Repair Bench can currently change the skin of any item you have (granted it HAS varying skins) to any skin that you own in your steam inventory.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/repair_bench.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "metal_fragments", 125
)
:SetCraftable(true)
:SetCraftTime(30)
:SetTier(1)
:Register()

gRust.ItemRegister("research_table")
:SetName("Research Table")
:SetEntity("rust_researchtable")
:SetDescription("The research table is a craftable deployable item that is used for researching obtained items for a price. This can be done by pressing the 'E' key, inserting your item and the required scrap metal to acquire a blueprint for use at the appropriate tier of workbench. (note: blueprint is guaranteed unlike previous versions of rust).")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/research_table.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "metal_fragments", 200,
    "scrap", 20
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("sleeping_bag")
:SetName("Sleeping Bag")
:SetEntity("rust_sleepingbag")
:SetDescription("A sleeping bag is a critical part of playing gRust. When placed, this item offers a respawn point directly on top of it. It can be named, given to a friend, or even be picked up by it's owner by using the interact key on it. After death, a menu will appear displaying your sleeping bags and beds by name and you can select whichever one you need. After being used, or being placed, there is a 5-minute cooldown period before being able to spawn on it. When possible, you should upgrade your base's respawn point to a bed, which has a drastically shorter cooldown timer.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/sleeping_bag.png")
:SetMaterial("Cloth")
:AddToCategory("Common")
:AddToCategory("Items")
:SetRecipe(
    "cloth", 30
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("bed")
:SetName("Bed")
:SetEntity("rust_bed")
:SetDescription("The bed can be used as a spawn point, just like the sleeping bag, but it has reduced cooldown use; instead of waiting 5 minutes like the Sleeping Bag, you just wait 2 minutes. You should have a bed if your base is upgraded and quite decent, because if you are getting raided and you have to respawn to defend your base, you cannot afford 5 minutes of respawn delay.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/bed.png")
:SetMaterial("Cloth")
:AddToCategory("Common")
:AddToCategory("Items")
:SetRecipe(
    "cloth", 60,
    "metal_fragments", 100,
    "sewing_kit", 2
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(1)
:Register()

gRust.ItemRegister("wooden_window_bars")
:SetName("Wooden Window Bars")
:SetEntity("rust_woodenwindowbars")
:SetDescription("The Wooden Window Bars are the lowest-tier window bars, provide little cover and deny entrance through windows. They are weaker over its reinforced and metal counterparts. Due to its weakness to fire damage and low health higher tier window bars are recommended.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/wood_window_bars.png")
:SetMaterial("Wood")
:AddToCategory("Construction")
:SetRecipe(
    "wood", 50
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(10)
:Register()

gRust.ItemRegister("strengthened_glass_window")
:SetName("Strengthened Glass Window")
:SetEntity("rust_strengthenedwindow")
:SetDescription("Bulleproof window glass, can block any incoming bullet projectile. Cannot block explosives.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/strengthened_glass_window.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 50
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(75)
:SetTier(2)
:Register()

gRust.ItemRegister("reinforced_glass_window")
:SetName("Reinforced Glass Window")
:SetEntity("rust_reinforcedwindow")
:SetDescription("The Reinforced Glass Window is now the highest-tier glass window. It replaced the Strengthened glass Window's spot for the highest HP window, and you are now unable to shoot through it. This makes it vital for loot rooms and external TCs. Not very useful for information gathering, as the viewing area is quite small and obstructed by thick bars.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/reinforced_glass_window.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "hq_metal", 4
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("workbench_level_1")
:SetName("Workbench Level 1")
:SetEntity("rust_tier1")
:SetDescription("The tier 1 Work Bench acts as a gateway towards crafting early game gear, including salvaged weapons and armor. You can find them at the Scientist Outpost and the Bandit Camp monuments.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/workbench_tier1.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "wood", 500,
    "metal_fragments", 100,
    "scrap", 50
)
:SetCraftable(true)
:SetCraftTime(30)
:Register()

gRust.ItemRegister("workbench_level_2")
:SetName("Workbench Level 2")
:SetEntity("rust_tier2")
:SetDescription("The tier 2 Work bench allows you to craft mid-game weapons, armor, and building parts while in the vicinity of the work bench. Uses the same amount of space like the Tier One Workbench")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/workbench_tier2.png")
:SetMaterial("Metal")
:AddToCategory("Items")
:SetRecipe(
    "metal_fragments", 500,
    "hq_metal", 2,
    "scrap", 500
)
:SetCraftable(true)
:SetCraftTime(45)
:SetTier(1)
:Register()

gRust.ItemRegister("workbench_level_3")
:SetName("Workbench Level 3")
:SetEntity("rust_tier3")
:SetDescription("The tier 3 Work Bench allows you to craft the highest tier of weapons, armor, and defenses.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/workbench_tier3.png")
:SetMaterial("Metal")
:AddToCategory("Items")
:SetRecipe(
    "metal_fragments", 1000,
    "hq_metal", 100,
    "scrap", 1250
)
:SetCraftable(true)
:SetCraftTime(45)
:SetTier(2)
:Register()

gRust.ItemRegister("chair")
:SetName("Chair")
:SetEntity("rust_chair")
:SetDescription("The chair is normally made for decorative purpose. But you can mount it to receive 100% comfort. Hover over it and press the E key to mount it and press the space bar to dismount it.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/chair.png")
:SetMaterial("Wood")
:AddToCategory("Items")
:SetRecipe(
    "wood", 50,
    "metal_fragments", 75
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(15)
:SetTier(1)
:Register()

gRust.ItemRegister("vending_machine")
:SetName("Vending Machine")
:SetEntity("rust_vendingmachine")
:SetDescription("The Vending Machine provides a safe way to make indirect trade with other players.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/vending_machine.png")
:SetMaterial("Metal")
:AddToCategory("Items")
:SetRecipe(
    "hq_metal", 20,
    "gears", 3
)
:SetCraftable(true)
:SetCraftTime(30)
:SetTier(1)
:Register()

gRust.ItemRegister("auto_turret")
:SetName("Auto Turret")
:SetEntity("rust_turret")
:SetDescription("The Auto Turret is a placed object used to detect enemies and shoot with its armed weapon. It detects enemies if the enemies were to reach its 180 degrees detection range or shoot the turret. The Auto Turret ignores the Tool Cupboard authorizations and only shoot people not in its authorize list so you and your team must authorize to it manually.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/auto_turret.png")
:SetMaterial("Gun")
:AddToCategory("Electrical")
:SetRecipe(
    "hq_metal", 10,
    "cctv_camera", 1,
    "targeting_computer", 1
)
:SetCraftable(true)
:SetCraftTime(45)
:SetResearchCost(500)
:SetTier(2)
:Register()

gRust.ItemRegister("metal_horizontal_embrasure")
:SetName("Metal Horizontal Embrasure")
:SetEntity("rust_embrasureh")
:SetDescription("Placed over a window it is used to reduce the size and grants the player more cover than the window. It is the counterpart to the Metal Vertical Embrasure providing more protection and the player's reducing vision from above and below the window.")
:SetStack(20)
:SetCondition(true)
:SetIcon("materials/items/deployable/metal_horizontal_embrasure.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 100
)
:SetCraftable(true)
:SetCraftTime(10)
:SetResearchCost(20)
:Register()

gRust.ItemRegister("metal_vertical_embrasure")
:SetName("Metal Vertical Embrasure")
:SetEntity("rust_embrasurev")
:SetDescription("Placed over a window it is used to reduce the size and grants the player more cover than the window. It is the counterpart to the Metal Horizontal Embrasure providing more protection and the player's reducing vision from the left and right sides of the window.")
:SetStack(20)
:SetCondition(true)
:SetIcon("materials/items/deployable/metal_vertical_embrasure.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 100
)
:SetCraftable(true)
:SetCraftTime(10)
:SetResearchCost(20)
:Register()

gRust.ItemRegister("metal_shop_front")
:SetName("Metal Shop Front")
:SetEntity("rust_metalshopfront")
:SetDescription("The metal shop front is quite useful for trading. The vendor can stand safely behind it without worrying about getting shot, as the glass is bulletproof. When the player on the inside and the player on the outside have put in items to make the desired trade, they both have to accept the deal for the items to be transferred.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/metal_shop_front.png")
:SetMaterial("Metal")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 250
)
:SetCraftable(true)
:SetCraftTime(10)
:SetTier(1)
:Register()

gRust.ItemRegister("homemade_landmine")
:SetName("Homemade Landmine")
:SetEntity("rust_landmine")
:SetDescription("A small explosive device which activates when a player steps off the pressure plate. The land mine can be deactivated by a friend by hold 'Use' button (default 'E') on it so that the player can step off safely.")
:SetStack(5)
:SetCondition(true)
:SetIcon("materials/items/deployable/homemade_landmine.png")
:SetMaterial("Gun")
:AddToCategory("Traps")
:SetRecipe(
    "metal_fragments", 50,
    "gun_powder", 30
)
:SetCraftable(true)
:SetCraftTime(20)
:SetTier(2)
:Register()

gRust.ItemRegister("garage_door")
:SetName("Garage Door")
:SetEntity("rust_garagedoor")
:SetDescription("The garage door is a form of lockable door which slides upward from the bottom when opened. It fits within a wall frame, like the double door, but opens much slower than any other type of door. It is, however, more durable than the sheet metal double door - making it an effective loot room door.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/deployable/garage_door.png")
:SetMaterial("Gun")
:AddToCategory("Construction")
:SetRecipe(
    "metal_fragments", 300,
    "gears", 2
)
:SetCraftable(true)
:SetCraftTime(30)
:SetResearchCost(30)
:SetTier(2)
:Register()