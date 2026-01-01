gRust.Anim = gRust.Anim or {}

local ANIMATIONCURVE = {}
ANIMATIONCURVE.__index = ANIMATIONCURVE
ANIMATIONCURVE.__call = function(self, ...)
    return self:Evaluate(...)
end

function gRust.Anim.AnimationCurve(...)
    local points = {...}
    local curve = {}
    setmetatable(curve, ANIMATIONCURVE)

    curve.points = points

    return curve
end

function gRust.Anim.KeyFrame(time, value)
    return {time = time, value = value}
end

function ANIMATIONCURVE:Evaluate(t)
    local points = self.points
    local count = #points

    if (count == 0) then
        return 0
    end

    if (count == 1) then
        return points[1].value
    end

    local first = points[1]
    local last = points[count]

    if (t < first.time) then
        return first.value
    end

    if (t > last.time) then
        return last.value
    end

    local i = 1
    while (i < count) do
        local point = points[i]
        local nextPoint = points[i + 1]

        if (t >= point.time and t <= nextPoint.time) then
            local delta = nextPoint.time - point.time
            local alpha = (t - point.time) / delta

            return point.value + (nextPoint.value - point.value) * alpha
        end

        i = i + 1
    end

    return 0
end