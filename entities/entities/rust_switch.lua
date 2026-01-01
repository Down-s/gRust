AddCSLuaFile()

ENT.Base = "rust_ioentity"
DEFINE_BASECLASS(ENT.Base)

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 1, "On")
end

function ENT:Initialize()
    BaseClass.Initialize(self)
    
    if (SERVER) then
        self:SwitchOff()
    end
end

function ENT:SwitchOn()
    if (CLIENT) then return end

    self:SetInteractText("TURN OFF")
    self:SetInteractIcon("cross")
    self:SetOn(true)
end

function ENT:SwitchOff()
    if (CLIENT) then return end

    self:SetInteractText("TURN ON")
    self:SetInteractIcon("default")
    self:SetOn(false)
end

function ENT:Toggle()
    if (self:GetOn()) then
        self:SwitchOff()
    else
        self:SwitchOn()
    end
end

function ENT:Interact()
    if (CLIENT) then return end

    self:Toggle()
end

ENT.Model = "models/electricity/switch.mdl"

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRotate(180)

ENT.Inputs = {
    gRust.CreateIOSlot()
        :SetName("Power Input")
        :SetPos(Vector(1.5, 0, -9.5))
        :SetMainPower(true),
}

ENT.Outputs = {
    gRust.CreateIOSlot()
        :SetName("Power Output")
        :SetPos(Vector(1.5, 0, 9)),
    gRust.CreateIOSlot()
        :SetName("Switch On")
        :SetPos(Vector(2.5, 6, 2.5)),
    gRust.CreateIOSlot()
        :SetName("Switch Off")
        :SetPos(Vector(2.5, 6, -2.5)),
}