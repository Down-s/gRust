SWEP.Base = "rust_swep"

SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/darky_m/rust/w_buildingplan.mdl"

SWEP.Primary.Automatic = false

SWEP.BuildingBlocks = {
    {
        Model = "models/building_re/twig_floor_trig.mdl",
        Name = "Floor Triangle",
        Description = [[A floor, or ceiling, depending on where you're standing]],
        Icon = "build.floor_triangle",
    },
    {
        Model = "models/building_re/twig_fframe.mdl",
        Name = "Floor Frame",
        Description = [[A frame that lets you attach various blocks into]],
        Icon = "build.floor_frame",
    },
    {
        Model = "models/building_re/twig_wall.mdl",
        Name = "Wall",
        Description = [[Secure your base by enclosing it in walls]],
        Icon = "build.wall",
    },
    {
        Model = "models/building_re/twig_dframe.mdl",
        Name = "Doorway",
        Description = [[An entrance to a room or building through a door]],
        Icon = "build.doorframe",
    },
    {
        Model = "models/building_re/twig_wind.mdl",
        Name = "Window",
        Description = [[An opening in a wall, perfect for placing window bars in]],
        Icon = "build.wall_window",
    },
    {
        Model = "models/building_re/twig_gframe.mdl",
        Name = "Wall Frame",
        Description = [[A frame that lets you attach various blocks into]],
        Icon = "build.wall_frame",
    },
    {
        Model = "models/building_re/twig_hwall.mdl",
        Name = "Half Wall",
        Description = [[Half the height of a normal wall]],
        Icon = "build.wall_half",
    },
    {
        Model = "models/building_re/twig_twall.mdl",
        Name = "Low Wall",
        Description = [[One third the height of a normal wall]],
        Icon = "build.wall_low",
    },
    {
        Model = "models/building_re/twig_ust.mdl",
        Name = "U Shaped Stairs",
        Description = [[U Shaped Stairs]],
        Icon = "build.stairs_u",
    },
    {
        Model = "models/building_re/twig_lst.mdl",
        Name = "Stairs L Shape",
        Description = [[Stairs that are an L shape]],
        Icon = "build.stairs_u",
    },
    {
        Model = "models/building_re/twig_foundation.mdl",
        Name = "Foundation",
        Description = [[Every house needs a foundation]],
        Icon = "build.foundation",
    },
    {
        Model = "models/building_re/twig_foundation_trig.mdl",
        Name = "Triangle Foundation",
        Description = [[Every house needs a foundation]],
        Icon = "build.triangle_foundation",
    },
    {
        Model = "models/building_re/twig_steps.mdl",
        Name = "Steps",
        Description = [[Attaches to foundations or placed on top of floors, allows the player to move from one level to another with ease]],
        Icon = "build.foundation_steps",
    },
    {
        Model = "models/building_re/twig_floor.mdl",
        Name = "Floor",
        Description = [[A floor, or ceiling, depending on where you're standing]],
        Icon = "build.floor",
    },
}

for i = 1, #SWEP.BuildingBlocks do
    util.PrecacheModel(SWEP.BuildingBlocks[i].Model)
end

local function IsInTerrain(pos)
    local tr = {}
    tr.start = pos
    tr.endpos = pos - Vector(0, 0, 120)
    tr.filter = pl
    tr = util.TraceLine(tr)
    return (tr.Hit and tr.HitTexture == "**displacement**")
end

function SWEP:GetBuildTransform(index, rotation)
    local pl = self:GetOwner()
    local tr = pl:GetBuildTrace()

    local model = self.BuildingBlocks[index].Model
    local structure = gRust.Structures[model]

    local pos = tr.HitPos
    pos, ang, validPlacement, reason = pl:GetBuildTransform(structure, rotation)

    return pos, ang, validPlacement, reason or "Invalid Placement!"
end