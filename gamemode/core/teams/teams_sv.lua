hook.Add("gRust.Loaded", "gRust.InitializeTeamSystem", function()
    gRust.LocalQuery([[
        CREATE TABLE IF NOT EXISTS grust_teams(
            id INTEGER NOT NULL,
            ownerid BIGINT NOT NULL,
            PRIMARY KEY(id)
        );
    
        CREATE TABLE IF NOT EXISTS grust_teamplayers(
            uid BIGINT NOT NULL,
            name VARCHAR(32) NOT NULL,
            teamid INTEGER NOT NULL,
            isleader BOOLEAN NOT NULL,
            PRIMARY KEY(uid)
        );
    ]])
end)

hook.Add("gRust.Wipe", "gRust.ClearTeams", function(bpWipe, scheduled)
    gRust.LocalQuery("DELETE FROM grust_teams")
    gRust.LocalQuery("DELETE FROM grust_teamplayers")
end)

function gRust.CreateTeam(pl)
    if (!IsValid(pl)) then return end
    if (pl.TeamID) then return end

    local sid = sql.SQLStr(pl:SteamID64())
    gRust.LocalQuery(string.format("INSERT INTO grust_teams(ownerid) VALUES(%s)", sid))
    gRust.LocalQuery("SELECT LAST_INSERT_ROWID()", function(data)
        local id = tonumber(data[1]["LAST_INSERT_ROWID()"])
        gRust.LocalQuery(string.format("INSERT INTO grust_teamplayers(uid, name, teamid, isleader) VALUES(%s, %s, %s, 1)", sid, sql.SQLStr(pl:Nick()), id))
        pl.TeamID = id

        gRust.Teams[id] = {
            OwnerID = pl:SteamID64(),
            Members = {
                {
                    Name = pl:Nick(),
                    SteamID64 = pl:SteamID64(),
                    IsLeader = true
                }
            }
        }
        
        gRust.SyncTeam(pl)
    end)
end

util.AddNetworkString("gRust.TeamMemberRemoved")
function gRust.RemoveTeamMember(teamid, sid)
    local team = gRust.Teams[teamid]
    if (!team) then return end

    if (sid == team.OwnerID) then
        gRust.DeleteTeam(teamid)
        return
    end

    local RF = RecipientFilter()
    local index
    for i = 1, #team.Members do
        local member = team.Members[i]
        
        local pl = player.GetBySteamID64(member.SteamID64)
        if (IsValid(pl)) then
            RF:AddPlayer(pl)
        end
        
        if (member.SteamID64 == sid) then
            table.remove(team.Members, i)
            index = i
            break
        end
    end

    if (index) then
        net.Start("gRust.TeamMemberRemoved")
            net.WriteUInt(index, 8)
        net.Send(RF)

        gRust.LocalQuery(string.format("DELETE FROM grust_teamplayers WHERE uid = %s", sql.SQLStr(sid)))

        local pl = player.GetBySteamID64(sid)
        if (IsValid(pl)) then
            pl.TeamID = nil
        end
    end
end

util.AddNetworkString("gRust.TeamDeleted")
function gRust.DeleteTeam(teamid)
    local team = gRust.Teams[teamid]
    if (!team) then return end

    local RF = RecipientFilter()
    for i = 1, #team.Members do
        local member = team.Members[i]
        
        local pl = player.GetBySteamID64(member.SteamID64)
        if (IsValid(pl)) then
            RF:AddPlayer(pl)
            pl.TeamID = nil
        end
    end

    net.Start("gRust.TeamDeleted")
    net.Send(RF)

    gRust.LocalQuery(string.format("DELETE FROM grust_teams WHERE id = %s", teamid))
    gRust.LocalQuery(string.format("DELETE FROM grust_teamplayers WHERE teamid = %s", teamid))

    gRust.Teams[teamid] = nil
end

