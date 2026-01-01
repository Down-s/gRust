-- Colors
local PIEMENU_COLOR = Color(251, 235, 224)
local PIEMENU_INVALID_COLOR = Color(218, 208, 199)
local INVALID_ICON_COLOR = Color(209, 199, 190)
local DEFAULT_WEDGE_COLOR = Color(205, 64, 42)
local TITLE_COLOR = Color(255, 255, 255)
local DESCRIPTION_COLOR = Color(200, 200, 200, 175)
local FOOTER_COLOR = Color(150, 150, 150, 175)
local ICON_COLOR = Color(167, 56, 39)

-- Offsets
local TITLE_OFFSET = -36
local DESCRIPTION_OFFSET = 40
local FOOTER_OFFSET = 220
local ICON_OFFSET = 180

-- Icon sizes
local ICON_SIZE = 100
local OUTER_ICON_SIZE = 52

-- Animations
local OPEN_ANIM_TIME = 0.1
local CLOSE_ANIM_TIME = 0.2
local SWITCH_ANIM_TIME = 0.2
local ROTATE_ANIM_TIME = 0.065

-- Blur
local BLUR_MATERIAL = Material("pp/blurscreen")
local BLUR_AMOUNT = 12

--
-- Pie Menu Option Object
--

local PIEMENU_OPTION = {}
PIEMENU_OPTION.__index = PIEMENU_OPTION

gRust.AccessorFunc(PIEMENU_OPTION, "Title")
gRust.AccessorFunc(PIEMENU_OPTION, "Description")
gRust.AccessorFunc(PIEMENU_OPTION, "Footer")
gRust.AccessorFunc(PIEMENU_OPTION, "Icon")
gRust.AccessorFunc(PIEMENU_OPTION, "Callback")
gRust.AccessorFunc(PIEMENU_OPTION, "Color")

function PIEMENU_OPTION:SetCondition(hide, condition)
    self.HideCondition = hide
    self.Condition = condition
    return self
end

function PIEMENU_OPTION:GetCondition()
    if (self.Condition) then
        return self.Condition()
    end

    return true
end

--
-- Pie Menu Object
--

gRust.PieMenu = gRust.PieMenu or {}

local PIEMENU = {}
PIEMENU.__index = PIEMENU

function PIEMENU:CreateOption()
    local option = {}
    setmetatable(option, PIEMENU_OPTION)
    option:SetColor(Color(205, 64, 42))
    table.insert(self.Options, option)
    return option
end

function PIEMENU:Init()
    self.Options = {}
    self.AnimMatrix = Matrix()
    self.Index = 1
    self.LastIndex = 1
end

function PIEMENU:GetRotation()
    return self.Rotation or 0
end

function PIEMENU:Open()
    gRust.PieMenu.Instance = self
    gui.EnableScreenClicker(true)
    gRust.PlaySound("piemenu.open")
    
    self.OpenTime = CurTime()
    self.CloseTime = nil
    self.Success = false

    local options = {}
    for k, v in pairs(self.Options) do
        if (!v.HideCondition or v:GetCondition()) then
            table.insert(options, v)
        end
    end

    self.AvailableOptions = options
end

function PIEMENU:Close(suppressSound)
    if (!gRust.PieMenu.Instance) then return end
    if (gRust.PieMenu.Instance != self) then return end
    if (self.CloseTime) then return end
    
    gui.EnableScreenClicker(false)
    
    if (!suppressSound) then
        gRust.PlaySound("piemenu.close")
    end

    self.CloseTime = CurTime()
    self.OpenTime = nil

    self.OpenProgress = 1
    self.CloseProgress = math.Clamp((CurTime() - (self.CloseTime or 0)) / CLOSE_ANIM_TIME, 0, 1)
end

function PIEMENU:IsOpen()
    return self.OpenTime and true or false
end

local function ReloadPieMenu()
    gRust.PieMenu.Circle = gRust.PieMenu.Circle or gRust.CreateCircle()
    gRust.PieMenu.Circle:SetStartAngle(0)
    gRust.PieMenu.Circle:SetEndAngle(360)
    gRust.PieMenu.Circle:SetRadius(490 * gRust.Hud.Scaling)
    gRust.PieMenu.Circle:SetThickness(170 * gRust.Hud.Scaling)
    gRust.PieMenu.Circle:SetCenter(ScrW() / 2, ScrH() / 2)
    gRust.PieMenu.Circle:SetColor(PIEMENU_COLOR)
    
    gRust.PieMenu.Wedge = gRust.CreateCircle()
    gRust.PieMenu.Wedge:SetRadius(504 * gRust.Hud.Scaling)
    gRust.PieMenu.Wedge:SetThickness(176 * gRust.Hud.Scaling)
    gRust.PieMenu.Wedge:SetCenter(ScrW() / 2, ScrH() / 2)
    gRust.PieMenu.Wedge:SetColor(DEFAULT_WEDGE_COLOR)
    
    gRust.PieMenu.Invalid = gRust.CreateCircle()
    gRust.PieMenu.Invalid:SetRadius(490 * gRust.Hud.Scaling)
    gRust.PieMenu.Invalid:SetThickness(170 * gRust.Hud.Scaling)
    gRust.PieMenu.Invalid:SetCenter(ScrW() / 2, ScrH() / 2)
    gRust.PieMenu.Invalid:SetColor(PIEMENU_INVALID_COLOR)
