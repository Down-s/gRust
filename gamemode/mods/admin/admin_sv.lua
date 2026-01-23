--[[
Commands such as !goto, !tp, !cloak, !god, !esp, !mute, !ban (for a while), and !unban are required.
And make a stack of ammo and medical syringes as in x100000
and make semi-automatic mods too x100 in crates
!ban,bot06,test,1000
]]
print("Admin commands loaded")
function FindIDName(name)
    for k, v in pairs(player.GetAll()) do
        if string.find(string.lower(v:Nick()), string.lower(name)) then return v end
    end
    return NULL
end

function AddESP(ply, msg)
    if ply.AdminESP == nil then ply.AdminESP = false end
    if string.sub(msg, 1, #"!esp") == "!esp" and ply:IsAdmin() then
        ply.AdminESP = not ply.AdminESP
        ply:SetNWBool("Admin_ESP", ply.AdminESP)
        local noclip_MSg = ply.AdminESP and "Activated" or "Deactivated"
        ply:ChatPrint("You've " .. noclip_MSg .. " ESP")
        return ""
    end
end

function AddTeleport(ply, msg)
    if string.sub(msg, 1, #"!tp") == "!tp" and ply:IsAdmin() then
        local explo = string.Explode(",", msg)
        local nick = FindIDName(explo[2])
        local tr = ply:GetEyeTrace()
        nick:SetPos(tr.HitPos + tr.HitNormal * 32 + ply:GetForward() * 24)
        ply:ChatPrint("You've Teleported " .. nick)
        return ""
    end
end

function AddGoto(ply, msg)
    if string.sub(msg, 1, #"!goto") == "!goto" and ply:IsAdmin() then
        local explo = string.Explode(",", msg)
        local nick = FindIDName(explo[2])
        ply:SetPos(nick:GetPos() + nick:GetForward() * 124)
        ply:ChatPrint("You've Goto'd " .. nick)
        return ""
    end
end

function AddCloak(ply, msg)
    if string.sub(msg, 1, #"!cloak") == "!cloak" and ply:IsAdmin() then
        ply:DrawShadow(false)
        ply:SetMaterial("models/effects/vol_light001")
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
        ply:Fire("alpha", visibility, 0)
        if IsValid(ply:GetActiveWeapon()) then
            ply:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA)
            ply:GetActiveWeapon():Fire("alpha", 0, 0)
            ply:GetActiveWeapon():SetMaterial("models/effects/vol_light001")
            if ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                ply:DrawWorldModel(false) -- tool gun has problems
            else
                ply:DrawWorldModel(true)
            end
        end

        ply:ChatPrint("You've Cloaked " .. ply:Nick())
        return ""
    end
end

function AddUnCloak(ply, msg)
    if string.sub(msg, 1, #"!uncloak") == "!uncloak" and ply:IsAdmin() then
        ply:DrawShadow(true)
        ply:SetMaterial("")
        ply:SetRenderMode(RENDERMODE_NORMAL)
        ply:Fire("alpha", 255, 0)
        local activeWeapon = ply:GetActiveWeapon()
        if IsValid(activeWeapon) then
            activeWeapon:SetRenderMode(RENDERMODE_NORMAL)
            activeWeapon:Fire("alpha", 255, 0)
            activeWeapon:SetMaterial("")
        end

        ply:ChatPrint("You've uncloaked " .. ply:Nick())
        return ""
    end
end

function AddNoClip(ply, msg)
    if ply.NoClip == nil then ply.NoClip = false end
    if string.sub(msg, 1, #"!noclip") == "!noclip" and ply:IsAdmin() then
        ply.NoClip = not ply.NoClip
        local noclip = ply.NoClip and MOVETYPE_NOCLIP or MOVETYPE_WALK
        local noclip_MSg = ply.NoClip and "Activated" or "Deactivated"
        ply:SetMoveType(noclip)
        ply:ChatPrint("You've " .. noclip_MSg .. " noclip")
        return ""
    end
end

function AddGodmode(ply, msg)
    if ply.GodMode == nil then ply.GodMode = false end
    if string.sub(msg, 1, #"!god") == "!god" and ply:IsAdmin() then
        ply.GodMode = not ply.GodMode
        local noclip_MSg = ply.GodMode and "Activated" or "Deactivated"
        if ply.GodMode then
            ply:GodEnable()
        else
            ply:GodDisable()
        end

        ply:ChatPrint("You've " .. noclip_MSg .. " GodMode")
        return ""
    end
end

hook.Add("CheckPassword", "access_whitelist", function(steamID64)
    if not file.IsDir("banned", "DATA") then file.CreateDir("banned") end
    local fr = file.Exists("banned/banned.txt", "DATA") and util.JSONToTable(file.Read("banned/banned.txt")) or {
        banned = false
    }

    local ture = false
    for k, v in pairs(fr) do
        if v and steamID64 == v.sid and v.banned then ture = true end
    end

    if ture == true then return false, "Banned: Rejected" end
end)

function AddBan(ply, msg)
    local findstr = string.find(msg, "!ban")
    if findstr and ply:IsAdmin() then
        local explo = string.Explode(",", msg)
        local nick = FindIDName(explo[2])
        if not file.IsDir("banned", "DATA") then
            file.CreateDir("banned")
            file.Write("banned/banned.txt", util.TableToJSON({}, true))
        end

        local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
        table.insert(frd, {
            nick = tostring(nick:Nick()),
            sid = nick:SteamID64(),
            banned = true,
            time = explo[4]
        })

        file.Write("banned/banned.txt", util.TableToJSON(frd, true))
        nick:Kick(explo[3])
        ply:ChatPrint("Banned: Reason: " .. explo[3] .. " Nick: " .. tostring(nick:Nick()))
        return ""
    end
end

function FindIDNameUnban(name)
    local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
    for k, v in pairs(frd) do
        if string.find(string.lower(v.nick), string.lower(name)) then return k end
    end
    return NULL
end

function AddKick(ply, msg)
    local findstr = string.find(msg, "!kick")
    if findstr and ply:IsAdmin() then
        local explo = string.Explode(",", msg)
        local nickz = FindIDNameUnban(explo[2])
        nickz:Kick(explo[3])
        ply:ChatPrint("Kicked: Nick: " .. tostring(nickz:Nick()))
        return ""
    end
end

function AddUnBan(ply, msg)
    local findstr = string.find(msg, "!unban")
    if findstr and ply:IsAdmin() then
        local explo = string.Explode(",", msg)
        local nickz = FindIDNameUnban(explo[2])
        if not file.Exists("banned/banned.txt", "DATA") then return end
        local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
        if frd == nil then return end
        frd[nickz].time = 0
        file.Write("banned/banned.txt", util.TableToJSON(frd, true))
        ply:ChatPrint("Unbanned: Nick: " .. tostring(frd[nickz].nick))
        return ""
    end
end

function AddKitBob(ply, msg)
    local findstr = string.find(msg, "!kit")
    if findstr then
        net.Start("Kit_BobTheBuilder")
        net.Send(ply)
        return ""
    end
end

function AlterTable(tbl)
    if not file.Exists("banned/banned.txt", "DATA") then return end
    local frd = util.JSONToTable(file.Read("banned/banned.txt", "DATA"))
    if frd == nil then return end
    for k, v in pairs(frd) do
        frd[k].time = (tonumber(v.time) or 0) - 1
        if frd[k].time <= 0 then table.remove(frd, k) end
    end

    file.Write("banned/banned.txt", util.TableToJSON(frd, true))
end

local cdBanned = 0
hook.Add("Tick", "test", function()
    if cdBanned >= CurTime() then return end
    cdBanned = CurTime() + 1
    local check = AlterTable()
    if check == nil then return end
    print(check)
end)