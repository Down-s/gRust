local INTERNAL_ENTITIES = {
    ["prop_physics"] = true,
    ["prop_physics_multiplayer"] = true,
    ["prop_dynamic"] = true,
    ["prop_dynamic_override"] = true,
    ["prop_ragdoll"] = true,
}

local FakeEntities = {}

function ents.Register(tbl, class, base)
    if (INTERNAL_ENTITIES[base]) then
        tbl.Type = class
        tbl.Base = base
        FakeEntities[class] = tbl
    else
        local ENT = table
        ENT.Type = class
        ENT.Base = baseclass
        scripted_ents.Register(ENT, class)
    end
end

gRust.OldEntsCreate = gRust.OldEntsCreate or ents.Create
function ents.Create(class)
    if (FakeEntities[class]) then
        local fake = FakeEntities[class]
        local ent = ents.Create(fake.Base)
        return ent
    else
        return gRust.OldEntsCreate(class)
    end
end