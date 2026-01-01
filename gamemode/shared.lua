GM.Name     = "gRust | Rust in Garry's Mod"
GM.Author   = "Down"
GM.Email    = "down@grust.co"
GM.Website  = "grust.co"

gRust       = gRust or {
    Config = {}
}

local IncludeSV = SERVER and include or function() end
local IncludeCL = CLIENT and include or AddCSLuaFile
local IncludeSH = function(path) IncludeSV(path) IncludeCL(path) end

local IncludeDir
IncludeDir = function(dir)
    dir = dir .. "/"
    local files, folders = file.Find(dir .. "*", "LUA")

    for _, file in ipairs(files) do
        if (string.find(file, "_sv.lua")) then
            IncludeSV(dir .. file)
        elseif (string.find(file, "_cl.lua")) then
            IncludeCL(dir .. file)
        elseif (string.EndsWith(file, ".lua")) then
            IncludeSH(dir .. file)
        end
    end

    for _, folder in ipairs(folders) do
        IncludeDir(dir .. folder)
    end
end

IncludeDir("rust/gamemode/libs")
IncludeDir("rust/gamemode/core")
IncludeDir("rust/gamemode/mods") -- Extra modules

hook.Run("gRust.Loaded")