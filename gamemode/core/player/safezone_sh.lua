local PLAYER = FindMetaTable("Player")
if (SERVER) then
    util.AddNetworkString("gRust.SetSafeZone")

    function PLAYER:EnterSafeZone()
        self.InSafeZone = true

        net.Start("gRust.SetSafeZone")
        net.WriteBool(true)
        net.Send(self)

        self:SelectWeapon("rust_hands")
    end

    function PLAYER:ExitSafeZone()
        self.InSafeZone = false

        net.Start("gRust.SetSafeZone")
        net.WriteBool(false)
        net.Send(self)
    end
else
    net.Receive("gRust.SetSafeZone", function()
        LocalPlayer().InSafeZone = net.ReadBool()
    end)

    hook.Add("gRust.Loaded", "gRust.SafeZoneNotification", function()
        local safezone = gRust.CreateNotification()
        safezone:SetText("SAFE ZONE")
        safezone:SetIcon("safezone")
        safezone:SetColor(Color(94, 113, 40))
        safezone:SetIconColor(Color(145, 193, 20))
        safezone:SetTextColor(Color(240, 240, 209))
        safezone:SetCondition(function()
            return LocalPlayer():IsInSafeZone() and !LocalPlayer():IsCombatBlocked()
        end)
    end)
end

function PLAYER:IsInSafeZone()
    return self.InSafeZone
end