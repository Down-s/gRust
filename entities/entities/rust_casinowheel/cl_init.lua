include("shared.lua")

function ENT:Draw()
    local m = Matrix()

    if (self.SpinStart) then
        local t = CurTime() - self.SpinStart
        t = math.min(t, self.SpinEnd)
        local angle = self:GetAngleAtTime(t, self.InitialSpeed, 360)
        m:Rotate(Angle(0, angle, 0))
        self:EnableMatrix("RenderMultiply", m)
    end

    self:DrawModel()
end

function ENT:Think()
    if (self.SpinStart) then
        local t = CurTime() - self.SpinStart
        t = math.min(t, self.SpinEnd)
        local angle = self:GetAngleAtTime(t, self.InitialSpeed, 360)
        
        local segment = self:GetSegment(angle)
        if ((!self.LastSegment or segment != self.LastSegment) and (CurTime() - (self.LastSegmentTime or 0) > 0.05)) then
            self:EmitSound("casino.accent_" .. math.random(1, 4), 75, 100, 1, CHAN_STATIC)
            self.LastSegment = segment
            self.LastSegmentTime = CurTime()
        end
    end
end

net.Receive("gRust.SpinWheel", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end

    local angle = net.ReadFloat()

    ent.InitialSpeed = ent:GetInitialSpeed(angle)
    ent.EndAngle = angle
    ent.SpinStart = CurTime()
    ent.SpinEnd = ent:GetEndTime(ent.InitialSpeed)

    ent:EmitSound("casino.spin_start", 100, 100, 1.0, CHAN_STATIC)
end)