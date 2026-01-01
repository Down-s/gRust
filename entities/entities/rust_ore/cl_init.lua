include("shared.lua")

local FLARE_DISTANCE = (256) ^ 2
local FLARE_MATERIAL = Material("decals/flare_ore.png")
local FLARE_SIZE = 125000
local FLARE_SIZE_HALF = FLARE_SIZE / 2
local tr = {}
function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos()
    local distSq = LocalPlayer():GetPos():DistToSqr(pos)
    if (distSq < FLARE_DISTANCE) then
        local flarePos = self:GetWeakSpot()
		local tr = {}
		tr.start = LocalPlayer():GetShootPos()
		tr.endpos = flarePos
		tr.filter = LocalPlayer()
		if (util.TraceLine(tr).Hit) then return end

		cam.Start2D(flarePos, Angle(0, ang, 0), 0.1)
			local pos = flarePos:ToScreen()
			local size = math.Clamp(FLARE_SIZE / math.sqrt(distSq), 0, FLARE_SIZE)

			surface.SetMaterial(FLARE_MATERIAL)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRectRotated(pos.x, pos.y, size, size, CurTime() * 35)
		cam.End2D()
    end
end