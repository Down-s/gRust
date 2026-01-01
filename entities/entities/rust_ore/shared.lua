ENT.Base = "base_anim"
ENT.Type = "anim"

function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "WeakSpot")
end