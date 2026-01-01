AddCSLuaFile()

ENT.Base = "rust_ioentity"
DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/electricity/solar_panel.mdl"

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(-90)
    :SetRotate(90)

ENT.Inputs = {}
ENT.Outputs = {
    gRust.CreateIOSlot()
        :SetName("Power Output")
        :SetPos(Vector(43, -8, 1)),
}