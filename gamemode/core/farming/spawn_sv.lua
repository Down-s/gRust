local SpawnEntities = {
    {
        Class = "rust_ore",
        Amount = 300,
        OnSpawn = function(ent)
            local TypeCounts = {}
            local ores = ents.FindByClass("rust_ore")
            for i = 1, #ores do
                local ore = ores[i]
                local oreType = ore.OreType
                TypeCounts[oreType] = (TypeCounts[oreType] or 0) + 1
            end

            local MinCount = math.huge
            local MinType = 1
            for k, v in pairs(TypeCounts) do
                if (v < MinCount) then
                    MinCount = v
                    MinType = k
                end
            end

            ent:SetOreType(MinType)
        end,
    },
    {
        Class = "rust_hemp",
        Amount = 150,
    }
}

-- Select a random point on the ground from around the map
local function GetRandomPos()
    local tr = {}
    tr.start = Vector(math.random(-13039, 13039), math.random(-12847, 12911), 3000)
    tr.endpos = Vector(tr.start.x, tr.start.y, -3000)
    tr = util.TraceLine(tr)

    if (!tr.Hit) then return end
    return tr
end

local NormalOffset = Angle(90, 0, 0)
function gRust.RespawnEntities()
    for i, v in ipairs(SpawnEntities) do
        local Amount = v.Amount - #ents.FindByClass(v.Class)
        if (Amount <= 0) then continue end
        
        for j = 1, Amount do            
            local tr = GetRandomPos()
            if (!tr) then continue end
            if (!gRust.TracedGround(tr)) then continue end
    
            local ent = ents.Create(v.Class)
            if (!IsValid(ent)) then return end
            
            ent:SetPos(tr.HitPos)
            ent:SetAngles(tr.HitNormal:Angle() + NormalOffset)
            ent:Spawn()

            if (v.OnSpawn) then
                v.OnSpawn(ent)
            end
        end
    end
end

hook.Add("InitPostEntity", "gRust.SpawnEntities", gRust.RespawnEntities)
timer.Create("gRust.SpawnEntities", 300, 0, gRust.RespawnEntities)