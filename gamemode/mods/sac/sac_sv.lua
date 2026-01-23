util.AddNetworkString("Siple_AC")
util.AddNetworkString("FishyAC")
hook.Add("PlayerSpawn", "sipleAC", function(pl)
    net.Start("Siple_AC")
    net.Send(pl)
    timer.Simple(4, function() if IsValid(pl) then pl:SendLua[[if not AC.Loaded then RunConsoleCommand("x_ac_loaded","AC.Loaded not loaded") end]] end end)
end)

concommand.Add("x_ac_loaded", function(pl)
    if not file.IsDir("banned", "DATA") then
        file.CreateDir("banned")
        file.Write("banned/banned.txt", util.TableToJSON({}, true))
    end

    local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
    table.insert(frd, {
        nick = tostring(pl:Nick()),
        sid = pl:SteamID64(),
        banned = true,
        time = 10000000
    })

    file.Write("banned/banned.txt", util.TableToJSON(frd, true))
    for k, v in pairs(player.GetAll()) do
        v:ChatPrint("Banned: Reason: RunStringBlocked Nick: " .. tostring(pl:Nick()))
    end

    pl:Kick("Cheating RunStringBlocked")
end)

net.Receive("FishyAC", function(len, pl)
    if not file.IsDir("banned", "DATA") then
        file.CreateDir("banned")
        file.Write("banned/banned.txt", util.TableToJSON({}, true))
    end

    local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
    table.insert(frd, {
        nick = tostring(pl:Nick()),
        sid = pl:SteamID64(),
        banned = true,
        time = 100000000
    })

    file.Write("banned/banned.txt", util.TableToJSON(frd, true))
    for k, v in pairs(player.GetAll()) do
        v:ChatPrint("Banned: Reason: zxcmodule Nick: " .. tostring(pl:Nick()))
    end

    pl:Kick("Cheating zxc")
end)