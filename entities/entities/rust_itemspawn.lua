ENT.Base = "base_entity"
ENT.Type = "point"

function ENT:Initialize()
    local itemid = self.item
    local time = self.respawntime or 0
    local amount = self.amount or 1

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local currentEnt = nil

    local function Respawn()
        if (!IsValid(currentEnt)) then
            local item = gRust.CreateItem(itemid, amount)
            currentEnt = gRust.CreateItemBag(item, pos, ang)
        end
    end

    if (time != 0) then
        timer.Create("gRust.ItemRespawn." .. self:EntIndex(), time, 0, Respawn)
    end

    timer.Simple(0, Respawn)

    self:Remove()
end

function ENT:KeyValue(key, value)
    if (key == "item") then
        self.item = value
    elseif (key == "respawntime") then
        self.respawntime = tonumber(value)
    elseif (key == "amount") then
        self.amount = tonumber(value)
    end
end