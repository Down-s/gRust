hook.Add("HUDPaint", "ESP", function()
    if not LocalPlayer():IsAdmin() then return end
    if not LocalPlayer():GetNWBool("Admin_ESP", false) then return end
    local tab = {}
    for k, v in pairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        tab[k] = v
    end

    halo.Add(tab, Color(0, 0, 255), 1, 1, 1, true, true)
    for k, v in pairs(tab) do
        local Position = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
        draw.DrawText(v:Name(), "Default", Position.x, Position.y, Color(255, 255, 255, 255), 1)
    end
end)

hook.Add("PostDrawTranslucentRenderables", "ESP_3D", function()
    if not LocalPlayer():IsAdmin() then return end
    if not LocalPlayer():GetNWBool("Admin_ESP", false) then return end
    local tab = {}
    for k, v in pairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        tab[k] = v
    end

    for k, v in pairs(tab) do
        local pos = v:GetPos() + Vector(0, 0, 0)
        local ang = (LocalPlayer():GetPos() - pos):Angle()
        ang:RotateAroundAxis(ang:Right(), -90)
        ang:RotateAroundAxis(ang:Up(), 90)
        cam.Start3D2D(pos, ang, 1)
        surface.SetDrawColor(255, 255, 255, 128)
        surface.DrawOutlinedRect(-10, -70, 15, 90)
        draw.SimpleText(v:Nick(), "DermaDefault", -20, -150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)