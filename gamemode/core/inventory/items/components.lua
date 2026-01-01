gRust.ItemRegister("metal_spring")
:SetName("Metal Spring")
:SetDescription("An uncommon component used for the construction of almost every gun. It may be found with moderate frequency from crates, and uncommonly from barrels. Generally speaking, guns of higher tiers will require more Metal Springs, while low tier guns (Semi Auto Pistol, Rifle) require only one.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/spring.mdl")
:SetIcon("materials/items/resources/metal_spring.png")
:SetMaterial("Spring")
:AddToCategory("Components")
:AddToCategory("Other")
:SetRecycleScrap(10)
:SetRecipe(
    "hq_metal", 2,
    "scrap", 50
)
:SetCraftable(true)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("semi_automatic_body")
:SetName("Semi Automatic Body")
:SetDescription("Semi Automatic Bodies are components used in the crafting of Semi-Auto Pistols and Semi-Auto Rifles. They can be found quite commonly and can be recycled for a good profit.")
:SetStack(10)
:SetModel("models/darky_m/rust/worldmodels/semibody.mdl")
:SetIcon("materials/items/resources/semi_auto_body.png")
:SetMaterial("Gun")
:AddToCategory("Components")
:SetRecycleScrap(15)
:SetRecipe(
    "hq_metal", 4,
    "metal_fragments", 150
)
:Register()

gRust.ItemRegister("road_signs")
:SetName("Road Signs")
:SetDescription("Road signs are a component used in the crafting of the mid-tier armors Road Sign Jacket, and Road Sign Kilt, along with crafting the salvaged cleaver. Also good as a source of scrap throughout the game.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/roadsigns.mdl")
:SetIcon("materials/items/resources/road_signs.png")
:SetMaterial("Metal")
:AddToCategory("Other")
:SetRecycleScrap(5)
:SetRecipe(
    "hq_metal", 2,
    "scrap", 20
)
:SetCraftable(true)
:SetCraftTime(1)
:SetResearchCost(75)
:SetTier(3)
:Register()

gRust.ItemRegister("sheet_metal")
:SetName("Sheet Metal")
:SetDescription("An uncommon component that can be recycled into Metal Fragments and High Quality Metal, or used in the crafting of Heavy Plate armor pieces. It can be found in crates and barrels.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/sheetmetal.mdl")
:SetIcon("materials/items/resources/sheet_metal.png")
:SetMaterial("Metal")
:AddToCategory("Components")
:SetRecycleScrap(8)
:SetRecipe(
    "metal_fragments", 200,
    "hq_metal", 2
)
:Register()

gRust.ItemRegister("metal_pipe")
:SetName("Metal Pipe")
:SetDescription("Pipes are a relatively common component that are used for guns, salvaged tools, and rocket launchers and rockets. They can be somewhat abundant early game until you find the need to craft rockets, and then get consumed very quickly.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/metalPipe.mdl")
:SetIcon("materials/items/resources/metal_pipe.png")
:SetMaterial("Spring")
:AddToCategory("Components")
:AddToCategory("Other")
:SetRecycleScrap(5)
:SetRecipe(
    "hq_metal", 2,
    "scrap", 20
)
:SetCraftable(true)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("electric_fuse")
:SetName("Electric Fuse")
:SetDescription("The Electric Fuse is a required item for monument puzzle rooms. It must be placed in the fuse box in order to power the keycard lock. Recycling the electric fuse also gives some quick scrap.")
:SetStack(1)
:SetCondition(true)
:SetIcon("materials/items/resources/electric_fuse.png")
:SetMaterial("Metal")
:SetRecycleScrap(20)
:Register()

gRust.ItemRegister("gears")
:SetName("Gears")
:SetDescription("Gears are used in the crafting of various desirable (building) supplies involved in base defense, such as traps, gates, and first and foremost armored & garage doors, which are significantly stronger than sheet metal doors. These are hard to come by in large quantities and are one of the more sought after items in the game.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/gears.mdl")
:SetIcon("materials/items/resources/gears.png")
:SetMaterial("Metal")
:AddToCategory("Components")
:AddToCategory("Other")
:SetRecycleScrap(10)
:SetRecipe(
    "metal_fragments", 25,
    "scrap", 100
)
:SetCraftable(true)
:SetCraftTime(1)
:SetResearchCost(125)
:SetTier(3)
:Register()

gRust.ItemRegister("metal_blade")
:SetName("Metal Blade")
:SetDescription("Metal blades are common components that can be found in barrels near roads or at monuments. They are used to craft some tools and melee weapons. If you don't have any use for the items you can craft with these it would be wise to recycle them for two scrap.")
:SetStack(20)
:SetModel("models/darky_m/rust/worldmodels/metalBlade.mdl")
:SetIcon("materials/items/resources/metal_blade.png")
:SetMaterial("Metal")
:AddToCategory("Components")
:AddToCategory("Other")
:SetRecycleScrap(2)
:SetRecipe(
    "metal_fragments", 30,
    "scrap", 10
)
:SetCraftable(true)
:SetCraftAmount(1)
:SetCraftTime(1)
:SetResearchCost(75)
:SetTier(2)
:Register()

gRust.ItemRegister("rifle_body")
:SetName("Rifle Body")
:SetDescription("A rare component which is used for crafting late-game rifles. It can only be found in military and elite crates.")
:SetStack(10)
:SetModel("models/darky_m/rust/worldmodels/rifle_body.mdl")
:SetIcon("materials/items/resources/rifle_body.png")
:SetMaterial("Gun")
:AddToCategory("Components")
:AddToCategory("Components")
:SetRecycleScrap(25)
:SetRecipe(
    "hq_metal", 4
)
:Register()

gRust.ItemRegister("smg_body")
:SetName("SMG Body")
:SetDescription("A rare component which is used for crafting submachine guns. It can only be found in military and elite crates.")
:SetStack(10)
:SetModel("models/darky_m/rust/worldmodels/smgbody.mdl")
:SetIcon("materials/items/resources/smg_body.png")
:SetMaterial("Gun")
:AddToCategory("Components")
:SetRecycleScrap(15)
:SetRecipe(
    "hq_metal", 4
)
:Register()