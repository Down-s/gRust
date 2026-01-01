-- TODO: Jump sounds

sound.Add({name = "Player.Wade", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "Player.Swim", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "SolidMetal.ImpactHard", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "SolidMetal.ImpactSoft", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "Concrete.ImpactHard", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "Concrete.ImpactSoft", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "Wood.ImpactHard", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})
sound.Add({name = "Wood.ImpactSoft", channel = CHAN_BODY, volume = 1.0, level = 20, sound = "common/null.wav"})

sound.Add({name = "HL2Player.BurnPain", channel = CHAN_VOICE, volume = 0.6, level = 75, sound = "rust/fire.mp3"})
sound.Add({name = "Bullets.DefaultNearmiss", channel = CHAN_STATIC, volume = 0.7, level = 140, sound = {">rust/bullet-ricochet-1.mp3", ">rust/bullet-ricochet-2.mp3", ">rust/bullet-ricochet-3.mp3", ">rust/bullet-ricochet-4.mp3", ">rust/bullet-ricochet-5.mp3", ">rust/bullet-ricochet-6.mp3"}})
sound.Add({name = "FX_RicochetSound.Ricochet", channel = CHAN_STATIC, volume = 0.5, level = 80, sound = {">rust/bullet-ricochet-1.mp3", ">rust/bullet-ricochet-2.mp3", ">rust/bullet-ricochet-3.mp3", ">rust/bullet-ricochet-4.mp3", ">rust/bullet-ricochet-5.mp3", ">rust/bullet-ricochet-6.mp3"}})

local function AddImpactSound(name, files)
    sound.Add({name = name .. ".BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = files})
end

sound.Add({name = "SolidMetal.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/metal_bullet_impact-1.mp3", "rust/metal_bullet_impact-2.mp3", "rust/metal_bullet_impact-3.mp3", "rust/metal_bullet_impact-4.mp3"}}) 
sound.Add({name = "Dirt.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/dirt_bullet_impact-1.mp3", "rust/dirt_bullet_impact-2.mp3", "rust/dirt_bullet_impact-3.mp3"}}) 
sound.Add({name = "Tile.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/concrete_impact_bullet1.mp3", "rust/concrete_impact_bullet2.mp3", "rust/concrete_impact_bullet3.mp3", "rust/concrete_impact_bullet4.mp3"}}) 
sound.Add({name = "Concrete.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/concrete_impact_bullet1.mp3", "rust/concrete_impact_bullet2.mp3", "rust/concrete_impact_bullet3.mp3", "rust/concrete_impact_bullet4.mp3"}}) 
sound.Add({name = "Glass.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/glass_bullet_impact-1.mp3", "rust/glass_bullet_impact-2.mp3", "rust/glass_bullet_impact-3.mp3"}}) 
sound.Add({name = "Water.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/water_bullet_impact-1.mp3", "rust/water_bullet_impact-2.mp3", "rust/water_bullet_impact-3.mp3"}}) 
sound.Add({name = "Flesh.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/flesh_bullet_impact-1.mp3", "rust/flesh_bullet_impact-2.mp3", "rust/flesh_bullet_impact-3.mp3", "rust/flesh_bullet_impact-4.mp3"}}) 
sound.Add({name = "Carpet.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/cloth_bullet_impact1.mp3", "rust/cloth_bullet_impact2.mp3", "rust/cloth_bullet_impact3.mp3", "rust/cloth_bullet_impact4.mp3"}}) 
sound.Add({name = "Sand.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/bullet-impact-sand-1.mp3", "rust/bullet-impact-sand-2.mp3", "rust/bullet-impact-sand-3.mp3", "rust/bullet-impact-sand-4.mp3"}}) 
sound.Add({name = "Default.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/generic-bullet-impact-1.mp3", "rust/generic-bullet-impact-2.mp3", "rust/generic-bullet-impact-3.mp3", "rust/generic-bullet-impact-4.mp3"}}) 
sound.Add({name = "Wood.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/wood_bullet_impact-1.mp3", "rust/wood_bullet_impact-2.mp3", "rust/wood_bullet_impact-3.mp3", "rust/wood_bullet_impact-4.mp3"}}) 
sound.Add({name = "Wood_Box.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/wood_bullet_impact-1.mp3", "rust/wood_bullet_impact-2.mp3", "rust/wood_bullet_impact-3.mp3", "rust/wood_bullet_impact-4.mp3"}}) 
sound.Add({name = "Wood_Solid.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/wood_bullet_impact-1.mp3", "rust/wood_bullet_impact-2.mp3", "rust/wood_bullet_impact-3.mp3", "rust/wood_bullet_impact-4.mp3"}}) 
sound.Add({name = "Wood_Panel.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/wood_bullet_impact-1.mp3", "rust/wood_bullet_impact-2.mp3", "rust/wood_bullet_impact-3.mp3", "rust/wood_bullet_impact-4.mp3"}}) 
sound.Add({name = "Wood_Plank.BulletImpact", channel = CHAN_STATIC, volume = 0.7, level = 75, sound = {"rust/wood_bullet_impact-1.mp3", "rust/wood_bullet_impact-2.mp3", "rust/wood_bullet_impact-3.mp3", "rust/wood_bullet_impact-4.mp3"}}) 

