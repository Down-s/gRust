AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local SPIN_INTERVAL = gRust.GetConfigValue("casino/roulette.interval", 40)

function ENT:Think()
    if (self:GetNextSpin() < CurTime() && !self.Spinning) then
        self:Spin()
    end
end

util.AddNetworkString("gRust.SpinWheel")
function ENT:Spin()
    self.Spinning = true

    local revolutions = math.random(5, 15)
    local angle = math.random(0, 360) + (360 * revolutions)

    net.Start("gRust.SpinWheel")
        net.WriteEntity(self)
        net.WriteFloat(angle)
    net.Broadcast()

    local initialSpeed = self:GetInitialSpeed(angle)
    local endTime = self:GetEndTime(initialSpeed)

    timer.Simple(endTime, function()
        self:SetNextSpin(CurTime() + SPIN_INTERVAL)
        self.Spinning = false

        local segment = self:GetSegment(angle)
        local index = tonumber(self.Segments[segment])
        local winType = self.WinTypes[index]

        for k, v in ipairs(self.CasinoBoxes) do
            local container = v.Containers[1]
            local winnings = 0
            local played = false
            for i = 1, 5 do
                local item = container[i]
                if (!IsValid(item) || item:GetId() ~= "scrap") then continue end

                local amount = item:GetQuantity()
                if (index == i) then
                    winnings = winnings + (amount * winType.multiplier)
                end

                container[i] = nil
                played = true
            end

            if (winnings == 0) then
                if (played) then
                    v:EmitSound("casino.lose")
                end
            else
                local scrap = container[6]
                if (IsValid(scrap) && scrap:GetId() == "scrap") then
                    scrap:SetQuantity(scrap:GetQuantity() + winnings)
                else
                    container[6] = gRust.CreateItem("scrap", winnings)
                end
            
                v:EmitSound("casino.win")
            end

            container:SyncAll()
        end
    end)
end