gRust.Deploy = gRust.Deploy or {}

local function DeployTrace()
    local pl = LocalPlayer()
    return util.TraceLine({
        start = pl:GetShootPos(),
        endpos = pl:GetShootPos() + pl:GetAimVector() * 175,
        filter = pl
    })
end

function gRust.StartDeploy(id)
    if (!LocalPlayer():Alive()) then return end
    local itemRegister = gRust.GetItemRegister(id)
    local ent = scripted_ents.Get(itemRegister:GetEntity())
    local deployData = ent.Deploy

    if (IsValid(gRust.Deploy.Entity)) then
        gRust.Deploy.Entity:Remove()
    end

    gRust.Deploy.Entity = ClientsideModel(deployData:GetModel())
    gRust.Deploy.Entity:SetMoveType(MOVETYPE_NONE)
    gRust.Deploy.Data = deployData
    gRust.Deploy.Rotation = deployData:GetInitialRotation() or 0

    gRust.Deploy.Entity.ChildModels = {}
    gRust.Deploy.Entity.AddModel = function(self, mdl)
        local ent = ClientsideModel(mdl)
        ent:SetPos(self:GetPos())
        ent:SetAngles(self:GetAngles())
        ent:SetMoveType(MOVETYPE_NONE)
        ent:SetMaterial("models/darky_m/rust_building/build_ghost")
        self.ChildModels[#self.ChildModels + 1] = ent
        
        return ent
    end
end

function gRust.StopDeploy()
    if (IsValid(gRust.Deploy.Entity)) then
        for _, ent in ipairs(gRust.Deploy.Entity.ChildModels) do
            ent:Remove()
        end

        gRust.Deploy.Entity:Remove()
    end

    gRust.Deploy.Data = nil
    gRust.Deploy.Entity = nil
    gRust.Deploy.Rotation = 0
end

function gRust.RequestDeploy()
    if (!gRust.Deploy.Data) then return end
    
    local ent = gRust.Deploy.Entity

    net.Start("gRust.Deploy")
        net.WriteUInt(gRust.Hotbar.SelectedSlot, 3)
        net.WriteUInt(gRust.Deploy.Rotation, 9)
        if (ent.LastValidPos and gRust.Deploy.Position and !gRust.Deploy.Data:GetRequireSocket()) then
            net.WriteVector(ent:GetPos() - gRust.Deploy.Position)
            net.WriteAngle(ent:GetAngles() - gRust.Deploy.Angle)
        end
    net.SendToServer()
end

function gRust.RotateEntity(ent)
    net.Start("gRust.Rotate")
    net.WriteEntity(ent)
    net.SendToServer()
end

local WasRotating = false
local WasDeploying = false
hook.Add("Think", "gRust.Deploy", function()
    local pl = LocalPlayer()
    if (IsValid(gRust.Deploy.Entity)) then
        local ent = gRust.Deploy.Entity
        local deployData = gRust.Deploy.Data
        local item = pl.Belt[gRust.Hotbar.SelectedSlot]
        local condition = item:GetCondition() or 1

        if (!pl:Alive() or !item or condition <= 0) then
            gRust.Deploy.Entity:Remove()
            return
        end

        local pos, ang, valid, reason = pl:GetBuildTransform(deployData, gRust.Deploy.Rotation)

        gRust.Deploy.Position = pos
        gRust.Deploy.Angle = ang

        if (input.IsButtonDown(KEY_R)) then
            if (!WasRotating) then
                local data = gRust.Deploy.Data
                gRust.Deploy.Rotation = (gRust.Deploy.Rotation + (data:GetRotate() or 0)) % 360
                WasRotating = true
            end
        else
            WasRotating = false
        end

        local trEntity = pl:GetEyeTrace().Entity
        if (trEntity.Deploy) then
            valid = true
            ent:SetPos(pos)
            ent:SetAngles(ang)
        elseif (!gRust.Deploy.Data:GetRequireSocket()) then
            local mins, maxs = ent:GetModelBounds()
            mins = mins * 0.9
            maxs = maxs * 0.9

            local TRF = pos + ang:Forward() * mins.x + ang:Right() * mins.y + ang:Up() * maxs.z
            local BLB = pos + ang:Forward() * maxs.x + ang:Right() * maxs.y
            local BRB = pos + ang:Forward() * maxs.x + ang:Right() * mins.y
            local TLF = pos + ang:Forward() * mins.x + ang:Right() * maxs.y + ang:Up() * maxs.z

            local filter = {ent, trEntity}
            local tr1 = util.TraceLine({
                start = BLB,
                endpos = TRF,
                filter = filter
            })
    
            local tr2 = util.TraceLine({
                start = TLF,
                endpos = BRB,
                filter = filter
            })
    
            if (!tr1.Hit and !tr2.Hit) then
                ent:SetPos(pos)
                ent:SetAngles(ang)
                ent.LastValidPos = pos
                ent.LastValidAng = ang
            elseif (ent.LastValidPos) then
                if (ent.LastValidPos:DistToSqr(pos) > 255) then
                    ent:SetPos(pos)
                    ent:SetAngles(ang)
    
                    valid = false
                    reason = "Obstructed"
                end
            else
                ent:SetPos(pos)
                ent:SetAngles(ang)
    
                valid = false
                reason = "Obstructed"
            end
        else
            ent:SetPos(pos)
            ent:SetAngles(ang)
        end

        gRust.Deploy.Valid = valid

        local mat = "models/darky_m/rust_building/build_ghost_disallow"
        if (valid) then
            mat = "models/darky_m/rust_building/build_ghost"
        end

        ent:SetMaterial(mat)
        for _, v in ipairs(ent.ChildModels) do
            v:SetMaterial(mat)
        end
    
        if (deployData.PreviewCallback) then
            deployData:PreviewCallback(gRust.Deploy.Entity)
        end

        if (input.IsButtonDown(MOUSE_LEFT) and !vgui.CursorVisible()) then
            if (not WasDeploying) then
                gRust.RequestDeploy()
                WasDeploying = true
            end
        else
            WasDeploying = false
        end
    end
end)