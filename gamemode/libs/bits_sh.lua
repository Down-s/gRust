bits = bits or {}

local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local bnot = bit.bnot
local lshift = bit.lshift
local rshift = bit.rshift
local frexp = math.frexp

local BUFFER = {}
BUFFER.__index = BUFFER

-- !
-- ! Write
-- !

function BUFFER:WriteBit(b)
    self.buffer[self.index] = b
    self.index = self.index + 1
end

function BUFFER:WriteInt(i, bits)
    for b = bits - 1, 0, -1 do
        self:WriteBit(band(rshift(i, b), 1))
    end
end

function BUFFER:WriteByte(b)
    self:WriteInt(b, 8)
end

function BUFFER:WriteFloat(f)
    local sign = 0
    if (f < 0) then
        sign = 1
        f = -f
    end

    local mantissa, exponent = frexp(f)
    mantissa = (mantissa * 2 - 1) * (2^23)
    exponent = exponent + 126

    self:WriteBit(sign)
    self:WriteInt(exponent, 8)
    self:WriteInt(mantissa, 23)
end

function BUFFER:WriteChar(c)
    self:WriteInt(string.byte(c, 1), 8)
end

function BUFFER:WriteString(s)
    local bytes = {string.byte(s, 1, -1)}
    
    for _, byte in ipairs(bytes) do
        self:WriteInt(byte, 8)
    end

    self:WriteInt(0, 8)
end

function BUFFER:WriteVector(v)
    self:WriteFloat(v.x)
    self:WriteFloat(v.y)
    self:WriteFloat(v.z)
end

function BUFFER:WriteAngle(a)
    self:WriteFloat(a.p)
    self:WriteFloat(a.y)
    self:WriteFloat(a.r)
end

-- !
-- ! Read
-- !

function BUFFER:ReadBit()
    if (self.readpos > #self.buffer) then
        return 0
    end

    local b = self.buffer[self.readpos]
    self.readpos = self.readpos + 1
    return b
end

function BUFFER:ReadInt(bits)
    local i = 0
    for b = 0, bits - 1 do
        i = bor(lshift(i, 1), self:ReadBit())
    end

    return i
end

function BUFFER:ReadByte()
    return self:ReadInt(8)
end

function BUFFER:ReadFloat()
    local sign = self:ReadBit()
    local exponent = self:ReadInt(8)
    local mantissa = self:ReadInt(23)

    local f = (mantissa / (2^23)) * ((-1)^sign) * (2^(exponent - 126))
    return f
end

function BUFFER:ReadChar()
    return string.char(self:ReadInt(8))
end

function BUFFER:ReadString()
    local s = {}
    local c = self:ReadChar()
    while (c ~= '\0') do
        s[#s + 1] = c
        c = self:ReadChar()

        if (#s > 1000) then
            gRust.LogError("bits.ReadString: could not read string")
            break
        end
    end

    return table.concat(s)
end

function BUFFER:ReadVector()
    return Vector(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end

function BUFFER:ReadAngle()
    return Angle(self:ReadFloat(), self:ReadFloat(), self:ReadFloat())
end

-- !
-- ! Other
-- !

function BUFFER:ToString(compress)
    local bytes = {}
    local byte = 0
    local byteIndex = 1
    for i = 1, #self.buffer do
        local bit = self.buffer[i]
        byte = bor(lshift(byte, 1), bit)

        if (i % 8 == 0) then
            bytes[byteIndex] = byte
            byteIndex = byteIndex + 1
            byte = 0
        end
    end

    local s = {}
    for _, byte in ipairs(bytes) do
        s[#s + 1] = string.char(byte)
    end

    if (compress) then
        return util.Compress(table.concat(s))
    end

    return table.concat(s)
end

function BUFFER:ToBytes()
    local bytes = {}
    local byte = 0
    local byteIndex = 1
    for i = 1, #self.buffer do
        local bit = self.buffer[i]
        byte = bor(lshift(byte, 1), bit)

        if (i % 8 == 0 or i == #self.buffer) then
            bytes[byteIndex] = byte
            byteIndex = byteIndex + 1
            byte = 0
        end
    end

    return bytes
end

function BUFFER:ToFile(path, compress)
    local f = file.Open(path, "wb", "DATA")
    if (!f) then
        return
    end

    f:Write(self:ToString(compress))
    f:Close()
end

function BUFFER:End()
    return self.readpos > #self.buffer
end

function bits.CreateBuffer()
    return setmetatable({
        buffer = {},
        index = 1,
        readpos = 1
    }, BUFFER)
end

function bits.ReadFile(path, compressed)
    if (!file.Exists(path, "DATA")) then
        return bits.CreateBuffer()
    end

    local buffer = bits.CreateBuffer()
    local f = file.Open(path, "rb", "DATA")
    if (!f) then
        return buffer
    end

    local s = f:Read(f:Size())
    f:Close()

    if (!s) then
        return buffer
    end

    if (compressed) then
        s = util.Decompress(s)
    end

    for i = 1, #s do
        local byte = string.byte(s, i)
        for b = 7, 0, -1 do
            buffer:WriteBit(band(rshift(byte, b), 1))
        end
    end

    return buffer
end

function bits.ReadString(str)
    local buffer = bits.CreateBuffer()
    for i = 1, #str do
        buffer:WriteInt(string.byte(str, i), 8)
    end

    return buffer
end