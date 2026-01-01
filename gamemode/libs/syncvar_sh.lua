local PLAYER = FindMetaTable("Player")

SyncVar = {
    Int = 1,
    UInt = 2,
    Float = 3,
    Bool = 4,
    String = 5,
    Vector = 6,
    Angle = 7,
    Player = 8,
    Entity = 9,
    Color = 10,
    Item = 11,
}

local WRITE_FUNCTIONS = {
    [SyncVar.Int] = net.WriteInt,
    [SyncVar.UInt] = net.WriteUInt,
    [SyncVar.Float] = net.WriteFloat,
    [SyncVar.Bool] = net.WriteBool,
    [SyncVar.String] = net.WriteString,
    [SyncVar.Vector] = net.WriteVector,
    [SyncVar.Angle] = net.WriteAngle,
    [SyncVar.Player] = net.WritePlayer,
    [SyncVar.Entity] = net.WriteEntity,
    [SyncVar.Color] = net.WriteColor,
    [SyncVar.Item] = net.WriteItem,
}

local READ_FUNCTIONS = {
    [SyncVar.Int] = net.ReadInt,
    [SyncVar.UInt] = net.ReadUInt,
    [SyncVar.Float] = net.ReadFloat,
    [SyncVar.Bool] = net.ReadBool,
    [SyncVar.String] = net.ReadString,
    [SyncVar.Vector] = net.ReadVector,
    [SyncVar.Angle] = net.ReadAngle,
    [SyncVar.Player] = net.ReadPlayer,
    [SyncVar.Entity] = net.ReadEntity,
    [SyncVar.Color] = net.ReadColor,
    [SyncVar.Item] = net.ReadItem,
}

local TYPE_BITS = math.ceil(math.log(table.Count(SyncVar), 2))

