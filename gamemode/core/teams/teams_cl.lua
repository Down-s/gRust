local surface = surface
local draw = draw

function gRust.CreateTeam()
    net.Start("gRust.CreateTeam")
    net.SendToServer()
end

function gRust.LeaveTeam()
    net.Start("gRust.LeaveTeam")
    net.SendToServer()
end

net.Receive("gRust.SyncTeam", function(len)
    local teamid = net.ReadUInt(32)
    local ownerid = net.ReadString()
    local members = {}
    local index = {}
    
    for i = 1, net.ReadUInt(8) do
        local name = net.ReadString()
        local sid64 = net.ReadString()
        local isleader = net.ReadBool()
        
        members[i] = {
            Name = name,
            SteamID64 = sid64,
            IsLeader = isleader
        }

        index[sid64] = i
    end
    
    gRust.TeamsIndex = index
    gRust.Teams[teamid] = {
        OwnerID = ownerid,
        Members = members
    }

    LocalPlayer().TeamID = teamid

    hook.Run("gRust.UpdateTeamUI")
end)

net.Receive("gRust.TeamMemberAdded", function(len)
    local name = net.ReadString()
    local sid64 = net.ReadString()
    local isleader = net.ReadBool()

    local teamid = LocalPlayer().TeamID
    if (!teamid) then return end

    table.insert(gRust.Teams[teamid].Members, {
        Name = name,
        SteamID64 = sid64,
        IsLeader = isleader
    })

    gRust.TeamsIndex[sid64] = #gRust.Teams[teamid].Members
end)

net.Receive("gRust.TeamMemberRemoved", function(len)
    local index = net.ReadUInt(8)

    local teamid = LocalPlayer().TeamID
    if (!teamid) then return end

    -- Set our TeamID to nil if we're the one being removed
    for k, v in ipairs(gRust.Teams[teamid].Members) do
        if (k == index) then
            if (v.SteamID64 == LocalPlayer():SteamID64()) then
                LocalPlayer().TeamID = nil
                gRust.TeamsIndex = nil
                hook.Run("gRust.UpdateTeamUI")
            else
                gRust.TeamsIndex[v.SteamID64] = nil
            end
        end
    end

    table.remove(gRust.Teams[teamid].Members, index)
end)

net.Receive("gRust.TeamDeleted", function(len)
    local teamid = LocalPlayer().TeamID
    if (!teamid) then return end

    gRust.TeamsIndex = nil
    gRust.Teams[teamid] = nil
    LocalPlayer().TeamID = nil

    hook.Run("gRust.UpdateTeamUI")
end)

local teamPlayerCache = {}
local DEAD_COLOR = Color(165, 59, 11)
local ALIVE_COLOR = Color(186, 221, 43)
local OFFLINE_COLOR = Color(130, 130, 130)
hook.Add("PostRenderVGUI", "gRust.TeamUI", function()
	if (!gRust.Hud.ShouldDraw) then return end
    
    local pl = LocalPlayer()
    if (!pl.TeamID) then return end

    local team = gRust.Teams[pl.TeamID]
    if (!team) then return end

    local margin = gRust.Hud.Margin
    
    surface.SetFont("gRust.32px")
    local tw, th = surface.GetTextSize("✓")

    local colWidth = 0
    local x = margin * 1.4
    local y = ScrH() - margin
    for k, v in ipairs(team.Members) do
        local color = OFFLINE_COLOR
        local pl = teamPlayerCache[v.SteamID64]
        if (!IsValid(pl)) then
            pl = player.GetBySteamID64(v.SteamID64)
            teamPlayerCache[v.SteamID64] = pl
        end

        if (IsValid(pl)) then
            color = pl:Alive() and ALIVE_COLOR or DEAD_COLOR
        end

        local icon = v.IsLeader and "✓" or "•"
        draw.SimpleTextOutlined(string.format("%s %s", icon, v.Name), "gRust.32px", x, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, math.ceil(2 * gRust.Hud.Scaling), color_black)
        y = y - th

        local nameWidth, _ = surface.GetTextSize(v.Name)
        colWidth = math.max(colWidth, nameWidth)

        if (k % 4 == 0) then
            x = x + colWidth + tw + margin
            y = ScrH() - margin

            colWidth = 0
        end
    end
end)

--
-- Team Invites
--

net.Receive("gRust.InvitedToTeam", function(len)
    local inviter = net.ReadPlayer()
    local pl = LocalPlayer()

    pl.TeamInvite = inviter
    gRust.PlaySound("ui.notify")
end)

function gRust.AcceptTeamInvite()
    local pl = LocalPlayer()
    if (!pl.TeamInvite) then return end

    net.Start("gRust.AcceptTeamInvite")
    net.SendToServer()

    hook.Run("gRust.UpdateTeamUI")

    pl.TeamInvite = nil
end

function gRust.DeclineTeamInvite()
    local pl = LocalPlayer()
    if (!pl.TeamInvite) then return end

    pl.TeamInvite = nil

    hook.Run("gRust.UpdateTeamUI")
end