local PLAYER = FindMetaTable("Player")
function PLAYER:Pickup(ent)
    if (!IsValid(ent)) then return end
    if (!ent.PickupType or ent.PickupType == PickupType.None) then return end
    if (!ent.Item) then return end
    if (ent:GetPos():DistToSqr(self:EyePos()) > MAX_REACH_RANGE_SQR) then return end
    if (self:IsBuildBlocked()) then return end

    if (ent.Containers) then
        for k, v in ipairs(ent.Containers) do
            if (!v:IsEmpty()) then
                self:ChatPrint("This container is not empty")
                return
            end
        end
    end

    if (ent.PickupType == PickupType.Hammer) then
        if (self:GetActiveWeapon():GetClass() != "rust_hammer") then
            return
        end
    end

    if (ent:GetMaxHP() > 0) then
        local condition = (ent.Item:GetCondition() * (ent:GetHP() / ent:GetMaxHP()))
        if (condition) then
            ent.Item:SetCondition(condition - 0.2)
        end
    end
    
    self:AddItem(ent.Item, ITEM_PICKUP)
    ent:Remove()
end

util.AddNetworkString("gRust.Pickup")
net.Receive("gRust.Pickup", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end

    pl:Pickup(ent)
end)