gRust.ItemRegister("empty_can_of_beans")
:SetName("Empty Can of Beans")
:SetDescription("An empty can of beans are what's left after eating a can of beans. They can be smelted in a campfire to give metal fragments.")
:SetStack(10)
:SetIcon("materials/items/consumable/empty_can_of_beans.png")
:SetMaterial("Metal")
:SetRecipe(
    "metal_fragments", 20
)
:Register()

gRust.ItemRegister("empty_tuna_can")
:SetName("Empty Tuna Can")
:SetDescription("After consuming a tuna can, you'll be left with its empty remains. Empty tuna cans are used for either smelting them into a few Metal Fragments, or to make the Tuna Can Lamp.")
:SetStack(10)
:SetIcon("materials/items/consumable/empty_tuna_can.png")
:SetMaterial("Metal")
:SetRecipe(
    "metal_fragments", 16
)
:Register()

gRust.ItemRegister("supply_signal")
:SetName("Supply Signal")
:SetDescription("A purple smoke grenade that calls in an airdrop somewhere in a small radius around it. Can be found rarely in Military and Elite Crates.")
:SetStack(1)
:SetWeapon("rust_supplysignal")
:SetIcon("materials/items/throwable/supply_signal.png")
:SetMaterial("Gun")
:Register()