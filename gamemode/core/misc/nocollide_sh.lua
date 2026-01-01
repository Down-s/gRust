function GM:ShouldCollide(ent1, ent2)
    if (ent1.NoCollide and ent2.NoCollide) then return false end
    return true
end