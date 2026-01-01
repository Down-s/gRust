local VECTOR = FindMetaTable("Vector")

function VECTOR:RotateAroundPoint(point, angle)
    local offset = self - point
    offset:Rotate(angle)
    return point + offset
end