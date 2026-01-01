--
-- Resource Initialization
--

local function PrecacheParticles()
    game.AddParticles("particles/rust.pcf")
    PrecacheParticleSystem("rust_fire")
    PrecacheParticleSystem("rust_inc")
    PrecacheParticleSystem("rust_fire_ent")
    PrecacheParticleSystem("rust_fire_vm")
    PrecacheParticleSystem("rust_explode")
    PrecacheParticleSystem("rust_big_explosion")
    PrecacheParticleSystem("generic_smoke")

    game.AddParticles("particles/grust_particle.pcf")
    PrecacheParticleSystem("building_smoke")
end

local function AddSounds()
    local gunshots = file.Find( "sound/weapons/rust_distant/*", "GAME" )
    local mp3s = file.Find( "sound/weapons/rust_mp3/*.mp3", "GAME" )
    local wavs = file.Find( "sound/weapons/rust/*.wav", "GAME" )
    
    for i = 1, #mp3s do
        local snd = string.sub(mp3s[i], 1, -5)
        sound.Add(
            {
                name = "darky_rust." .. snd,
                channel = CHAN_STATIC,
                volume = 1.0,
                soundlevel = 180,
                sound = "weapons/rust_mp3/" .. snd .. ".mp3"
            }
        )	
    end
    
    for i = 1, #wavs do
        local snd = string.sub(wavs[i], 1, -5)
        sound.Add(
            {
                name = "darky_rust." .. snd,
                channel = CHAN_STATIC,
                volume = 1.0,
                soundlevel = 180,
                sound = "weapons/rust/" .. snd .. ".wav"
            }
        )	
    end
    
    for i=1, #gunshots do
        local snd = string.sub(gunshots[i], 1, -5)
        sound.Add(
            {
                name = "darky_rust." .. snd,
                channel = CHAN_STATIC,
                volume = 15.0,
                soundlevel = 511,
                sound = "^weapons/rust_distant/" .. snd .. ".mp3"
            }
        )	
    end
end

local function AddDecals()
    game.AddDecal("TreeCross", "decals/decal_xspray_a_red")
end

hook.Add("gRust.Loaded", "gRust.LoadResources", function()
    PrecacheParticles()
    AddSounds()
    AddDecals()
end)