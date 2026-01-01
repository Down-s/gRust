local function TreeEffects(len)
    local hitPos = net.ReadVector()
    
    local effectdata = EffectData()
    effectdata:SetOrigin( hitPos )
    effectdata:SetEntity(self)
    effectdata:SetSurfaceProp(9)
    effectdata:SetDamageType(2)
    util.Effect( "GlassImpact", effectdata )
end

net.Receive("gRust.TreeEffects", TreeEffects)