local PANEL = {}

AccessorFunc(PANEL, "Tier", "Tier")

local WIGGLE_ANIM_TIME = 0.35
local WIGGLE_ANIM_AMOUNT = 6
local WIGGLE_ANIM_SPEED = 6.0

function PANEL:Init()
    self:SetTier(0)
end

local TIER_COLORS = {
    {
        background = Color(113, 150, 56),
        text = Color(182, 231, 106)
    },
    {
        background = Color(0, 75, 150),
        text = Color(0, 180, 255)
    },
    {
        background = Color(230, 51, 0),
        text = Color(255, 145, 5)
    }
}

function PANEL:Paint(w, h)
    local tier = self:GetTier()
    local color = TIER_COLORS[tier]
    local horizontalPadding = 8 * gRust.Hud.Scaling
    local verticalPadding = 4 * gRust.Hud.Scaling

    if (color) then
        local txt = "WORKBENCH LEVEL " .. tier
        local font = "gRust.38px"
        
        surface.SetFont(font)
        local tw, th = surface.GetTextSize(txt)

        local wiggle = 0
        if (self.WiggleAnimTime and self.WiggleAnimTime > CurTime()) then
            local progress = (self.WiggleAnimTime - CurTime()) / WIGGLE_ANIM_TIME
            local mul = math.sin(progress * WIGGLE_ANIM_SPEED * math.pi)
            wiggle = mul * WIGGLE_ANIM_AMOUNT * gRust.Hud.Scaling
        end

        draw.RoundedBox(8, (w * 0.5 - (tw * 0.5) - horizontalPadding) + wiggle, h * 0.5 - (th * 0.5) - verticalPadding * 0.5, tw + (horizontalPadding * 2), th + verticalPadding, color.background)
        draw.SimpleText(txt, font, (w / 2 - tw / 2) + wiggle, h / 2 - th / 2, color.text)
    end
end

function PANEL:Wiggle()
    self.WiggleAnimTime = CurTime() + WIGGLE_ANIM_TIME
end

vgui.Register("gRust.WorkbenchTier", PANEL, "Panel")