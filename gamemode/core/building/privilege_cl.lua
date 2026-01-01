--
-- Build Privilege
--

net.Receive("gRust.GiveBuildPrivilege", function(len)
    LocalPlayer().BuildPrivilege = true
    LocalPlayer().BuildPrivilegeEnt = net.ReadEntity()
end)

net.Receive("gRust.RemoveBuildPrivilege", function(len)
    LocalPlayer().BuildPrivilege = false
    LocalPlayer().BuildPrivilegeEnt = nil
end)

--
-- Build Block
--

net.Receive("gRust.SetBuildBlock", function(len)
    LocalPlayer().BuildBlock = net.ReadBool()
end)

--
-- Notifications
--

hook.Add("gRust.Loaded", "gRust.BuildNotifications", function()
    local blocked = gRust.CreateNotification()
    blocked:SetColor(Color(198, 63, 42))
    blocked:SetIcon("construction")
    blocked:SetText("BUILDING BLOCKED")
    blocked:SetIconColor(Color(102, 27, 0))
    blocked:SetIconPadding(8)
    blocked:SetTextColor(Color(228, 179, 172))
    blocked:SetCondition(function()
        return LocalPlayer().BuildBlock
    end)

    local privilege = gRust.CreateNotification()
    privilege:SetIcon("construction")
    privilege:SetText("BUILDING PRIVILEGE")
    privilege:SetColor(Color(64, 78, 41))
    privilege:SetIconColor(Color(133, 183, 43))
    privilege:SetTextColor(Color(133, 183, 43))
    privilege:SetIconPadding(8)
    privilege:SetCondition(function()
        return LocalPlayer().BuildPrivilege
    end)

    local decaying = gRust.CreateNotification()
    decaying:SetIcon("alert")
    decaying:SetText("BUILDING DECAYING")
    decaying:SetColor(Color(173, 60, 30))
    decaying:SetIconColor(Color(206, 159, 89))
    decaying:SetTextColor(Color(206, 159, 89))
    decaying:SetIconPadding(8)
    decaying:SetCondition(function()
        if (!IsValid(LocalPlayer().BuildPrivilegeEnt)) then return false end
        local upkeepEnd = LocalPlayer().BuildPrivilegeEnt:GetUpkeepEnd()
        return upkeepEnd < CurTime()
    end)

    -- TODO: Home icon
    local upkeep = gRust.CreateNotification()
    upkeep:SetIcon("alert")
    upkeep:SetText("UPKEEP TIME")
    upkeep:SetColor(Color(73, 89, 42))
    upkeep:SetIconColor(Color(141, 217, 0))
    upkeep:SetTextColor(Color(255, 255, 255))
    upkeep:SetSideColor(Color(209, 255, 123, 175))
    upkeep:SetIconPadding(8)
    upkeep:SetCondition(function()
        if (!IsValid(LocalPlayer().BuildPrivilegeEnt)) then return false end
        local upkeepEnd = LocalPlayer().BuildPrivilegeEnt:GetUpkeepEnd()
        local protectedFor = upkeepEnd - CurTime()

        if (protectedFor < 60) then
            upkeep.Side = string.format("%i seconds", math.Round(protectedFor))
        elseif (protectedFor < 3600) then
            upkeep.Side = string.format("%i minutes", math.Round(protectedFor / 60))
        elseif (protectedFor < 86400) then
            upkeep.Side = string.format("%i hours", math.Round(protectedFor / 3600))
        else
            upkeep.Side = "> 72 hrs"
        end

        return protectedFor > 0
    end)
end)