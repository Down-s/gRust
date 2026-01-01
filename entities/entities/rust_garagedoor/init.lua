AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

ENT.MaxHP = 600
ENT.ShouldSave = true

ENT.BulletDamageScale = 0.001
ENT.MeleeDamageScale = 0.001
ENT.ExplosiveDamageScale = 0.55

function ENT:Initialize()
    self:SetupCollision()

    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetInteractText("OPEN DOOR")
    self:SetInteractIcon("open_door")
    self:SetInteractable(true)
    self.InitialRotation = self:GetAngles().y
    self.IsShut = true

    if (self.MaxHP) then
        self:SetMaxHP(self.MaxHP)
        self:SetHP(self.MaxHP)
    end
end

function ENT:CanOpen(pl)
    return self:IsAuthorizedToLock(pl)
end

function ENT:Interact(pl)
    if (!self:CanOpen(pl)) then return end
    
    self:Toggle()

    if (self.LockData and self.LockData.Item == "code_lock") then
        self:EmitSound("codelock.beep")
    end
end

function ENT:Toggle()
    local open = self:GetOpen()

    self:SetOpen(!open)
    self:SetOpenTime(CurTime())
    self:ResetSequence(open and "close" or "open")
    self:EmitSound("garagedoor.open")
    self:SetInteractable(false)
    self.LoopSound = self:StartLoopingSound("garagedoor.loop")
    self.IsShut = false
end

function ENT:Shut()
    self.IsShut = true
    self:EmitSound("garagedoor.stop")
    self:StopLoopingSound(self.LoopSound)
    self:SetInteractable(true)
end

function ENT:SetLocked(locked)
    if (locked) then
        self:SetSkin(1)
    else
        self:SetSkin(0)
    end
end