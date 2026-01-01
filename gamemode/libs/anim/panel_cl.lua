--
-- Meta
--

local PANEL = FindMetaTable("Panel")

function PANEL:NewAnim(time, easefn, callback, animfn)
    local anim = {
        time = time,
        easefn = easefn,
        animfn = animfn,
        callback = callback,
        start = SysTime(),
    }

    if (self.AnimAnims) then
        self.AnimAnims[#self.AnimAnims + 1] = anim
    else
        self.AnimAnims = {}
        self.AnimAnims[1] = anim
        
        local oldThink = self.Think
        self.Think = function(self)
            if (oldThink) then
                oldThink(self)
            end

            for k, v in pairs(self.AnimAnims) do
                local t = (SysTime() - v.start) / v.time
                local eased = v.easefn and v.easefn(t) or t

                v.animfn(eased)

                if (t >= 1) then
                    self.AnimAnims[k] = nil
                    if (v.callback) then
                        v.callback()
                    end
                    v.animfn(1)
                end
            end
        end
    end
end

-- AnimMoveTo
-- Moves the panel to a position over time

function PANEL:AnimMoveTo(x, y, time, callback, easefn)
    local oldX, oldY = self:GetPos()
    self:NewAnim(time, easefn, callback, function(t)
        self:SetPos(Lerp(t, oldX, x), Lerp(t, oldY, y))
    end)
end

-- AnimSizeTo
-- Resizes the panel to a size over time

function PANEL:AnimSizeTo(w, h, time, callback, easefn)
    local oldW, oldH = self:GetSize()
    self:NewAnim(time, easefn, callback, function(t)
        self:SetSize(Lerp(t, oldW, w), Lerp(t, oldH, h))
    end)
end

-- AnimAlphaTo
-- Fades the panel to an alpha over time

function PANEL:AnimAlphaTo(alpha, time, callback, easefn)
    local oldAlpha = self:GetAlpha()
    self:NewAnim(time, easefn, callback, function(t)
        self:SetAlpha(Lerp(t, oldAlpha, alpha))
    end)
end