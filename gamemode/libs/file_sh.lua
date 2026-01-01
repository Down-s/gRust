local FILE = FindMetaTable("File")
function FILE:WriteString(s)
    self:WriteUShort(#s)
    self:Write(s)
end

function FILE:ReadString()
    return self:Read(self:ReadUShort())
end

function FILE:WriteVector(v)
    self:WriteFloat(v.x)
    self:WriteFloat(v.y)
    self:WriteFloat(v.z)
end

function FILE:ReadVector()
    return Vector(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end

function FILE:WriteAngle(a)
    self:WriteFloat(a.p)
    self:WriteFloat(a.y)
    self:WriteFloat(a.r)
end

function FILE:ReadAngle()
    return Angle(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end