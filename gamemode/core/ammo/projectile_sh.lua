ProjectileType = {
    Normal = 0,
    Explosive = 1,
    Incendiary = 2,
    HighVelocity = 3,
}

local PROJECTILE = {}
PROJECTILE.__index = PROJECTILE

gRust.AccessorFunc(PROJECTILE, "Damage")
gRust.AccessorFunc(PROJECTILE, "Position")
gRust.AccessorFunc(PROJECTILE, "Velocity")
gRust.AccessorFunc(PROJECTILE, "Gravity")
gRust.AccessorFunc(PROJECTILE, "Drag")
gRust.AccessorFunc(PROJECTILE, "ProjectileType")
--gRust.AccessorFunc(PROJECTILE, "Radius")
gRust.AccessorFunc(PROJECTILE, "Owner")
gRust.AccessorFunc(PROJECTILE, "Weapon")
gRust.AccessorFunc(PROJECTILE, "HitCallback")

function PROJECTILE:ExecuteFire()
    local pos = self:GetPosition()
    local vel = self:GetVelocity()
    if (self:GetProjectileType() == ProjectileType.HighVelocity) then
        vel = vel * 1.5
    end

    local deltaTime = CurTime() - self.LastFireTime
    self.LastFireTime = CurTime()

    local grav = self:GetGravity()
    local drag = self:GetDrag()
    local newPos = pos + vel * deltaTime
    local dragForce = self:GetDrag() * vel:LengthSqr()
    local newVel = vel + Vector(0, 0, -grav) * deltaTime
    
    self:SetPosition(newPos)
    self:SetVelocity(newVel)
    
    -- if (SERVER) then
    --     debugoverlay.Line(pos, self:GetPosition(), 5, Color(255, 0, 0))
    --     debugoverlay.Cross(pos, 5, 5, Color(255, 255, 0))        
    -- else
    --     debugoverlay.Line(pos, self:GetPosition(), 5, Color(0, 255, 0))
    --     debugoverlay.Cross(pos, 5, 5, Color(0, 255, 255))   
    -- end

    local traceData = {
        start = pos,
        endpos = newPos,
        filter = self:GetOwner(),
        mask = MASK_SHOT
    }

    self:GetOwner():LagCompensation(true)
    local tr = util.TraceLine(traceData)
    self:GetOwner():LagCompensation(false)

    local tr2 = util.TraceLine(traceData)

    if (!tr.Hit and tr2.Hit) then
        tr = tr2
    end

    if (CLIENT and IsFirstTimePredicted()) then
        local beamLength = (newPos - pos):Length()

        local effectdata = EffectData()
        effectdata:SetOrigin(newPos)
        effectdata:SetStart(first and LocalPlayer():GetViewModel():GetAttachment(1).Pos or pos)
        effectdata:SetMagnitude(beamLength / 10)
        effectdata:SetEntity(self:GetOwner():GetActiveWeapon())
        util.Effect("rust_556_tracer", effectdata)
    end

    if (tr.Hit) then
        local bullet = {}
        bullet.Num = 1
        bullet.Src = pos
        bullet.Dir = vel:GetNormalized()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force = 10000
        bullet.Damage = self:GetDamage()
        bullet.Attacker = self:GetOwner()
        local wep = self:GetWeapon()
        bullet.Callback = function(attacker, tr, dmg)
            dmg:SetDamageType(DMG_BULLET)
            dmg:SetAttacker(self:GetOwner())

            if (IsValid(wep)) then
                dmg:SetInflictor(wep)
            end
            
            if (self:GetHitCallback()) then
                self:GetHitCallback()(tr)
            end

            if (SERVER) then
                if (self:GetProjectileType() == ProjectileType.Explosive) then
                    -- util.BlastDamage(self:GetOwner(), self:GetOwner(), tr.HitPos, 100, 100)
                    -- util.ScreenShake(tr.HitPos, 100, 100, 1, 1000)
                    
                    -- local effectdata = EffectData()
                    -- effectdata:SetOrigin(tr.HitPos)
                    -- util.Effect("Explosion", effectdata)

                    dmg:ScaleDamage(1.5)
                elseif (self:GetProjectileType() == ProjectileType.Incendiary) then
                    -- TODO
                end
            end
        end
        self:GetOwner():FireBullets(bullet)

        self.IsRunning = false

        -- if (SERVER) then
        --     debugoverlay.Box(tr.HitPos, Vector(-5, -5, -5), Vector(5, 5, 5), 5, SERVER and Color(255, 0, 0) or Color(0, 255, 0))
        -- else
        --     debugoverlay.Sphere(tr.HitPos, 5, 5, CLIENT and Color(0, 255, 0) or Color(255, 0, 0))
        -- end
    end
end

local Projectiles = {}
function PROJECTILE:Fire()
    if (self.IsRunning) then return end

    self.IsRunning = true
    self.LastFireTime = CurTime()

    Projectiles[#Projectiles + 1] = self
end

function gRust.CreateProjectile()
    local projectile = setmetatable({}, PROJECTILE)
    projectile:SetGravity(9.81 * METERS_TO_UNITS)
    projectile:SetDrag(0.001)
    
    return projectile
end

hook.Add("PlayerTick", "gRust.RunProjectiles", function(pl, mv)
    if (!IsFirstTimePredicted()) then return end
    
    for _, projectile in ipairs(Projectiles) do
        if (projectile:GetOwner() == pl and projectile.IsRunning) then
            projectile:ExecuteFire()
        end
    end
end)

hook.Add("Tick", "gRust.CleanupProjectiles", function()
    for i = #Projectiles, 1, -1 do
        local projectile = Projectiles[i]
        if (!projectile.IsRunning) then
            table.remove(Projectiles, i)
        end
    end
end)