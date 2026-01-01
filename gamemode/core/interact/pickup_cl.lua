function gRust.PickupEntity(ent)
    if (!ent.PickupType) then return end

    net.Start("gRust.Pickup")
    net.WriteEntity(ent)
    net.SendToServer()
end