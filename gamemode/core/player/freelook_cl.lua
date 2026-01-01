local FREELOOK_KEY = KEY_LALT
local FREELOOK_LERP_SPEED = 15
local FREELOOK_MAX_HORIZONTAL_ANGLE = 160
local FREELOOK_MAX_VERTICAL_ANGLE = 40

local LookX = 0
local LookY = 0
local LastMouseX = 0
local LastMouseY = 0

local View = {}
local function GetLookView(ang)
    View.angles = ang + Angle(LookY, -LookX, 0)
    return View
end

local function ShouldLerp()
    return math.abs(LookX) > 0.01 or math.abs(LookY) > 0.01
end

hook.Add("CalcView", "gRust.FreeLook", function(pl, pos, ang, fov, znear, zfar)
    if (!input.IsKeyDown(FREELOOK_KEY)) then
        if (ShouldLerp()) then
            LookX = Lerp(FrameTime() * FREELOOK_LERP_SPEED, LookX, 0)
            LookY = Lerp(FrameTime() * FREELOOK_LERP_SPEED, LookY, 0)
            return GetLookView(ang)
        else
            LookX = 0
            LookY = 0
        end
    else
        return GetLookView(ang)
    end
end)

local MOUSE_SCALING = 0.022
hook.Add("InputMouseApply", "gRust.FreeLook", function(cmd, x, y, ang)
    if (input.IsKeyDown(FREELOOK_KEY)) then
        LookX = LookX + x * MOUSE_SCALING
        LookY = LookY + y * MOUSE_SCALING

        LookX = math.Clamp(LookX, -FREELOOK_MAX_HORIZONTAL_ANGLE, FREELOOK_MAX_HORIZONTAL_ANGLE)
        LookY = math.Clamp(LookY, -FREELOOK_MAX_VERTICAL_ANGLE, FREELOOK_MAX_VERTICAL_ANGLE)

        return true
    end
end)

local CalculatingView = false
hook.Add("CalcViewModelView", "gRust.FreeLook", function(wep, vm, oldpos, oldang, pos, ang)
    if (CalculatingView) then return end

    CalculatingView = true
    local newpos, newang = hook.Run("CalcViewModelView", wep, vm, oldpos, oldang, pos, ang)
    CalculatingView = false

    if (input.IsKeyDown(FREELOOK_KEY) or ShouldLerp()) then
        newang = newang + Angle(LookY, -LookX, 0) * 0.5
        return newpos, newang
    end
end)