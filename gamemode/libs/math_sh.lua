local math = math

-- Tau supremacy
math.tau = math.pi * 2

function math.Sign(value)
    return value >= 0 and 1 or -1
end

function math.Lerp(a, b, t)
    return a + (b - a) * t
end

function math.InverseLerp(a, b, value)
    return (value - a) / (b - a)
end

function math.LerpColor(a, b, t)
    return Color(math.Lerp(a.r, b.r, t), math.Lerp(a.g, b.g, t), math.Lerp(a.b, b.b, t), math.Lerp(a.a, b.a, t))
end

function math.MoveTowards(current, target, maxDelta)
    if (math.abs(target - current) <= maxDelta) then
        return target
    end
    
    return current + math.Sign(target - current) * maxDelta
end

function math.BitCount(n)
    return math.ceil(math.log(n, 2))
end