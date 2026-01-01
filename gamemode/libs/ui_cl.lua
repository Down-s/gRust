local surface = surface
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV

local draw = draw
local draw_SimpleText = draw.SimpleText

local render = render
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture

local DefaultColor = gRust.Colors.Panel
local PanelMaterial = Material("ui/background.png", "noclamp smooth")
-- TODO: Technically this should be scaled by the screen size
local PanelMaterialScale = 1 / 768

function gRust.DrawPanel(x, y, w, h)
    surface_SetDrawColor(106, 104, 94, 75)
    surface_SetMaterial(PanelMaterial)
    surface_DrawTexturedRectUV(x, y, w, h, 0, 0, w * PanelMaterialScale, h * PanelMaterialScale)

    --surface_SetDrawColor(225, 225, 225, 125)
    --surface_SetMaterial(PanelMaterial)
    --surface_DrawTexturedRectUV(x, y, w, h, 0, 0, w * PanelMaterialScale, h * PanelMaterialScale)
end

function gRust.DrawPanelColored(x, y, w, h, col)
    surface_SetDrawColor(col)
    surface_SetMaterial(PanelMaterial)
    surface_DrawTexturedRectUV(x, y, w, h, 0, 0, w * PanelMaterialScale, h * PanelMaterialScale)
    
    --surface_SetDrawColor(225, 225, 225, 125)
    --surface_SetMaterial(PanelMaterial)
    --surface_DrawTexturedRectUV(x, y, w, h, 0, 0, w * PanelMaterialScale, h * PanelMaterialScale)
end

local BlurMat = Material("pp/blurscreen")
function gRust.DrawPanelBlurred(x, y, w, h, blur, color, panel)
    color = color or DefaultColor

    surface_SetDrawColor(color)
    surface_DrawRect(x, y, w, h)

    surface_SetDrawColor(255, 255, 255, 255)
    surface_SetMaterial(BlurMat)

    local offsetX, offsetY = IsValid(panel) and panel:LocalToScreen(0, 0)
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    for i = 1, 3 do
        BlurMat:SetFloat("$blur", (i / 3) * (blur or 6))
        BlurMat:Recompute()

        render_UpdateScreenEffectTexture()
        surface_DrawTexturedRect((x + offsetX) * -1, (y + offsetY) * -1, ScrW(), ScrH())
    end
end