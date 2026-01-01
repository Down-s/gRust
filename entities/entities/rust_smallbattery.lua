AddCSLuaFile()

ENT.Base = "rust_battery"
ENT.Model = "models/electricity/small_battery.mdl"

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(90)
    :SetRotate(90)

ENT.Inputs = {
    gRust.CreateIOSlot()
        :SetName("Power Input")
        :SetPos(Vector(-7.05, 2.475, 13.5))
        :SetMainPower(true),
}

ENT.Outputs = {
    gRust.CreateIOSlot()
        :SetName("Power Output")
        :SetPos(Vector(7.05, 2.475, 13.5)),
}