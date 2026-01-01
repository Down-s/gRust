local MAX_SNAP_DISTANCE = 256 ^ 2
function gRust.GetClosestSocket(pos, deployable)
    local closestEnt = nil
    local closestSocket = nil
    local closestDist = MAX_SNAP_DISTANCE
    for _, ent in ents.Iterator() do
        if (ent:GetPos():DistToSqr(pos) < MAX_SNAP_DISTANCE) then
            if (!ent.gRust) then continue end
            local sockets = ent.Deploy and ent.Deploy.Sockets or ent.Sockets
            if (!sockets) then continue end

            for i, socket in ipairs(sockets) do
                local dist = ent:LocalToWorld(socket:GetPosition()):DistToSqr(pos)
                if (dist < closestDist) then
                    local hasConnectable = false
                    for k, v in ipairs(deployable.Sockets) do
                        if (v:CanConnect(socket)) then
                            hasConnectable = true
                            break
                        end
                    end

                    if (hasConnectable) then
                        closestDist = dist
                        closestEnt = ent
                        closestSocket = socket
                    end
                end
            end
        end
    end

    return closestSocket, closestEnt
end

local PLAYER = FindMetaTable("Player")
function PLAYER:GetBuildTrace()
    return util.TraceLine({
        start = self:GetShootPos(),
        endpos = self:GetShootPos() + self:GetAimVector() * 175,
        filter = self
    })
end

function PLAYER:GetBuildTransform(deployable, rotation)
    rotation = rotation or 0
    local tr = self:GetBuildTrace()
    local pos = tr.HitPos
    if (deployable.Sockets) then
        local socket, ent = gRust.GetClosestSocket(pos, deployable)
        if (socket) then
            local closestPos = nil
            local closestAng = nil
            local closestEnt = nil
            local closestDist = math.huge
            for k, v in ipairs(deployable.Sockets) do
                local dir = ent:LocalToWorldAngles(socket:GetAngle() - v:GetAngle())
                local newPos = ent:LocalToWorld(socket:GetPosition()) + dir:Forward() * v:GetPosition().x + dir:Right() * v:GetPosition().y + dir:Up() * v:GetPosition().z
                local newAng = ent:LocalToWorldAngles(socket:GetAngle() + v:GetAngleOffset())

                if (!v:CanConnect(socket)) then continue end
                
                local structureCenter = deployable.Center or vector_origin
                local checkCenter = newPos + dir:Forward() * structureCenter.x + dir:Right() * structureCenter.y + dir:Up() * structureCenter.z

                if (socket.CustomCheck) then
                    if (!socket:GetCustomCheck(ent, checkCenter, newAng, tr)) then continue end
                else
                    local tr = {}
                    tr.start = checkCenter
                    tr.endpos = self:EyePos()
                    tr.filter = self
                    tr = util.TraceLine(tr)
                    if (tr.Hit) then continue end
                end
    
                local dist = newPos:DistToSqr(pos)
                if (dist < closestDist) then
                    closestDist = dist
                    closestPos = newPos
                    closestAng = newAng
                    closestEnt = ent
                end
            end
    
            if (closestPos) then
                closestAng.y = closestAng.y + rotation
                local validPlacement, checkReason = deployable:GetCustomCheck(closestPos, closestAng, tr)
                
                if (!self:CanBuild()) then
                    validPlacement = false
                    checkReason = "You cannot build here"
                end

                return closestPos, closestAng, validPlacement, checkReason, closestEnt
            end
        end
    end

    local ang = Angle(0, self:EyeAngles().y + rotation, 0)
    local validPlacement, checkReason
    
    if (!deployable:GetRequireSocket()) then
        if (deployable:HasCustomCheck()) then
            validPlacement, checkReason = deployable:GetCustomCheck(pos, ang, tr)
        else
            if (tr.Hit && (tr.Entity:IsWorld() || tr.Entity.DeploySurface)) then
                pos = tr.HitPos + tr.HitNormal * 0.1
                if (!tr.Entity:IsWorld()) then
                    ang.y = tr.Entity:GetAngles().y
                else
                    ang = tr.HitNormal:Angle() + Angle(90, 0, 0)
                end
                ang:RotateAroundAxis(ang:Up(), rotation + (self:EyeAngles().y - tr.Entity:GetAngles().y))
                
                if (tr.HitNormal.z < 0.7) then
                    validPlacement = false
                    checkReason = "Surface is too steep"
                else
                    validPlacement = tr.Hit
                end
            else
                validPlacement = false
                checkReason = "Not a valid surface"
            end
        end
    else
        validPlacement = false
        checkReason = "No socket found"
    end

    if (!self:CanBuild()) then
        validPlacement = false
        checkReason = "You cannot build here"
    end
    
    return pos, ang, validPlacement, checkReason
end