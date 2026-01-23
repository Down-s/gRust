AC = AC or {}
net.Receive("Siple_AC", function() AC.Loaded = true end)
timer.Create("DedacCheck", 1, 0, function()
    if ded and ded.SetBSendPacket then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and ded.ConVarSetFlags then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and ded.SetInterpolation then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and ded.SetSequenceInterpolation then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and SpoofConVar then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and GetBSendPacket then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and SetBSendPacket then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and SetTimeout then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and SendFile then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if ded and RequestFile then
        net.Start("FishyAC")
        net.SendToServer()
    end
end)

local oldhookadd = hook.Add
function hook.Add(str, str1, func)
    if str == "SendNetMsg" then
        net.Start("FishyAC")
        net.SendToServer()
    end

    if str == "ShouldBlockMove" then
        net.Start("FishyAC")
        net.SendToServer()
    end
    return oldhookadd(str, str1, func)
end

local requires = require
require = function(str)
    if str == "zxcmodule" then
        net.Start("FishyAC")
        net.SendToServer()
        return
    end
    return requires(str)
end