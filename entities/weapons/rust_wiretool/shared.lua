SWEP.Base = "rust_swep"
DEFINE_BASECLASS("rust_swep")

SWEP.WorldModel = ""
SWEP.ViewModel = ""

function SWEP:Initialize()
    BaseClass.Initialize(self)

    self.MaxWireLength = gRust.GetConfigValue("electricity/wire.maxlength")
    self.MaxWireRoutes = gRust.GetConfigValue("electricity/wire.maxroutes")
end