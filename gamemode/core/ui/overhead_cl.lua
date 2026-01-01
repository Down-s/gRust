local ENEMY_COLOR = Color(100, 100, 100)
local TEAM_COLOR = Color(138, 172, 52)
local OFFSET = Vector(0, 0, 82)
local MAX_DIST = 350000
local MAX_TEAMDIST = 1000000

surface.CreateFont("gRust.Overhead", {
    font = "Roboto Condensed Bold",
    size = 28,
    weight = 2000,
    antialias = true,
    shadow = false,
})

local tr = {}
hook.Add("HUDPaint", "gRust.PlayerOverhead", function()
    local pl = LocalPlayer()
    if (!pl:IsValid()) then return end
    
    for _, v in player.Iterator() do
        if (!v:IsValid() or !v:Alive() or v == pl or v:GetNoDraw()) then continue end

        local dist = pl:GetPos():DistToSqr(v:GetPos())

        if (gRust.TeamsIndex and gRust.TeamsIndex[v:SteamID64()]) then
            local pos = v:GetPos() + OFFSET
            pos = pos:ToScreen()

            if (pos.visible) then
                local alpha = math.Remap(dist, MAX_TEAMDIST - 20000, MAX_TEAMDIST, 255, 0)
                if (dist < MAX_DIST) then
                    surface.SetAlphaMultiplier(alpha / 255)
                    draw.SimpleTextOutlined(v:Name(), "gRust.Overhead", pos.x, pos.y - 24, TEAM_COLOR, 1, 1, 2, color_black)
                    surface.SetAlphaMultiplier(1)
                end

                if (dist < MAX_TEAMDIST) then
                    draw.SimpleTextOutlined("•", "gRust.Overhead", pos.x, pos.y, TEAM_COLOR, 1, 1, 2, color_black)
                end
            end
        else
            tr.start = pl:EyePos()
            tr.endpos = v:EyePos()
            tr.filter = {pl, v}
            if (dist < MAX_DIST and !util.TraceLine(tr).Hit) then
                local pos = v:GetPos() + OFFSET
                pos = pos:ToScreen()

                local alpha = math.Remap(dist, MAX_DIST - 20000, MAX_DIST, 255, 0)
                surface.SetAlphaMultiplier(alpha / 255)
                draw.SimpleTextOutlined(v:Name(), "gRust.Overhead", pos.x, pos.y - 24, ENEMY_COLOR, 1, 1, 2, color_black)
                draw.SimpleTextOutlined("•", "gRust.Overhead", pos.x, pos.y, ENEMY_COLOR, 1, 1, 2, color_black)
                surface.SetAlphaMultiplier(1)
            end
        end
    end
end)