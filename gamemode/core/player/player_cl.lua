local PLAYER = FindMetaTable("Player")

hook.Add("InitPostEntity", "PlayerInitPostEntity", function()
    LocalPlayer():OnReady()

    net.Start("gRust.PlayerReady")
    net.SendToServer()
end)

net.Receive("gRust.AddItemNotify", function(len)
    local item = net.ReadItem()
    local itemRegister = item:GetRegister()

    local notif = gRust.CreateNotification()
    notif:SetText(string.upper(itemRegister:GetName()))
    notif:SetDuration(5)
    notif:SetIcon("pickup")
    notif:SetColor(Color(80, 92, 51))
    notif:SetIconColor(Color(139, 228, 2))
    notif:SetTextColor(color_white)
    notif:SetIconPadding(4)
    local count = LocalPlayer():ItemCount(item:GetId())
    if ((count - item:GetQuantity()) > 0) then
        notif:SetSide(string.format("+%i (%i)", item:GetQuantity(), count))
    else
        notif:SetSide(string.format("+%i", item:GetQuantity()))
    end
end)

net.Receive("gRust.RemoveItemNotify", function(len)
    local itemRegister = gRust.GetItemRegisterFromIndex(net.ReadUInt(gRust.ItemIndexBits))
    local quantity = net.ReadUInt(itemRegister.StackBits)

    local notif = gRust.CreateNotification()
    notif:SetText(string.upper(itemRegister:GetName()))
    notif:SetDuration(5)
    notif:SetIcon("close")
    notif:SetColor(Color(111, 46, 35))
    notif:SetIconColor(Color(224, 74, 46))
    notif:SetTextColor(Color(191, 126, 117, 255))
    notif:SetIconPadding(6)
    notif:SetSide(string.format("-%i", quantity))
end)

net.Receive("gRust.ChatMessage", function(len, pl)
    local args = {}

    for i = 1, net.ReadUInt(4) do
        args[i] = net.ReadType()
    end
    
    chat.AddText(unpack(args))
end)

function gRust.PushEntity(ent)
    net.Start("gRust.PushEntity")
    net.WriteEntity(ent)
    net.SendToServer()
end