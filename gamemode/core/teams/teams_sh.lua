gRust.Teams = gRust.Teams or {}

local PLAYER = FindMetaTable("Player")
function PLAYER:GetTeam()
    return gRust.Teams[self.TeamID]
end

--
-- Interaction
--

function PLAYER:GetInteractable()
    if (CLIENT) then
        return LocalPlayer().TeamID ~= nil
    end

    return true
end

function PLAYER:GetInteractText()
    return "INVITE TO TEAM"
end

function PLAYER:GetInteractIcon()
    return "add"
end

if (SERVER) then
    util.AddNetworkString("gRust.InvitedToTeam")
    function PLAYER:Interact(pl)
        if (!IsValid(pl)) then return end
        if (!pl.TeamID) then return end
        if (self.TeamID == pl.TeamID) then
            pl:ChatPrint("This player is already in your team.")
            return
        elseif (self.TeamID) then
            pl:ChatPrint("This player is already in a team.")
            return
        end

        if (pl.LastTeamInvite and pl.LastTeamInvite > CurTime()) then
            pl:ChatPrint("You must wait before inviting another player.")
            return
        end

        pl.LastTeamInvite = CurTime() + 5
    
        self.TeamInviteID = pl.TeamID

        self:ChatPrint(string.format("You have been invited to %s's team. Open your inventory to accept/decline.", pl:Nick()))
        pl:ChatPrint(string.format("You have invited %s to your team.", self:Nick()))
        
        net.Start("gRust.InvitedToTeam")
            net.WritePlayer(pl)
        net.Send(self)
    end
end