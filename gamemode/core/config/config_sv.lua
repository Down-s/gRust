local CONFIG_DIR = "grust/config/"

file.CreateDir(CONFIG_DIR)

gRust.Config = gRust.Config or {}
gRust.NetworkedConfig = gRust.NetworkedConfig or {}

function gRust.GetConfigValue(key, default)
    if (!gRust.ConfigLoaded) then
        gRust.LoadConfig()
    end

    local f = string.Split(key, "/")
    local fileName = f[1]
    local keyName = f[2]

    local value = gRust.Config[fileName] and gRust.Config[fileName][keyName]
    if (value == nil) then
        return default
    end

    return value
end

function gRust.SetConfigValue(key, value)
    if (!gRust.ConfigLoaded) then
        gRust.LoadConfig()
    end

    local f = string.Split(key, "/")
    local fileName = f[1]
    local keyName = f[2]

    gRust.Config[fileName] = gRust.Config[fileName] or {}
    gRust.Config[fileName][keyName] = value
    gRust.SaveConfig()
    
    hook.Run("gRust.ConfigUpdated")
end

function gRust.CreateConfigValue(key, default, networked)
    if (!gRust.ConfigLoaded) then
        gRust.LoadConfig()
    end

    local f = string.Split(key, "/")
    local fileName = f[1]
    local keyName = f[2]

    gRust.Config[fileName] = gRust.Config[fileName] or {}
    if (!gRust.Config[fileName][keyName]) then
        gRust.Config[fileName][keyName] = default
        gRust.SaveConfig()
    end

    if (networked) then
        gRust.NetworkedConfig[key] = gRust.Config[fileName][keyName]
    end
end

function gRust.SaveConfig()
    if (!gRust.ConfigLoaded) then
        gRust.LoadConfig()
    end

    for k, v in pairs(gRust.Config) do
        local fileName = k
        local fileData = util.TableToJSON(v, true)
        file.Write(CONFIG_DIR .. fileName .. ".json", fileData)
    end
end

function gRust.LoadConfig()
    gRust.Config = {}

    local files, dirs = file.Find(CONFIG_DIR .. "*", "DATA")
    for k, v in pairs(files) do
        local fileName = string.Replace(v, ".json", "")
        local fileData = file.Read(CONFIG_DIR .. v, "DATA")
        gRust.Config[fileName] = util.JSONToTable(fileData)
    end

    gRust.ConfigLoaded = true
    
    hook.Run("gRust.ConfigUpdated")
end

util.AddNetworkString("gRust.SyncConfig")
hook.Add("PrePlayerNetworkReady", "gRust.NetworkedConfig", function(pl)
    local str = util.TableToJSON(gRust.NetworkedConfig)
    str = util.Compress(str)

    net.Start("gRust.SyncConfig")
        net.WriteUInt(#str, 32)
        net.WriteData(str, #str)
    net.Send(pl)
end)

hook.Add("gRust.Loaded", "gRust.InitializeConfig", function()
    if (!gRust.ConfigLoaded) then
        gRust.LoadConfig()
    end

    gRust.LogSuccess("Config initialized")

    hook.Run("gRust.ConfigInitialized")
end)

concommand.Add("grust_reloadconfig", function(pl)
    if (IsValid(pl)) then return end

    gRust.LoadConfig()
    gRust.LogSuccess("Reloaded config")
end)