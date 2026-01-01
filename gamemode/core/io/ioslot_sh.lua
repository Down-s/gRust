local IOSLOT = {}
IOSLOT.__index = IOSLOT

gRust.AccessorFunc(IOSLOT, "Name", "Name", FORCE_STRING)
gRust.AccessorFunc(IOSLOT, "Pos", "Pos")
gRust.AccessorFunc(IOSLOT, "MainPower", "MainPower", FORCE_BOOL)

function gRust.CreateIOSlot()
    local slot = setmetatable({}, IOSLOT)
    return slot
end