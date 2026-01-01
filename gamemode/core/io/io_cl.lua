gRust.IOConnections = gRust.IOConnections or {}

net.Receive("gRust.IO.AddConnection", function(len)
    local inEntity = net.ReadEntity()
    local inSlot = net.ReadUInt(4)
    local outEntity = net.ReadEntity()
    local outSlot = net.ReadUInt(4)
    local routeCount = net.ReadUInt(5)
    local routes = {}
    for i = 1, routeCount do
        routes[i] = net.ReadVector()
    end

    if (!IsValid(inEntity) || !IsValid(outEntity)) then return end
    if (!inEntity.IOEntity || !outEntity.IOEntity) then return end
    if (!inEntity.Inputs || !outEntity.Outputs) then return end
    
    local inData = inEntity.Inputs[inSlot]
    local outData = outEntity.Outputs[outSlot]
    
    if (!inData || !outData) then return end

    local fromPos = outEntity:LocalToWorld(outData.Pos)
    local toPos = inEntity:LocalToWorld(inData.Pos)

    local connection = {}
    connection[1] = inEntity:LocalToWorld(inData.Pos)
    for i = 1, routeCount do
        connection[i + 1] = routes[i]
    end
    connection[#connection + 1] = outEntity:LocalToWorld(outData.Pos)
    
    gRust.IOConnections[#gRust.IOConnections + 1] = connection
end)

local WIRE_MATERIAL = Material("cable/cable2")
hook.Add("PostDrawOpaqueRenderables", "gRust.IO.DrawConnections", function()
    local connections = gRust.IOConnections
    if (#connections == 0) then return end

    render.SetMaterial(WIRE_MATERIAL)
    for i = 1, #connections do
        local conn = connections[i]
        if (!conn) then continue end

        for j = 1, #conn - 1 do
            local from = conn[j]
            local to = conn[j + 1]
            if (!from || !to) then continue end

            render.DrawBeam(from, to, 1, 0, 1, Color(255, 255, 255, 255))
        end
    end
end)