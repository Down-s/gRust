function gRust.BlastDamage(pos, radius, damage, attacker, inflictor)
    local entities = ents.FindInSphere(pos, radius)
    for _, ent in ipairs(entities) do
        local tr1 = {}
        tr1.start = pos
        tr1.endpos = ent:GetPos()
        tr1.filter = inflictor
        tr1 = util.TraceLine(tr1)

        local tr2 = {}
        tr2.start = pos
        tr2.endpos = ent:LocalToWorld(ent:OBBCenter())
        tr2.filter = inflictor
        -- debugoverlay.Line(tr2.start, tr2.endpos, 25, Color(255, 0, 0), true)
        tr2 = util.TraceLine(tr2)
        
        if ((tr1.Entity ~= ent) and (tr2.Entity ~= ent)) then
            -- debugoverlay.Box(tr1.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 25, Color(0, 255, 0), true)
            -- debugoverlay.Box(tr2.HitPos, Vector(-2, -2, -2), Vector(2, 2, 2), 25, Color(0, 255, 0), true)
            continue
        end

        local dist = ent:GetPos():Distance(pos)
        -- Calculate damage, anything within 72 units gets full damage, anything radius units away gets no damage
        local minDist = 72
        local maxDist = radius
        local total = damage * (1 - math.Clamp((dist - minDist) / (maxDist - minDist), 0, 1))
        
        local dmg = DamageInfo()
        dmg:SetDamage(total)
        dmg:SetDamageType(DMG_BLAST)
        if (IsValid(attacker)) then
            dmg:SetAttacker(attacker)
        end
        if (IsValid(inflictor)) then
            dmg:SetInflictor(inflictor)
        end
        dmg:SetDamagePosition(inflictor:GetPos())

        ent:TakeDamageInfo(dmg)

        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:ApplyForceOffset((ent:GetPos() - pos):GetNormalized() * total * 1000000, pos)
        end
    end
end

local GROUND_MATERIALS = {
    [MAT_DIRT] = true,
    [MAT_SAND] = true,
    [MAT_SNOW] = true,
    [MAT_GRASS] = true,
    [MAT_SLOSH] = true,
}

function gRust.TracedGround(tr)
    if (!tr.HitWorld) then return false end
    if (tr.HitTexture ~= "**displacement**") then return false end
    if (!GROUND_MATERIALS[tr.MatType]) then return false end
    if (tr.HitNoDraw) then return false end
    if (tr.HitSky) then return false end

    return true
end

function gRust.IntToColor(num)
    local r = bit.band(bit.rshift(num, 16), 0xFF)
    local g = bit.band(bit.rshift(num, 8), 0xFF)
    local b = bit.band(num, 0xFF)
    return Color(r, g, b)
end

function gRust.CantorPair(a, b)
    return 0.5 * (a + b) * (a + b + 1) + b
end

function gRust.GetClosestSpawnPointTo(pos)
    local closest = nil
    local closestDist = math.huge
    for _, spawn in ipairs(ents.FindByClass("info_player_start")) do
        local dist = spawn:GetPos():Distance(pos)
        if (dist < closestDist) then
            closest = spawn
            closestDist = dist
        end
    end
    
    return closest
end