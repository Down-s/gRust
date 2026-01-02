DEFINE_BASECLASS("rust_base")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local NullSound = function() return "" end
function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    if (self.MaxHP) then
        self:SetMaxHP(self.MaxHP)
        self:SetHP(self.MaxHP)
    end

    local LeftDoor = ents.Create("rust_door")
    LeftDoor:SetPos(self:LocalToWorld(Vector(-self.DoorSpacing, 0, 5)))
    LeftDoor:SetAngles(self:GetAngles())
    LeftDoor.Model = self.LeftDoorModel
    LeftDoor:Spawn()
    LeftDoor:SetNWBool("gRust.NoLock", true)
    LeftDoor.RotateAmount = -LeftDoor.RotateAmount
    LeftDoor.OnOpen = function()
        self:EmitSound(self:GetOpenSound())
    end
    LeftDoor.OnClose = function()
        self:EmitSound(self:GetCloseSound())
    end
    LeftDoor.OnShut = function()
        self:EmitSound(self:GetShutSound())
    end
    LeftDoor.GetOpenSound = NullSound
    LeftDoor.GetCloseSound = NullSound
    LeftDoor.GetShutSound = NullSound
    LeftDoor:SetMaxHP(self.MaxHP)
    LeftDoor:SetHP(self.MaxHP)

    local RightDoor = ents.Create("rust_door")
    RightDoor:SetPos(self:LocalToWorld(Vector(self.DoorSpacing, 0, 5)))
    RightDoor:SetAngles(self:GetAngles() + Angle(0, 180, 0))
    RightDoor.Model = self.RightDoorModel
    RightDoor:Spawn()
    RightDoor.GetOpenSound = NullSound
    RightDoor.GetCloseSound = NullSound
    RightDoor.GetShutSound = NullSound
    RightDoor:SetMaxHP(self.MaxHP)
    RightDoor:SetHP(self.MaxHP)

    local CanTakeDamage = true
    local function OnTakeDamage(me, dmg)
        if (!CanTakeDamage) then return end

        local parent = me:GetParent()
        if (IsValid(parent)) then
            parent:TakeDamageInfo(dmg)

            me:SetHP(parent:GetHP())
            me.OtherDoor:SetHP(parent:GetHP())
        end

        CanTakeDamage = false
        timer.Simple(0, function() CanTakeDamage = true end)
    end

    LeftDoor.OtherDoor = RightDoor
    RightDoor.OtherDoor = LeftDoor
    LeftDoor.OnTakeDamage = OnTakeDamage
    RightDoor.OnTakeDamage = OnTakeDamage

    RightDoor:SetLinkedDoor(LeftDoor)

    self:DeleteOnRemove(LeftDoor)
    self:DeleteOnRemove(RightDoor)

    LeftDoor:DeleteOnRemove(self)
    RightDoor:DeleteOnRemove(self)

    LeftDoor.CanOpen = function(me, ...)
        return RightDoor:CanOpen(...)
    end

    self.LeftDoor = LeftDoor
    self.RightDoor = RightDoor
end

function ENT:GetOpenSound()
    return "doors/door_wood_open.wav"
end

function ENT:GetCloseSound()
    return "doors/door_wood_close.wav"
end

function ENT:GetShutSound()
    return "doors/door_wood_shut.wav"
end

function ENT:GetKnockSound()
    return string.format("doors/door_knock_wood_%i.wav", math.random(1, 2))
end

function ENT:Save(f)
    BaseClass.Save(self, f)

    if (self.RightDoor.LockData) then
        f:WriteBool(true)
        f:WriteString(self.RightDoor.LockData.Item)
        f:WriteBool(self.RightDoor:IsLocked())
        f:WriteUShort(table.Count(self.RightDoor.LockData.Authorized))
        for k, v in pairs(self.RightDoor.LockData.Authorized) do
            f:WriteString(k)
        end

        f:WriteBool(self.RightDoor.LockData.Code != nil)
        if (self.RightDoor.LockData.Code) then
            f:WriteShort(self.RightDoor.LockData.Code)
        end
    else
        f:WriteBool(false)
    end
end

function ENT:Load(f)
    BaseClass.Load(self, f)

    self.LeftDoor.InitialRotation = self:GetAngles().y
    self.RightDoor.InitialRotation = self:GetAngles().y + 180

    if (f:ReadBool()) then
        self.RightDoor:AddLock(f:ReadString())
        if (f:ReadBool()) then
            self.RightDoor:Lock()
        else
            self.RightDoor:Unlock()
        end

        local count = f:ReadUShort()
        for i = 1, count do
            self.RightDoor.LockData.Authorized[f:ReadString()] = true
        end

        if (f:ReadBool()) then
            self.RightDoor.LockData.Code = f:ReadShort()
        end
    end
end