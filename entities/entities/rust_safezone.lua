ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:Initialize()
end

function ENT:StartTouch(pl)
    if (!pl:IsPlayer()) then return end
    pl:EnterSafeZone()
end

function ENT:EndTouch(pl)
    if (!pl:IsPlayer()) then return end
    pl:ExitSafeZone()
end