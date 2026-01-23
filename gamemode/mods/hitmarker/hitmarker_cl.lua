local hitStart = 0
local hitDuration = 0.18

net.Receive("RustHitmarker", function()
    hitStart = CurTime()
end)

hook.Add("HUDPaint", "RustHitmarker_Draw", function()
    local t = CurTime() - hitStart
    if t > hitDuration then return end

    local alpha = 255 * (1 - (t / hitDuration))
    local x, y = ScrW() / 2, ScrH() / 2
    local size = 6

    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawLine(x - size, y - size, x - 2, y - 2)
    surface.DrawLine(x + size, y - size, x + 2, y - 2)
    surface.DrawLine(x - size, y + size, x - 2, y + 2)
    surface.DrawLine(x + size, y + size, x + 2, y + 2)
end)