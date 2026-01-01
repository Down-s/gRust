gRust.IOConnections = gRust.IOConnections or {}

gRust.CreateConfigValue("electricity/wire.maxlength", 500, true)
gRust.CreateConfigValue("electricity/wire.maxroutes", 5, true)

util.AddNetworkString("gRust.IO.AddConnection")
function gRust.CreateIOConnection(inEntity, inSlot, outEntity, outSlot, routes)
    if (!IsValid(inEntity) || !IsValid(outEntity)) then return end
    if (!inEntity.IOEntity || !outEntity.IOEntity) then return end
    if (!inEntity.Inputs || !outEntity.Outputs) then return end
    if (!inEntity.Inputs[inSlot] || !outEntity.Outputs[outSlot]) then return end

    inEntity.InConnections = inEntity.InConnections or {}
    outEntity.OutConnections = outEntity.OutConnections or {}

    inEntity.InConnections[inSlot] = {
        Entity = outEntity,
        Slot = outSlot
    }

    outEntity.OutConnections[outSlot] = {
        Entity = inEntity,
        Slot = inSlot
    }

    net.Start("gRust.IO.AddConnection")
        net.WriteEntity(inEntity)
        net.WriteUInt(inSlot, 4)
        net.WriteEntity(outEntity)
        net.WriteUInt(outSlot, 4)
        net.WriteUInt(#routes, 5)
        for i = 1, #routes do
            net.WriteVector(routes[i])
        end
    net.Broadcast()

    gRust.IOConnections[#gRust.IOConnections + 1] = {
        InEntity = inEntity,
        InSlot = inSlot,
        OutEntity = outEntity,
        OutSlot = outSlot,
        Routes = routes
    }
end

-- util.AddNetworkString("gRust.IO.CreateConnection")
-- net.Receive("gRust.IO.CreateConnection", function(len, pl)
--     if (true) then return end
--     -- TODO: Check if player is allowed to do this

--     local inEnt = net.ReadEntity()
--     local inSlot = net.ReadUInt(4)
--     local outEnt = net.ReadEntity()
--     local outSlot = net.ReadUInt(4)
--     local routeCount = net.ReadUInt(5)
--     local routes = {}
--     for i = 1, routeCount do
--         local pos = net.ReadVector()
--         table.insert(routes, pos)
--     end

--     gRust.CreateIOConnection(inEnt, inSlot, outEnt, outSlot, routes)
-- end)

-- TODO: Network to newly connected players