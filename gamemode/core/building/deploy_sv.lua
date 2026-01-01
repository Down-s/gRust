util.AddNetworkString("gRust.Deploy")
net.Receive("gRust.Deploy", function(len, pl)
    if (!pl:Alive()) then return end
    local slot = net.ReadUInt(3)
    local item = pl.Belt[slot]
    if (!item or !item:IsDeployable()) then return end
    if (item:GetCondition() and item:GetCondition() <= 0) then return end
    local ent = item:GetRegister():GetEntity()
    local entTable = scripted_ents.Get(ent)
    if (!entTable) then return end
    local deployable = entTable.Deploy
    if (!deployable) then return end
    local rotation = net.ReadUInt(9)
    if ((pl.NextDeploy or 0) > CurTime()) then return end
    pl.NextDeploy = CurTime() + 0.5

    local posOffset
    local angOffset
    if (net.BytesLeft() > 0) then
        posOffset = net.ReadVector()
        angOffset = net.ReadAngle()
    end

    local pos, ang, valid, reason, parentEnt, socket = pl:GetBuildTransform(deployable, rotation)
    if (!valid) then
        pl:ChatPrint(reason)
        return
    end

    local traceEntity = pl:GetEyeTrace().Entity

    local ent = ents.Create(ent)
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Spawn()
    ent.Item = item
    ent.OwnerID = pl:SteamID()

    if (IsValid(parentEnt)) then
        parentEnt:SetNWEntity("OccupiedEntity", ent)
        parentEnt:DeleteOnRemove(ent)
    end

    if (IsValid(traceEntity) and !IsValid(parentEnt) and !traceEntity:IsWorld()) then
        traceEntity:DeleteOnRemove(ent)
    end

    if (posOffset) then
        local lenSqr = posOffset:LengthSqr()
        if (lenSqr < 256) then
            ent:SetPos(ent:GetPos() + posOffset)
            ent:SetAngles(ent:GetAngles() + angOffset)
        end
    end

    if (!deployable.RequireSocket) then
        local mins, maxs = ent:GetModelBounds()
        mins = mins * 0.8
        maxs = maxs * 0.8
        local TRF = pos + ang:Forward() * mins.x + ang:Right() * mins.y + ang:Up() * maxs.z
        local BLB = pos + ang:Forward() * maxs.x + ang:Right() * maxs.y
        local BRB = pos + ang:Forward() * maxs.x + ang:Right() * mins.y
        local TLF = pos + ang:Forward() * mins.x + ang:Right() * maxs.y + ang:Up() * maxs.z

        local filter = {ent, traceEntity}
        local tr1 = util.TraceLine({
            start = BLB,
            endpos = TRF,
            filter = filter
        })

        local tr2 = util.TraceLine({
            start = BRB,
            endpos = TLF,
            filter = filter
        })

        if (tr1.Hit or tr2.Hit) then
            ent:Remove()
            pl:ChatPrint("Deployable is obstructed")
            return
        end
    end

    -- TODO: Find a fix for this not syncing on the client without a delay
    timer.Simple(1, function()
        if (ent.GetMaxHP and ent:GetMaxHP() > 0) then
            ent:SetHP(ent:GetMaxHP() * (item:GetCondition() or 1))
        end
    end)

    local snd = deployable:GetSound()
    if (snd and snd != "") then
        ent:EmitSound(snd)
    end

    local cback = deployable:GetOnDeployed()
    if (cback) then
        cback(ent, pl, parentEnt, item)
    end

    pl.Belt:Remove(slot, 1)
end)

util.AddNetworkString("gRust.Rotate")
net.Receive("gRust.Rotate", function(len, pl)
    if (!pl:Alive()) then return end
    if (pl:IsBuildBlocked()) then return end
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (!ent.CanRotate) then return end
    if (ent:GetPos():DistToSqr(pl:GetPos()) > 10000) then return end

    local rotation = ent.Deploy:GetRotate()
    if (!rotation or rotation == 0) then return end

    ent:SetAngles(ent:GetAngles() + Angle(0, rotation, 0))
end)