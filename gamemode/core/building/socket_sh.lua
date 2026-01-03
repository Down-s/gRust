local SOCKET = {}
SOCKET.__index = SOCKET

function SOCKET:Init()
    self:SetPosition(0, 0, 0)
    self:SetAngle(0, 0, 0)
    self:SetAngleOffset(0, 0, 0)
    self.FemaleTags = {}
    self.MaleTags = {}
end

function SOCKET:AddMaleTag(tag)
    self.MaleTags[#self.MaleTags + 1] = tag
    return self
end

function SOCKET:AddFemaleTag(tag)
    self.FemaleTags[tag] = true
    return self
end

function SOCKET:CanConnect(other)
    local canConnect = false
    for k, v in ipairs(self.MaleTags) do
        if (other.FemaleTags[v]) then
            canConnect = true
            break
        end
    end

    return canConnect
end

function SOCKET:SetPosition(x, y, z)
    self.pos = Vector(x, y, z)
    return self
end

function SOCKET:GetPosition()
    return self.pos
end

function SOCKET:SetAngle(x, y, z)
    self.ang = Angle(x, y, z)
    return self
end

function SOCKET:GetAngle()
    return self.ang
end

function SOCKET:SetAngleOffset(x, y, z)
    self.angOffset = Angle(x, y, z)
    return self
end

function SOCKET:GetAngleOffset()
    return self.angOffset
end

function SOCKET:SetCustomCheck(func)
    self.CustomCheck = func
    return self
end

function SOCKET:GetCustomCheck(...)
    if (self.CustomCheck) then
        return self.CustomCheck(...)
    end
end

function SOCKET:Copy()
    local copy = gRust.CreateSocket()
    if (self.pos) then copy:SetPosition(self.pos.x, self.pos.y, self.pos.z) end
    if (self.ang) then copy:SetAngle(self.ang.p, self.ang.y, self.ang.r) end
    if (self.angOffset) then copy:SetAngleOffset(self.angOffset.p, self.angOffset.y, self.angOffset.r) end

    for k, v in ipairs(self.MaleTags) do copy:AddMaleTag(v) end
    for k, v in pairs(self.FemaleTags) do copy:AddFemaleTag(k) end

    if (self.CustomCheck) then copy:SetCustomCheck(self.CustomCheck) end

    return copy
end

function gRust.CreateSocket()
    local socket = setmetatable({}, SOCKET)
    socket:Init()
    return socket
end