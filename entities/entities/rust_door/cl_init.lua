include("shared.lua")

function ENT:Initialize()
    local PieMenu = gRust.CreatePieMenu()
    PieMenu:CreateOption()
        :SetTitle("Open")
        :SetDescription("Turn from being a closed door into an open one")
        :SetIcon("open_door")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return !self:GetOpen()
        end)
        :SetCallback(function()
            net.Start("gRust.ToggleDoor")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Close")
        :SetDescription("Turn from being an open door to a closed one")
        :SetIcon("open_door")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return self:GetOpen()
        end)
        :SetCallback(function()
            net.Start("gRust.ToggleDoor")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Knock")
        :SetDescription("Knock on this door")
        :SetIcon("knock")
        :SetCallback(function()
            net.Start("gRust.Knock")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Pickup")
        :SetDescription("Pick up this item and put it in your inventory")
        :SetIcon("give")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return  self:GetOpen() and
                    self:GetBodygroup(self.LockBodygroup) == 0
        end)
        :SetCallback(function()
            gRust.PickupEntity(self)
        end)

    PieMenu:CreateOption()
        :SetTitle("Unlock")
        :SetDescription("Unlock this door")
        :SetIcon("unlock")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return  self:GetBodygroup(self.LockBodygroup) != 0 and
                    self:GetSkin() == 1
        end)
        :SetCallback(function()
            net.Start("gRust.ToggleLock")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Lock")
        :SetDescription("Lock this door")
        :SetIcon("lock")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return  self:GetBodygroup(self.LockBodygroup) != 0 and
                    self:GetSkin() == 0
        end)
        :SetCallback(function()
            net.Start("gRust.ToggleLock")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Remove Lock")
        :SetDescription("Remove this lock and place it in your inventory")
        :SetIcon("give")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return  self:GetBodygroup(self.LockBodygroup) != 0 and
                    self:GetSkin() == 0 and
                    self:GetOpen()
        end)
        :SetCallback(function()
            net.Start("gRust.RemoveLock")
                net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Create Key")
        :SetDescription("Craft a key for this lock to allow friends to enter")
        :SetFooter(function()
            return string.format("25 x Wood (%s)", string.Comma(LocalPlayer():ItemCount("wood")))
        end)
        :SetIcon("key")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return self:GetBodygroup(self.LockBodygroup) == 2
        end)
        :SetCallback(function()
        end)

    PieMenu:CreateOption()
        :SetTitle("Change Lock Code")
        :SetDescription("Change the code to something else")
        :SetIcon("changecode")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return self:GetBodygroup(self.LockBodygroup) == 1
        end)
        :SetCallback(function()
            gRust.InputQuery.Keypad("MASTER CODE", function(code)
                net.Start("gRust.ChangeLockCode")
                    net.WriteEntity(self)
                    net.WriteUInt(tonumber(code), 14)
                net.SendToServer()
            end)
        end)

    PieMenu:CreateOption()
        :SetTitle("Unlock With Code")
        :SetDescription("This lock has a pass code which you must neter to unlock it")
        :SetIcon("unlock")
        :SetCondition(true, function()
            if (!IsValid(self)) then return false end
            return  self:GetBodygroup(self.LockBodygroup) == 1
        end)
        :SetCallback(function()
            gRust.InputQuery.Keypad("ENTER CODE", function(code)
                net.Start("gRust.EnterLockCode")
                    net.WriteEntity(self)
                    net.WriteUInt(tonumber(code), 14)
                net.SendToServer()
            end)
        end)

    self.ExtraOptions = PieMenu
end