net.Receive("gRust.SyncConfig", function(len)
    local strLen = net.ReadUInt(32)
    local str = net.ReadData(strLen)

    gRust.Config = util.JSONToTable(util.Decompress(str))
    hook.Run("gRust.ConfigUpdated")
    hook.Run("gRust.ConfigInitialized")
end)

function gRust.GetConfigValue(key, default)
    return gRust.Config[key] or default
end

hook.Add("gRust.Loaded", "gRust.Config", function()
    if (LocalPlayer().NetworkReady) then
        hook.Run("gRust.ConfigInitialized")
    end
end)