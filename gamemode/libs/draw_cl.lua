--
-- Text
--

function draw.SimpleTextMultiline(text, font, x, y, w, col, xalign, yalign)
    -- TODO: Create
end

--
-- Overlays
--

local Overlays = {}
function draw.Overlay(callback)
    table.insert(Overlays, callback)
end

hook.Add("PostRenderVGUI", "gRust.Draw.DrawOverlay", function()
    for _, v in ipairs(Overlays) do
        v()
    end

    Overlays = {}
end)

--
-- Misc
--

function draw.RoutedLine(x1, y1, x2, y2, col, thickness)
    thickness = thickness or 1

    if (x1 == x2) then
        surface.SetDrawColor(col)
        surface.DrawRect(x1 - thickness * 0.5, y1, thickness, y2 - y1)
        return
    end

    local ymid = (y1 + y2) * 0.5

    surface.SetDrawColor(col)
    surface.DrawRect(x1 - thickness * 0.5, y1, thickness, ymid - y1 + thickness * 0.5)
    surface.DrawRect(x2 - thickness * 0.5, ymid, thickness, y2 - ymid)

    if (x2 < x1) then
        surface.DrawRect(x2 - thickness * 0.5, ymid - thickness * 0.5, x1 - x2, thickness)
    else
        surface.DrawRect(x1, ymid - thickness * 0.5, x2 - x1 + thickness * 0.5, thickness)
    end
end