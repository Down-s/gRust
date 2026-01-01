function gRust.Craft(id, amount)
    local index = gRust.GetItemRegister(id):GetIndex()
    
    net.Start("gRust.Craft")
        net.WriteUInt(index, gRust.ItemIndexBits)
        net.WriteUInt(tonumber(amount), 8)
    net.SendToServer()
end

function gRust.RemoveFromCraftingQueue(index)
    net.Start("gRust.RemoveFromCraftingQueue")
        net.WriteUInt(index, 8)
    net.SendToServer()
end

net.Receive("gRust.AddToCraftQueue", function(len)
    local index = net.ReadUInt(gRust.ItemIndexBits)
    local amount = net.ReadUInt(4)

    local item = gRust.GetItemRegisterFromIndex(index)
    local pl = LocalPlayer()

    pl.CraftQueue = pl.CraftQueue or {}
    pl.CraftQueue[#pl.CraftQueue + 1] = {
        Item = item:GetId(),
        Amount = amount,
        Total = amount,
    }

    if (#pl.CraftQueue == 1) then
        local register = gRust.GetItemRegister(item:GetId())
        pl.CraftQueue[1].End = CurTime() + register:GetCraftTime()
    end

    pl.CraftCache = pl.CraftCache or {}
    pl.CraftCache[item:GetId()] = (pl.CraftCache and pl.CraftCache[item:GetId()] or 0) + amount

    hook.Run("gRust.CraftQueueUpdated", pl)
end)

net.Receive("gRust.PopCraftingQueue", function(len)
    local pl = LocalPlayer()
    local queueItem = pl.CraftQueue[1]
    if (!queueItem) then return end

    queueItem.Amount = queueItem.Amount - 1
    if (queueItem.Amount <= 0) then
        table.remove(pl.CraftQueue, 1)
    end

    pl.CraftCache[queueItem.Item] = pl.CraftCache[queueItem.Item] - 1
    if (pl.CraftCache[queueItem.Item] <= 0) then
        pl.CraftCache[queueItem.Item] = nil
    end

    if (pl.CraftQueue[1]) then
        local register = gRust.GetItemRegister(pl.CraftQueue[1].Item)
        pl.CraftQueue[1].End = CurTime() + register:GetCraftTime()
    end

    hook.Run("gRust.CraftQueueUpdated", pl)
end)

net.Receive("gRust.RemoveFromCraftingQueue", function(len)
    local pl = LocalPlayer()
    local index = net.ReadUInt(8)

    pl.CraftCache[pl.CraftQueue[index].Item] = pl.CraftCache[pl.CraftQueue[index].Item] - pl.CraftQueue[index].Amount
    
    if (pl.CraftCache[pl.CraftQueue[index].Item] <= 0) then
        pl.CraftCache[pl.CraftQueue[index].Item] = nil
    end

    table.remove(pl.CraftQueue, index)

    hook.Run("gRust.CraftQueueUpdated", pl)
end)

net.Receive("gRust.ClearCraftingQueue", function(len)
    local pl = LocalPlayer()
    pl.CraftQueue = nil
    pl.CraftCache = nil

    hook.Run("gRust.CraftQueueUpdated", pl)
end)

hook.Add("gRust.Loaded", "gRust.CraftQueue", function()
    local notif = gRust.CreateNotification()
    notif:SetIcon(nil)
    notif:SetColor(Color(40, 106, 144))
    notif:SetIconColor(Color(79, 148, 190, 255))
    notif:SetCondition(function()
        return LocalPlayer().CraftQueue and #LocalPlayer().CraftQueue > 0
    end)
    notif.Update = function(self)
        local pl = LocalPlayer()
        if (!pl.CraftQueue) then return end

        local queueItem = pl.CraftQueue[1]
        local register = gRust.GetItemRegister(queueItem.Item)

        if (queueItem.Amount > 1) then
            self.Text = string.format("%s (%i)", string.upper(register:GetName()), queueItem.Amount)
        else
            self.Text = string.upper(register:GetName())
        end

        local timeLeft = (queueItem.End or CurTime()) - CurTime()
        self.Side = string.format("%is", math.ceil(timeLeft))
    end
    notif.PaintOver = function(self, x, y, w, h)
        local rot = math.sin(CurTime() * 1.5) * 360
    
        local iconPadding = self.IconPadding * gRust.Hud.Scaling
        surface.SetDrawColor(self.IconColor)
        surface.SetMaterial(gRust.GetIcon("gear"))
        surface.DrawTexturedRectRotated(x + h * 0.5, y + h * 0.5, h - iconPadding * 2, h - iconPadding * 2, rot)
    end
end)

--
-- Notifications
--

local CachedWorkbenchTier = 0
timer.Create("gRust.CacheWorkbenchTier", 1, 0, function()
    CachedWorkbenchTier = LocalPlayer().GetWorkbenchTier and LocalPlayer():GetWorkbenchTier()
end)

local WorkbenchNotificationColors = {
    [1] = {Color(68, 80, 42), Color(139, 206, 2)},
    [2] = {Color(36, 62, 84), Color(3, 122, 204)},
    [3] = {Color(105, 68, 42), Color(204, 93, 7)}
}

hook.Add("gRust.Loaded", "gRust.WorkbenchNotifications", function()
    for i = 1, 3 do
        local cols = WorkbenchNotificationColors[i]

        local workbench = gRust.CreateNotification()
        workbench:SetColor(cols[1])
        workbench:SetIconColor(cols[2])
        workbench:SetTextColor(cols[2])
        workbench:SetCondition(function()
            return CachedWorkbenchTier == i
        end)
        workbench.Update = function(self)
            self.Text = "WORKBENCH LEVEL " .. i
            self.Icon = "gear"
        end
    end
end)

function gRust.GetCraftingAmount(id)
    local pl = LocalPlayer()
    if (!pl.CraftCache) then return 0 end

    return pl.CraftCache[id] or 0
end