if (SERVER) then
    --
    -- Registering
    --

    util.AddNetworkString("gRust.RegisterSyncVar")
    function PLAYER:RegisterSyncVar(name, type, bits)
        if (self.SyncVarsIndex and self.SyncVarsIndex[name]) then return end

        bits = bits or 32

        self.SyncVars = self.SyncVars or {}
        self.SyncVarsIndex = self.SyncVarsIndex or {}
        self.SyncVarsRegister = self.SyncVarsRegister or {}

        local index = #self.SyncVarsRegister + 1
        self.SyncVarsRegister[index] = {name, type, bits}
        self.SyncVarsIndex[name] = index
        
        self.SyncVarBits = math.ceil(math.log(#self.SyncVarsRegister, 2))

        if (self:IsNetworkReady()) then
            net.Start("gRust.RegisterSyncVar")
                net.WriteString(name)
                net.WriteUInt(type, TYPE_BITS)
                if (type == SyncVar.Int or type == SyncVar.UInt) then
                    net.WriteUInt(bits, 5)
                end
            net.Send(self)
        else
            self.SyncVarQueue = self.SyncVarQueue or {}
            self.SyncVarQueue[index] = {
                name = name,
                type = type,
                bits = bits,
            }
        end
    end

    util.AddNetworkString("gRust.CreateSyncVars")
    hook.Add("PlayerNetworkReady", "gRust.SyncVars", function(pl)
        local queue = pl.SyncVarQueue
        if (queue) then
            net.Start("gRust.CreateSyncVars")
                net.WriteUInt(#queue, 8)
                for i = 1, #queue do
                    local syncVar = queue[i]
                    net.WriteString(syncVar.name)
                    net.WriteUInt(syncVar.type, TYPE_BITS)
                    if (syncVar.type == SyncVar.Int or syncVar.type == SyncVar.UInt) then
                        net.WriteUInt(syncVar.bits, 5)
                    end
                    net.WriteBit(syncVar.value ~= nil)
                    if (syncVar.value ~= nil) then
                        WRITE_FUNCTIONS[syncVar.type](syncVar.value, syncVar.bits)
                    end
                end
            net.Send(pl)
        end
    end)

    --
    -- Set
    --

    util.AddNetworkString("gRust.SyncVar")
    function PLAYER:SetSyncVar(name, value)
        if (!self.SyncVars) then return end

        local index = self.SyncVarsIndex[name]
        local syncVar = self.SyncVarsRegister[index]
        local type = syncVar[2]

        if (self.SyncVars[name] == value) then
            return
        end

        local shouldNetwork = true
        if (type == SyncVar.Int or type == SyncVar.UInt) then
            value = math.Clamp(value, 0, 2 ^ syncVar[3])

            local oldValue = math.Round(self.SyncVars[name] or 0)
            local newValue = math.Round(value or 0)
            if (oldValue == newValue) then
                shouldNetwork = false
            end
        end

        if (syncVar) then
            local name = syncVar[1]
            local oldValue = self.SyncVars[name]

            if (shouldNetwork) then
                if (self:IsNetworkReady()) then
                    net.Start("gRust.SyncVar")
                        net.WriteUInt(index, self.SyncVarBits)
                        WRITE_FUNCTIONS[syncVar[2]](value, syncVar[3])
                    net.Send(self)
                else
                    self.SyncVarQueue = self.SyncVarQueue or {}
                    self.SyncVarQueue[index].value = value
                end
            end

            self.SyncVars[name] = value

            local proxy = self.SyncVarProxies and self.SyncVarProxies[name]
            if (proxy) then
                proxy(pl, name, oldValue, value)
            end
        end
    end
else
    --
    -- Receiving
    --

    net.Receive("gRust.RegisterSyncVar", function(len)
        local pl = LocalPlayer()
        local name = net.ReadString()
        local type = net.ReadUInt(TYPE_BITS)
        local bits = 32

        if (type == SyncVar.Int or type == SyncVar.UInt) then
            bits = net.ReadUInt(5)
        end
        
        self.SyncVars = self.SyncVars or {}
        self.SyncVarsIndex = self.SyncVarsIndex or {}
        self.SyncVarsRegister = self.SyncVarsRegister or {}

        self.SyncVarsRegister[#self.SyncVarsRegister + 1] = {name, type, bits}

        self.SyncVarBits = math.ceil(math.log(#self.SyncVarsRegister, 2))
    end)

    net.Receive("gRust.CreateSyncVars", function(len)
        local pl = LocalPlayer()

        pl.SyncVars = pl.SyncVars or {}
        pl.SyncVarsIndex = pl.SyncVarsIndex or {}
        pl.SyncVarsRegister = pl.SyncVarsRegister or {}

        local count = net.ReadUInt(8)
        for i = 1, count do
            local name = net.ReadString()
            local type = net.ReadUInt(TYPE_BITS)
            local bits = 32
            
            if (type == SyncVar.Int or type == SyncVar.UInt) then
                bits = net.ReadUInt(5)
            end
            
            if (net.ReadBit() == 1) then
                pl.SyncVars[name] = READ_FUNCTIONS[type](bits)
            end
            
            pl.SyncVars = pl.SyncVars or {}
            pl.SyncVarsIndex = pl.SyncVarsIndex or {}
            pl.SyncVarsRegister = pl.SyncVarsRegister or {}

            pl.SyncVarsRegister[#pl.SyncVarsRegister + 1] = {name, type, bits}

            pl.SyncVarBits = math.ceil(math.log(#pl.SyncVarsRegister, 2))
        end
    end)

    net.Receive("gRust.SyncVar", function(len)
        local pl = LocalPlayer()
        local index = net.ReadUInt(pl.SyncVarBits)
        local syncVar = pl.SyncVarsRegister[index]
        if (syncVar) then
            pl.SyncVars = pl.SyncVars or {}
            local name = syncVar[1]
            local value = READ_FUNCTIONS[syncVar[2]](syncVar[3])
            local oldValue = pl.SyncVars[name]
            pl.SyncVars[name] = value

            local proxy = pl.SyncVarProxies and pl.SyncVarProxies[name]
            if (proxy) then
                proxy(pl, name, oldValue, value)
            end
        end
    end)
end

--
-- Get
--

function PLAYER:GetSyncVar(name, default)
    if (!self.SyncVars) then return default end
    return self.SyncVars[name] or default
end

--
-- Proxy
--

function PLAYER:SetSyncVarProxy(name, func)
    self.SyncVarProxies = self.SyncVarProxies or {}
    self.SyncVarProxies[name] = func
end