util.AddNetworkString("gRust.TeamMemberAdded")
function gRust.AddTeamMember(teamid, pl)
    local team = gRust.Teams[teamid]
    if (!team) then return end
    if (pl.TeamID) then return end

    local sid = sql.SQLStr(pl:SteamID64())
    gRust.LocalQuery(string.format("INSERT INTO grust_teamplayers(uid, name, teamid, isleader) VALUES(%s, %s, %s, 0)", sid, sql.SQLStr(pl:Nick()), teamid))

    local RF = RecipientFilter()
    for i = 1, #team.Members do
        local member = team.Members[i]
        
        local pl = player.GetBySteamID64(member.SteamID64)
        if (IsValid(pl)) then
            RF:AddPlayer(pl)
        end
    end

    net.Start("gRust.TeamMemberAdded")
        net.WriteString(pl:Nick())
        net.WriteString(pl:SteamID64())
        net.WriteBool(false)
    net.Send(RF)

    pl.TeamID = teamid

    table.insert(team.Members, {
        Name = pl:Nick(),
        SteamID64 = pl:SteamID64(),
        IsLeader = false
    })

    gRust.SyncTeam(pl)
end

util.AddNetworkString("gRust.SyncTeam")
function gRust.SyncTeam(pl)
    local teamid = pl.TeamID
    if (!teamid) then return end

    local team = gRust.Teams[teamid]
    if (!team) then return end

    net.Start("gRust.SyncTeam")
        net.WriteUInt(teamid, 32)
        net.WriteString(team.OwnerID)
        net.WriteUInt(#team.Members, 8)
        for i = 1, #team.Members do
            local member = team.Members[i]
            net.WriteString(member.Name)
            net.WriteString(member.SteamID64)
            net.WriteBool(member.IsLeader)
        end
    net.Send(pl)
end

function gRust.LoadTeam(teamid, cback)
    gRust.LocalQuery(string.format("SELECT * FROM grust_teams WHERE id = %s", teamid), function(data)
        if (!data or #data == 0) then return end

        local team = data[1]
        local ownerid = team.ownerid

        gRust.LocalQuery(string.format("SELECT * FROM grust_teamplayers WHERE teamid = %s", teamid), function(data)
            if (!data or #data == 0) then return end

            local members = {}
            for i = 1, #data do
                local member = data[i]
                table.insert(members, {
                    Name = member.name,
                    SteamID64 = member.uid,
                    IsLeader = member.isleader == 1
                })
            end

            gRust.Teams[teamid] = {
                OwnerID = ownerid,
                Members = members
            }

            if (cback) then
                cback()
            end
        end)
    end)
end

util.AddNetworkString("gRust.CreateTeam")
net.Receive("gRust.CreateTeam", function(len, pl)
    if (!IsValid(pl)) then return end
    if (pl.TeamID) then return end

    gRust.CreateTeam(pl)
end)

util.AddNetworkString("gRust.LeaveTeam")
net.Receive("gRust.LeaveTeam", function(len, pl)
    if (!IsValid(pl)) then return end
    if (!pl.TeamID) then return end

    gRust.RemoveTeamMember(pl.TeamID, pl:SteamID64())
end)

util.AddNetworkString("gRust.AcceptTeamInvite")
net.Receive("gRust.AcceptTeamInvite", function(len, pl)
    if (!IsValid(pl)) then return end
    if (pl.TeamID) then return end
    
    local inviteID = pl.TeamInviteID
    if (!inviteID) then return end

    gRust.AddTeamMember(inviteID, pl)
end)

hook.Add("PlayerNetworkReady", "gRust.SyncTeam", function(pl)
    gRust.LocalQuery(string.format("SELECT teamid FROM grust_teamplayers WHERE uid = %s", sql.SQLStr(pl:SteamID64())), function(data)
        if (!data or #data == 0) then return end
    
        local teamid = tonumber(data[1].teamid)
        if (!teamid) then return end
        
        if (gRust.Teams[teamid]) then
            pl.TeamID = teamid
            gRust.SyncTeam(pl)
        else
            gRust.LoadTeam(teamid, function()
                pl.TeamID = teamid
                gRust.SyncTeam(pl)
            end)
        end
    end)
end)