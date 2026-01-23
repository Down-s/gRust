util.AddNetworkString("gRust.SendChat")
util.AddNetworkString("gRust.SendChat2")
local rankColors = {
    superadmin = Color(255, 85, 0),
    admin = Color(255, 170, 0),
    moderator = Color(85, 170, 255),
    vip = Color(170, 255, 85)
}

local function GetRank(ply)
    return ply:GetUserGroup() or "user"
end

local function GetRankColor(rank)
    return rankColors[rank] or Color(255, 255, 255)
end

net.Receive("gRust.SendChat2", function(len, ply)
    local msg = net.ReadString()
    local teamchat = net.ReadBool()
    local rank = GetRank(ply)
    local rankColor = GetRankColor(rank)
    if AddNoClip(ply, msg) then return end
    if AddGodmode(ply, msg) then return end
    if AddBan(ply, msg) then return end
    if AddUnBan(ply, msg) then return end
    if AddTeleport(ply, msg) then return end
    if AddGoto(ply, msg) then return end
    if AddCloak(ply, msg) then return end
    if AddUnCloak(ply, msg) then return end
    if AddESP(ply, msg) then return end
    if AddKick(ply, msg) then return end
    if AddKitBob(ply, msg) then return end
    -- Тільки для команди гравця
    if tobool(teamchat) == true then
        local teams = gRust.Teams[ply.TeamID]
        local teams_id_Tbl = {}
        for k, v in pairs(teams) do
            if k == "Members" then
                for i, j in pairs(v) do
                    table.insert(teams_id_Tbl, j.SteamID64)
                end
            end
        end

        -- Знаходимо всіх гравців тієї ж команди
        for _, v in ipairs(player.GetAll()) do
            if table.HasValue(teams_id_Tbl, v:SteamID64()) then
                net.Start("gRust.SendChat")
                net.WritePlayer(ply)
                net.WriteString(msg)
                net.WriteBool(teamchat)
                if rank ~= "user" then
                    net.WriteBool(true)
                    net.WriteString(rank)
                    net.WriteColor(rankColor)
                else
                    net.WriteBool(false)
                end

                net.Send(v)
            end
        end

        -- Відправляємо повідомлення всій команді
        print("[TEAM] " .. ply:Nick() .. ": " .. msg)
        return
    end

    -- Глобальний чат
    net.Start("gRust.SendChat")
    net.WritePlayer(ply)
    net.WriteString(msg)
    net.WriteBool(teamchat)
    if rank ~= "user" then
        net.WriteBool(true)
        net.WriteString(rank)
        net.WriteColor(rankColor)
    else
        net.WriteBool(false)
    end

    net.Broadcast()
    print("[GLOBAL] " .. ply:Nick() .. ": " .. msg)
    --[[local msg = net.ReadString()
    local teamchat = net.ReadBool()
    print(ply:Nick() .. " (" .. ply:SteamID() .. ") sent a chat message: " .. msg)
    if msg == "" or string.Trim(msg) == "" then return end
    -- if hook.Run("PlayerSay", ply, msg, teamchat, true) == false then return end
    local rank = GetRank(ply)
    local rankColor = GetRankColor(rank)
    net.Start("gRust.SendChat")
    net.WritePlayer(ply)
    net.WriteString(msg)
    net.WriteBool(teamchat)
    if rank ~= "user" then
        net.WriteBool(true)
        net.WriteString(rank)
        net.WriteColor(rankColor)
    else
        net.WriteBool(false)
    end

    net.Broadcast()]]
end)