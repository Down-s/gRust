local COMPASS_STRIP = Material("ui/compass_strip.png", "noclamp smooth")
local COMPASS_MASK = Material("ui/compass_mask.png", "noclamp smooth")
local COMPASS_ALPHA = 225

hook.Add("HUDPaint", "gRust.Compass", function()
	if (!gRust.Hud.ShouldDraw) then return end

	local pl = LocalPlayer()

	local scaling = gRust.Hud.Scaling
	local scrw, scrh = ScrW(), ScrH()
	local maskw = 1536 * scaling

	local w = 4096 * scaling
	local h = 64 * scaling
	local x = scrw * 0.5 - w * 0.5
	local y = 0

	local rot = (pl:EyeAngles().y - 90) * (w / 360)

	local maskx = scrw * 0.5 - maskw * 0.5
	local masky = 0

	gRust.StartMask()

	surface.SetDrawColor(255, 255, 255, COMPASS_ALPHA)
	surface.SetMaterial(COMPASS_STRIP)
	surface.DrawTexturedRect(x + rot, y, w, h)

	surface.SetDrawColor(255, 255, 255, COMPASS_ALPHA)
	surface.SetMaterial(COMPASS_STRIP)
	surface.DrawTexturedRect(x + rot + w, y, w, h)

	gRust.EndMask(maskx, masky, maskw, h, COMPASS_MASK)

	local pinw = 8 * scaling
	local pinh = 14 * scaling
	local pinThickness = math.Round(2 * scaling)

	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(scrw * 0.5 - pinw * 0.5, 0, pinw, pinh)

	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(scrw * 0.5 - pinw * 0.5 + pinThickness, 0, pinw - pinThickness * 2, pinh - pinThickness)
end)