AddCSLuaFile()

ENT.Base = "rust_ioentity"
ENT.Model = "models/props_c17/FurnitureWashingmachine001a.mdl"

ENT.Inputs = {
    gRust.CreateIOSlot()
        :SetName("Power Input")
        :SetPos(Vector(14, 0, -16))
        :SetMainPower(true)
}

ENT.Outputs = {
    gRust.CreateIOSlot()
        :SetName("Power Output 1")
        :SetPos(Vector(-14, 8, -20)),
    gRust.CreateIOSlot()
        :SetName("Power Output 3")
        :SetPos(Vector(-14, -8, -20)),
    gRust.CreateIOSlot()
        :SetName("Power Output 2")
        :SetPos(Vector(-14, 0, -20)),
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetRotate(90)
    :SetOnDeployed(function(self, pl, ent)
        self:SetPos(self:GetPos() + self:GetUp() * 20)
    end)
    :SetPreviewCallback(function(self, ent)
        ent:SetPos(ent:GetPos() + ent:GetUp() * 20)
    end)