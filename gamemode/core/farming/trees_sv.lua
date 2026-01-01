gRust.CreateConfigValue("environment/tree.respawn", 180)
gRust.CreateConfigValue("farming/harvest.tree", 1)

local function ResetWeakSpot(ent)
    if (IsValid(ent)) then
        ent:RemoveAllDecals()
        ent.WeakSpot = nil
        ent.MarkerAngle = nil
        ent.BonusLevel = nil
    end
end

local function InitializeTree(ent)
    if (!ent:CreatedByMap()) then
        ent:PhysicsInitStatic(SOLID_VPHYSICS)
        ent:SetMoveType(MOVETYPE_NONE)
        ent:SetSolid(SOLID_VPHYSICS)
    end

    ent.DoMarker = function(self, pl)
        self:RemoveAllDecals()

        if (timer.Exists("gRust.TreeMarker." .. self:EntIndex())) then
            timer.Adjust("gRust.TreeMarker." .. self:EntIndex(), 45, 1, function()
                ResetWeakSpot(self)
            end)
        else
            timer.Create("gRust.TreeMarker." .. self:EntIndex(), 45, 1, function()
                ResetWeakSpot(self)
            end)
        end

        local ZOffset = math.random(-8, 8)
        local XAngle
        if (not self.MarkerAngle) then
            local ang = math.atan2(pl:GetPos().y - self:GetPos().y, pl:GetPos().x - self:GetPos().x)
            XAngle = math.deg(ang)
        else
            XAngle = self.MarkerAngle - 14
        end

        local trStart = self:GetPos() + Angle(0, XAngle, 0):Forward() * 64
        trStart.z = pl:EyePos().z + ZOffset
        local trEnd = self:GetPos()
        trEnd.z = pl:EyePos().z + ZOffset

        local tr = {}
        tr.start = trStart
        tr.endpos = trEnd
        tr.filter = {pl, game.GetWorld()}
        tr = util.TraceLine(tr)

        local pos1 = tr.HitPos + tr.HitNormal * 2
        local pos2 = tr.HitPos - tr.HitNormal * 2

        util.Decal("TreeCross", pos1, pos2, game.GetWorld())
        self:EmitSound("farming/tree_spray.wav")
        self.MarkerAngle = XAngle
        self.WeakSpot = tr.HitPos
        
        net.Start("gRust.TreeEffects")
            net.WriteVector(tr.HitPos)
        net.Send(pl)
    end
end

hook.Add("EntityTakeDamage", "gRust.TreeGather", function(ent, dmg)
    local pl = dmg:GetAttacker()
    if (IsValid(ent) and ent:IsTree() and IsValid(pl) and pl:IsPlayer()) then
        local weapon = pl:GetActiveWeapon()
        if (not IsValid(weapon)) then return end
        if (weapon ~= dmg:GetInflictor()) then return end
        if (not weapon.TreeGather or weapon.TreeGather == 0) then return end

        local HarvestAmount = weapon.TreeGather
        dmg:SetDamage(weapon.TreeGather)

        local weakSpot = ent.WeakSpot
        if (weakSpot) then
            if (dmg:GetDamagePosition():DistToSqr(weakSpot) < 144) then
                ent.BonusLevel = ent.BonusLevel and (ent.BonusLevel + 1) or 1
                dmg:ScaleDamage(1 + math.Clamp(ent.BonusLevel * 0.125, 0, 1))
                ent:DoMarker(pl)

                pl:EmitSound(string.format("farming/tree_x_hit%i.wav", math.random(1, 4)), 100, 100, 0.25)

                HarvestAmount = HarvestAmount * (1 + math.Clamp((ent.BonusLevel or 0) * 0.125, 0, 1))
            end
        else
            ent:DoMarker(pl)
        end

        ent:SetHealth(ent:Health() - dmg:GetDamage())
        if (ent:Health() <= 0) then
            local mdl = ent:GetModel()
            local pos = ent:GetPos()
            local ang = ent:GetAngles()
            local respawnTime = gRust.GetConfigValue("farming/tree.respawn", 180)
            timer.Simple(respawnTime, function()
                -- TODO: Don't respawn if there's a player nearby or a building in the way
                local tree = ents.Create("prop_dynamic")
                InitializeTree(tree)
                tree:SetModel(mdl)
                tree:SetPos(pos)
                tree:SetAngles(ang)
                tree:Spawn()
                tree:SetHealth(gRust.TreeModels[mdl])
            end)

            hook.Run("gRust.TreeHarvested", pl, ent)

            HarvestAmount = 250
            pl:EmitSound(string.format("farming/tree_fall_%i.wav", math.random(1, 4)), 140)
            ent:Remove()
        else
            local frac = math.ceil(ent:Health() / dmg:GetDamage())
            if (frac < 2) then
                ent:EmitSound(string.format("farming/tree_crack_med_%i.wav", math.random(1, 3)), 130, math.random(90, 110), 0.85)
            elseif (frac < 4) then
                ent:EmitSound(string.format("farming/tree_crack_small_%i.wav", math.random(1, 3)), 75, math.random(90, 110), 1)
            end
        end

        HarvestAmount = HarvestAmount * gRust.GetConfigValue("farming/harvest.tree", 1)

        local item = gRust.CreateItem("wood")
        item:SetQuantity(HarvestAmount)
        pl:AddItem(item, ITEM_HARVEST)

        return true
    end
end)

util.AddNetworkString("gRust.TreeEffects")
local ReloadTrees = function()
    for _, ent in ents.Iterator() do
        local treeHealth = gRust.TreeModels[ent:GetModel()]
        if (treeHealth) then
            ent:SetHealth(treeHealth)
            InitializeTree(ent)
        end
    end
end

hook.Add("InitPostEntity", "gRust.TreeGather", ReloadTrees)