end

hook.Add("gRust.Loaded", "gRust.LoadPieMenu", ReloadPieMenu)
hook.Add("OnScreenSizeChanged", "gRust.LoadPieMenu", ReloadPieMenu)

function PIEMENU:SetAngleOffset(offset)
    self.AngleOffset = offset
end

local ANGLE_OFFSETS = {
    [2] = 45,
    [4] = -120
}

function PIEMENU:GetAngleOffset()
    local offset = ANGLE_OFFSETS[#self.AvailableOptions] or 0
    return offset + (self.AngleOffset or 0)
end

function PIEMENU:Draw()
    if (#self.AvailableOptions == 0) then return end

    local fullyOpen = self.OpenTime and (self.OpenProgress == 1)
    local angleOffset = self:GetAngleOffset()

    -- Alpha
    local alpha = self.OpenTime and math.ease.OutCirc(self.OpenProgress) or (1 - math.ease.OutCirc(self.CloseProgress))
    surface.SetAlphaMultiplier(alpha)

    -- Background
    surface.SetDrawColor(0, 0, 0, 175)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    surface.SetDrawColor(0, 0, 0, 255)
    surface.SetMaterial(BLUR_MATERIAL)
    for i = 1, BLUR_AMOUNT do
        BLUR_MATERIAL:SetFloat("$blur", (i / BLUR_AMOUNT) * 6)
        BLUR_MATERIAL:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end

    local circle = gRust.PieMenu.Circle
    local invalid = gRust.PieMenu.Invalid
    local wedge = gRust.PieMenu.Wedge

    local option = self.AvailableOptions[self.Index]
    if (!option) then return end
    if (option:GetCondition()) then
        wedge:SetColor(option:GetColor())
    else
        wedge:SetColor(ColorAlpha(option:GetColor(), 150))
    end

    -- Drawing
    cam.PushModelMatrix(self.AnimMatrix)

    circle:Draw()

    invalid:SetStartAngle(0)
    invalid:SetEndAngle(360 / #self.AvailableOptions)
    for i = 1, #self.AvailableOptions do
        if (!self.AvailableOptions[i]:GetCondition()) then
            invalid:SetRotation((360 / #self.AvailableOptions) * (i - 1) + angleOffset)
            invalid:Draw()
        end
    end

    wedge:Draw()

    -- Icons
    local cx, cy = circle:GetCenter()
    for i = 0, #self.AvailableOptions - 1 do
        local option = self.AvailableOptions[i + 1]
        local angle = math.rad(((360 / #self.AvailableOptions) * i + (360 / #self.AvailableOptions) / 2) + angleOffset)
        local radius = circle:GetRadius() - (circle:GetThickness() / 2)
        local iconPos = Vector(math.cos(angle), math.sin(angle), 0) * radius
        local iconX, iconY = cx + iconPos.x, cy + iconPos.y

        surface.SetMaterial(gRust.GetIcon(option:GetIcon()))
        if (option:GetCondition()) then
            if (self.Index == i + 1) then
                surface.SetDrawColor(PIEMENU_COLOR)
            else
                surface.SetDrawColor(option:GetColor())
            end
        else
            surface.SetDrawColor(INVALID_ICON_COLOR)
        end

        surface.DrawTexturedRect(iconX - OUTER_ICON_SIZE * gRust.Hud.Scaling, iconY - OUTER_ICON_SIZE * gRust.Hud.Scaling, OUTER_ICON_SIZE * 2 * gRust.Hud.Scaling, OUTER_ICON_SIZE * 2 * gRust.Hud.Scaling)
    end

    -- Text
    if (fullyOpen or self.OpenTime) then
        local title = isfunction(option:GetTitle()) and option:GetTitle()() or option:GetTitle()
        local description = isfunction(option:GetDescription()) and option:GetDescription()() or option:GetDescription()
        local footer = isfunction(option:GetFooter()) and option:GetFooter()() or option:GetFooter()

        if (title) then
            draw.SimpleText(title, "gRust.68px", cx, cy + TITLE_OFFSET * gRust.Hud.Scaling, TITLE_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if (description) then
            draw.SimpleText(string.Cap(description, 36), "gRust.46px", cx, cy + DESCRIPTION_OFFSET * gRust.Hud.Scaling, DESCRIPTION_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if (footer) then
            draw.SimpleText(footer, "gRust.30px", cx, cy + FOOTER_OFFSET * gRust.Hud.Scaling, FOOTER_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    
    surface.SetMaterial(gRust.GetIcon(option:GetIcon()))
    surface.SetDrawColor(ICON_COLOR)
    surface.DrawTexturedRect(cx - ICON_SIZE * gRust.Hud.Scaling, cy - ICON_SIZE * gRust.Hud.Scaling - ICON_OFFSET * gRust.Hud.Scaling, ICON_SIZE * 2 * gRust.Hud.Scaling, ICON_SIZE * 2 * gRust.Hud.Scaling)

    cam.PopModelMatrix()
end

local LeftMouseDown = false
function PIEMENU:Update()
    if (!LocalPlayer():Alive()) then
        self:Close()
        return
    end

    self.OpenProgress = math.Clamp((CurTime() - (self.OpenTime or 0)) / OPEN_ANIM_TIME, 0, 1)
    self.CloseProgress = math.Clamp((CurTime() - (self.CloseTime or 0)) / CLOSE_ANIM_TIME, 0, 1)

    local angleOffset = self:GetAngleOffset()

    local circle = gRust.PieMenu.Circle
    local wedge = gRust.PieMenu.Wedge
    
    local fullyOpen = self.OpenTime and (self.OpenProgress == 1)

    local cx, cy = circle:GetCenter()
    
    if (fullyOpen) then
        local mx, my = gui.MousePos()
        local angle = (math.deg(math.atan2(my - cy, mx - cx)) - angleOffset) % 360
        if (angle < 0) then angle = angle + 360 end
        local index = math.max(math.ceil(angle / (360 / #self.AvailableOptions)), 1)
    
        if (index != self.Index) then
            self.LastIndex = self.Index
            self.Index = index
            self.RotateTime = CurTime()

            if (self.AvailableOptions[self.Index]:GetCondition()) then
                self.SelectTime = CurTime()
                gRust.PlaySound("piemenu.blip")
            end
        end

        if (input.IsMouseDown(MOUSE_LEFT)) then
            if (!LeftMouseDown) then
                local option = self.AvailableOptions[self.Index]
                if (option and option:GetCondition()) then
                    self:Close(true)
                    self.Success = true
                    gRust.PlaySound("piemenu.select")
                    
                    local cback = option:GetCallback()
                    if (cback) then
                        cback()
                    end
                end
            end

            LeftMouseDown = true
        else
            LeftMouseDown = false
        end
    end

    self.SelectProgress = math.Clamp((CurTime() - (self.SelectTime or 0)) / SWITCH_ANIM_TIME, 0, 1)
    self.RotateProgress = math.Clamp((CurTime() - (self.RotateTime or 0)) / ROTATE_ANIM_TIME, 0, 1)

    wedge:SetStartAngle(0)
    wedge:SetEndAngle(360 / #self.AvailableOptions)

    local option = self.AvailableOptions[self.Index]
    local oldRotation = (self.LastIndex - 1) * (360 / #self.AvailableOptions)
    local newRotation = (self.Index - 1) * (360 / #self.AvailableOptions)
    if (self.Index == 1 and self.LastIndex == #self.AvailableOptions) then
        oldRotation = oldRotation - 360
    elseif (self.Index == #self.AvailableOptions and self.LastIndex == 1) then
        newRotation = newRotation - 360
    end

    local rotation = Lerp(self.RotateProgress, oldRotation, newRotation) + angleOffset
    wedge:SetRotation(rotation)

    -- Scaling animation
    local scale = 1
    if (fullyOpen) then
        scale = Lerp(gRust.Anim.Punch(self.SelectProgress), 1, 1.03)
    elseif (self.CloseTime and self.CloseProgress > 0) then
        scale = Lerp(math.ease.OutCirc(self.CloseProgress), 1, self.Success and 1.5 or 0.5)
    elseif (self.OpenTime and self.OpenProgress > 0) then
        scale = Lerp(math.ease.OutCirc(self.OpenProgress), 1.5, 1)
    end

    self.AnimMatrix:Translate(Vector(cx, cy))
    self.AnimMatrix:SetScale(Vector(scale, scale, 1))
    self.AnimMatrix:Translate(Vector(-cx, -cy))
end

function gRust.CreatePieMenu()
    local menu = {}
    setmetatable(menu, PIEMENU)
    menu:Init()
    return menu
end

--
-- Pie Menu Drawing
--

hook.Add("PostHUDPaint", "gRust.DrawPieMenu", function()
    local PieMenu = gRust.PieMenu.Instance
    if (!PieMenu) then return end
    if (!PieMenu.OpenTime and PieMenu.CloseProgress == 1) then return end

    PieMenu:Update()
    PieMenu:Draw()
end)