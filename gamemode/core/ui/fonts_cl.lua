local function CreateFonts()
    --local scaling = ScrW() / 2560
    local scaling = gRust.Hud.Scaling
    for i = 16, 128, 2 do
        surface.CreateFont(string.format("gRust.%ipx", i), {
            font = "Roboto Condensed Bold",
            size = i * scaling,
            weight = 2000,
            antialias = true,
            shadow = false,
        })
    end
end

timer.Simple(0, function()
    CreateFonts()
end)

hook.Add("OnScreenSizeChanged", "gRust.CreateFonts", function()
    timer.Simple(0, function()
        CreateFonts()
    end)
end)