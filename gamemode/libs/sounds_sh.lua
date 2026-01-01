function gRust.CreateSound(name, path, volume, pitch, level)
    sound.Add({
        name = name,
        channel = CHAN_STATIC,
        volume = volume,
        level = level or 75,
        pitch = pitch,
        sound = path,
        loop = loop
    })
end

function gRust.PlaySound(snd)
    if (SERVER) then return end
    if (!snd || snd == "") then return end
    
    LocalPlayer():EmitSound(snd)
end

-- UI Sounds
gRust.CreateSound("ui.blip", "ui/blip.wav", 0.1, 100)
gRust.CreateSound("ui.select", "ui/piemenu/piemenu_select.wav", 0.1, 100)
gRust.CreateSound("ui.notify", "ui/notify.wav", 0.5, 100)

-- Flare
gRust.CreateSound("flare.hit", "farming/flare_hit.wav", 1.0, 100)
gRust.CreateSound("flare.finish", "farming/flare_finish.wav", 1.0, 100)

-- Pie Menu
gRust.CreateSound("piemenu.blip", "ui/blip.wav", 0.085, 100)
gRust.CreateSound("piemenu.open", "ui/piemenu/piemenu_open.wav", 0.1, 100)
gRust.CreateSound("piemenu.close", "ui/piemenu/piemenu_close.wav", 0.1, 100)
gRust.CreateSound("piemenu.select", "ui/piemenu/piemenu_select.wav", 0.1, 100)

-- Box
gRust.CreateSound("box.open", "inventory/box_open.wav", 0.3, 100)
gRust.CreateSound("box.close", "inventory/box_close.wav", 0.2, 100)

-- Recycler
gRust.CreateSound("recycle.start", "farming/recycle_start.wav", 0.3, 100)
gRust.CreateSound("recycle.stop", "farming/recycle_stop.wav", 1.0, 100)
gRust.CreateSound("recycler.open", "farming/recycler_open.wav", 0.3, 100)
gRust.CreateSound("recycler.close", "farming/recycler_close.wav", 0.3, 100)

-- Furnace
gRust.CreateSound("furnace.start", "farming/furnace_ignite.wav", 1.0, 100)
gRust.CreateSound("furnace.stop", "farming/furnace_extinguish.wav", 1.0, 100)

-- Repair Bench
gRust.CreateSound("repairbench.open", "farming/repair_bench_open.wav", 0.3, 100)
gRust.CreateSound("repairbench.close", "farming/repair_bench_close.wav", 0.3, 100)

-- Research Table
gRust.CreateSound("research.start", "farming/research_item.wav", 1.0, 100)
gRust.CreateSound("research.success", "farming/repair_bench_close.wav", 1.0, 100)
gRust.CreateSound("researchtable.open", "farming/research_table_open.wav", 0.3, 100)
gRust.CreateSound("researchtable.close", "farming/research_table_close.wav", 0.3, 100)

-- Toolbox
gRust.CreateSound("toolbox.open", "inventory/crate_tools_open.wav", 0.4, 100)
gRust.CreateSound("toolbox.close", "inventory/crate_tools_close.wav", 0.4, 100)

-- Tool Cupboard
gRust.CreateSound("toolcupboard.open", "inventory/tool_cupboard_open.wav", 0.4, 100)
gRust.CreateSound("toolcupboard.close", "inventory/tool_cupboard_close.wav", 0.4, 100)

-- Combat
gRust.CreateSound("combat.hitmarker", "combat/hitmarker.wav", 1.0, 100)
gRust.CreateSound("combat.headshot", "combat/headshot.wav", 1.0, 100)

-- Item
gRust.CreateSound("item.break", "player/item_break.wav", 1.0, 100)

-- Locks
gRust.CreateSound("keylock.lock", "doors/keylock_lock.wav")
gRust.CreateSound("keylock.unlock", "doors/keylock_unlock.wav")
gRust.CreateSound("codelock.lock", "doors/keypad_lock.wav")
gRust.CreateSound("codelock.unlock", "doors/keypad_beep.wav")
gRust.CreateSound("codelock.beep", "doors/keypad_beep.wav")
gRust.CreateSound("codelock.noauth", "doors/keypad_noauth.wav")
gRust.CreateSound("codelock.shock", "doors/keypad_shock.wav")
gRust.CreateSound("codelock.authorize", "doors/keypad_setcode.wav")

-- Farming
gRust.CreateSound("farming.pick", "farming/pick.wav", 0.5, 100)

-- Tech Tree
gRust.CreateSound("techtree.unlock", "ui/techtree/item_unlock.wav", 1.0, 100)

-- Electricity
gRust.CreateSound("wiretool.place", "electrical/wiretool_place.wav", 1.0, 100)

-- Casino
gRust.CreateSound("casino.win", "casino/win.wav", 1.0, 100)
gRust.CreateSound("casino.lose", "farming/furnace_extinguish.wav", 1.0, 100)
gRust.CreateSound("casino.accent_1", "casino/wheel_spin_accent_1.wav", 1.0, 100)
gRust.CreateSound("casino.accent_2", "casino/wheel_spin_accent_2.wav", 1.0, 100)
gRust.CreateSound("casino.accent_3", "casino/wheel_spin_accent_3.wav", 1.0, 100)
gRust.CreateSound("casino.accent_4", "casino/wheel_spin_accent_4.wav", 1.0, 100)
gRust.CreateSound("casino.spin_start", "casino/wheel_spin_start.wav", 1.0, 100)
gRust.CreateSound("casino.loop", "casino/wheel_spin_loop.wav", 1.0, 100)

-- Vending Machine
gRust.CreateSound("vendingmachine.open", "inventory/vending_machine_open.wav", 0.3, 100)
gRust.CreateSound("vendingmachine.purchase", "farming/vending_machine_purchase.wav", 1.0, 100)
gRust.CreateSound("vendingmachine.deploy", "farming/vending_machine_deploy.wav", 0.5, 100)

-- Landmine
gRust.CreateSound("landmine.trigger", "entity/landmine_trigger.wav", 1.0, 100)
gRust.CreateSound("landmine.explode", "entity/landmine_explode.wav", 1.0, 100)

-- Garage Door
gRust.CreateSound("garagedoor.open", "doors/garage_door_open.wav", 1.0, 100)
gRust.CreateSound("garagedoor.stop", "doors/garage_door_stop.wav", 1.0, 100)
gRust.CreateSound("garagedoor.lock", "doors/garage_door_shut.wav", 1.0, 100)
gRust.CreateSound("garagedoor.loop", "doors/garage_door_loop.wav", 1.0, 100)