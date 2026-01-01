AttachmentType = {
    Barrel = 1,
    Sight = 2,
    Magazine = 3,
    Stock = 4,
    Underbarrel = 5,
    Other = 6
}

local ATTACHMENT = {}
ATTACHMENT.__index = ATTACHMENT

gRust.AccessorFunc(ATTACHMENT, "Type", "Type", FORCE_NUMBER)
gRust.AccessorFunc(ATTACHMENT, "Model", "Model", FORCE_STRING)
gRust.AccessorFunc(ATTACHMENT, "Bone", "Bone", FORCE_STRING)
gRust.AccessorFunc(ATTACHMENT, "Position", "Position")
gRust.AccessorFunc(ATTACHMENT, "Angle", "Angle")
gRust.AccessorFunc(ATTACHMENT, "Scale", "Scale", FORCE_NUMBER)

-- Sights
gRust.AccessorFunc(ATTACHMENT, "IronSightsPos", "IronSightsPos")
gRust.AccessorFunc(ATTACHMENT, "IronSightsAng", "IronSightsAng")
gRust.AccessorFunc(ATTACHMENT, "RectilePosition", "RectilePosition")
gRust.AccessorFunc(ATTACHMENT, "RectileAngle", "RectileAngle")
gRust.AccessorFunc(ATTACHMENT, "RectileScale", "RectileScale", FORCE_NUMBER)
gRust.AccessorFunc(ATTACHMENT, "RectileDrawCallback", "RectileDrawCallback")

function gRust.CreateAttachment(type)
    local meta = setmetatable({}, ATTACHMENT)
    meta.Type = type

    return meta
end