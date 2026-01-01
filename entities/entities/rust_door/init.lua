AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

ENT.BulletDamageScale = 0.1
ENT.MeleeDamageScale = 0.1
ENT.ExplosiveDamageScale = 0.6

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetInteractText("OPEN DOOR")
    self:SetInteractIcon("open_door")
    self:SetInteractable(true)
    self.InitialRotation = self:GetAngles().y
    self.RotateAmount = -95

    if (self.MaxHP) then
        self:SetMaxHP(self.MaxHP)
        self:SetHP(self.MaxHP)
    end
end

function ENT:SetLinkedDoor(door)
    self.LinkedDoor = door
    door.LinkedDoor = self
end

function ENT:IsLocked()
    if (!self.LockData) then return false end

    return self:GetSkin() == 1 or (self.LinkedDoor and self.LinkedDoor:GetSkin() == 1)
end

function ENT:SetLocked(locked)
    if (locked) then
        self:SetSkin(1)
    else
        self:SetSkin(0)
    end
end

function ENT:IsAuthorizedToLock(pl)
    if (!self.LockData) then return true end

    return (self.LockData.Authorized[pl:SteamID()] or ((self.LinkedDoor and self.LinkedDoor.LockData) and self.LinkedDoor.LockData.Authorized[pl:SteamID()])) or false
end

function ENT:CanOpen(pl)
    return self:IsAuthorizedToLock(pl)
end

function ENT:Interact(pl)
    if (!self:CanOpen(pl)) then return end
    
    if (self:GetOpen()) then
        self:Close()
    else
        self:Open()
    end

    if (self.LockData and self.LockData.Item == "code_lock") then
        self:EmitSound("codelock.beep")
    end
end

function ENT:Open()
    if (self:GetOpen()) then return end
    if (self:GetRotateTime() + self.RotateTime > CurTime()) then return end

    self:SetOpen(true)
    self:SetRotateTime(CurTime())

    self:SetInteractable(false)
    self:SetInteractText("CLOSE DOOR")
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)

    self:EmitSound(self:GetOpenSound())
    self.Shut = false

    self:ResetSequence("open")
    self:OnOpen()

    if (IsValid(self.LinkedDoor)) then
        self.LinkedDoor:SetOpen(true)
        self.LinkedDoor:SetRotateTime(CurTime())
        self.LinkedDoor:SetInteractable(false)
        self.LinkedDoor:SetInteractText("CLOSE DOOR")
        self.LinkedDoor:EmitSound(self:GetOpenSound())
        self.LinkedDoor.Shut = false

        self.LinkedDoor:ResetSequence("open")
        self.LinkedDoor:OnOpen()
    end
end

function ENT:Close()
    if (!self:GetOpen()) then return end
    if (self:GetRotateTime() + self.RotateTime > CurTime()) then return end

    self:SetOpen(false)
    self:SetRotateTime(CurTime())

    self:SetInteractable(false)
    self:SetInteractText("OPEN DOOR")
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)

    self:EmitSound(self:GetCloseSound())
    self.Shut = false

    self:ResetSequence("open")
    self:OnClose()

    if (IsValid(self.LinkedDoor)) then
        self.LinkedDoor:SetOpen(false)
        self.LinkedDoor:SetRotateTime(CurTime())
        self.LinkedDoor:SetInteractable(false)
        self.LinkedDoor:SetInteractText("OPEN DOOR")
        self.LinkedDoor:EmitSound(self:GetCloseSound())
        self.LinkedDoor.Shut = false

        self.LinkedDoor:ResetSequence("open")
        self.LinkedDoor:OnClose()
    end
end

util.AddNetworkString("gRust.ToggleDoor")
net.Receive("gRust.ToggleDoor", function(len, pl)
    if (!IsValid(pl)) then return end
    if (!pl:Alive()) then return end
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end
    if (!ent.gRust) then return end
    if (!ent:GetInteractable()) then return end

    ent:Interact(pl)
end)

function ENT:Knock()
    self:EmitSound(self:GetKnockSound())
end

util.AddNetworkString("gRust.Knock")
net.Receive("gRust.Knock", function(len, pl)
    if (!IsValid(pl)) then return end
    if (!pl:Alive()) then return end
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (pl:EyePos():DistToSqr(ent:GetPos()) > MAX_REACH_RANGE_SQR) then return end

    if (!ent.Knock) then return end

    if ((pl.NextKnock or 0) > CurTime()) then return end
    pl.NextKnock = CurTime() + 0.25

    ent:Knock()
end)

local DoorOpen = gRust.Anim.AnimationCurve(
    gRust.Anim.KeyFrame(0, 0),
    gRust.Anim.KeyFrame(0.6, 1),
    gRust.Anim.KeyFrame(0.8, 0.95),
    gRust.Anim.KeyFrame(1, 1)
)

local DoorClose = gRust.Anim.AnimationCurve(
    gRust.Anim.KeyFrame(0, 0),
    gRust.Anim.KeyFrame(0.6, 1),
    gRust.Anim.KeyFrame(0.8, 0.95),
    gRust.Anim.KeyFrame(1, 1)
)

function ENT:Think()
    BaseClass.Think(self)
    
    local Rotation
    local delta = (CurTime() - self:GetRotateTime()) / self.RotateTime
    if (!self:GetInteractable()) then
        if (self:GetOpen()) then
            local animDelta = DoorOpen(delta)
            Rotation = Lerp(animDelta, 0, self.RotateAmount)
            
            if (delta >= 1 and !self:GetInteractable()) then
                self:SetInteractable(true)
                self:SetCollisionGroup(COLLISION_GROUP_NONE)
            end
        else
            local animDelta = DoorClose(delta)
            Rotation = Lerp(animDelta, self.RotateAmount, 0)
    
            if (delta >= 1 and !self:GetInteractable()) then
                self:SetInteractable(true)
                self:SetCollisionGroup(COLLISION_GROUP_NONE)
            end
    
            if (animDelta >= 0.985 and !self.Shut) then
                self:EmitSound(self:GetShutSound())
                self:ResetSequence("open")
                self.Shut = true
    
                self:OnShut()
            end
        end
    
        self:SetAngles(Angle(0, self.InitialRotation + Rotation, 0))
    end

    self:NextThink(CurTime())
    return true
end

function ENT:OnOpen()
end

function ENT:OnClose()
end

function ENT:OnShut()
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