sound.Add({name = "Bounce.Shell", channel = CHAN_STATIC, volume = 1, level = SNDLVL_NORM, sound = {"rust/m39-shell-drop-001.mp3", "rust/m39-shell-drop-002.mp3", "rust/m39-shell-drop-003.mp3"}}) 

local function GetShoeType(pl)
    return "barefoot"
end

local MATERIAL_MAP = {
    ["grass"] = "grass",
    ["dirt"] = "dirt",
    ["snow"] = "snow",
    ["gravel"] = "gravel",
    ["rock"] = "stones",
    ["carpet"] = "cloth",
    ["mud"] = "forest",
    ["chainlink"] = "metal",
    ["metalgrate"] = "metal",
    ["metal"] = "metal",
    ["wood"] = "wood",
}

local TraceData = {}
local function GetGroundMaterial(pl)
    TraceData.start = pl:GetPos()
    TraceData.endpos = TraceData.start - Vector(0, 0, 32)
    TraceData.mins = pl:OBBMins()
    TraceData.maxs = pl:OBBMaxs()
    TraceData.filter = pl

    local tr = util.TraceHull(TraceData)
    local surfaceName = util.GetSurfacePropName(tr.SurfaceProps) or "default"
    local mat = MATERIAL_MAP[surfaceName] or "concrete"
    
    return mat
end

local function IsGrounded(pl)
    if (pl:GetMoveType() != MOVETYPE_WALK) then return false end
    return pl:OnGround()
end

local function IsRunning(pl)
    return pl:GetVelocity():Length2D() > pl:GetWalkSpeed()
end

local FOOTSTEP_FORMAT = "rust/footsteps/footstep-%s-%s-%s-00%d.mp3"
local function PlayStepSound(pl, volume, rf)
    if (pl:WaterLevel() != 0) then
        pl:EmitSound("rust/footsteps/footstep-water-med-" .. math.random(1,4) .. ".mp3", SNDLVL_70dB, 100, volume, CHAN_BODY, 0, 1, rf)
        return
    end

    local mat = GetGroundMaterial(pl)
    local shoes = GetShoeType(pl)
    local running = IsRunning(pl) and "run" or "walk"

    local path = string.format(FOOTSTEP_FORMAT, shoes, mat, running, math.random(1, 4))
    pl:EmitSound(path, SNDLVL_70dB, 100, volume, CHAN_BODY, 0, 1, rf)
end

function GM:PlayerFootstep(pl, pos, foot, sound, volume, rf)
    if (pl:Crouching() and !IsRunning(pl)) then return true end

    PlayStepSound(pl, volume, rf)
    return true
end