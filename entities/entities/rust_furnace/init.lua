AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_container")

gRust.CreateConfigValue("farming/furnace.interval", 2)

function ENT:CanBurn()
    local inventory = self.Containers[1]
    for i = 1, inventory:GetSlots() do
        local item = inventory[i]
        if (!item) then continue end

        if (self.Furnace.Fuel[item:GetId()]) then
            return true
        end
    end

    return false
end

function ENT:FurnaceThink()
    if (!self:CanBurn()) then
        self:TurnOff()
        return
    end

    self.LastCooked = self.LastCooked or {}
    
    local inventory = self.Containers[1]
    local shouldStop = true
    for i = 1, inventory:GetSlots() do
        local item = inventory[i]
        if (!item) then continue end
        
        local cookable = self.Furnace.Cookables[item:GetId()]
        if (cookable) then
            self.LastCooked[i] = self.LastCooked[i] or 0
            if (self.LastCooked[i] + cookable[2] <= CurTime()) then
                self.LastCooked[i] = CurTime()

                inventory:Remove(i, 1)
                
                if (cookable[3] and math.random() > cookable[3]) then
                    continue
                end
                
                local newItem = gRust.CreateItem(cookable[1])
                local rem = inventory:InsertItem(newItem)
                if (rem) then
                    self:TurnOff()

                    local itemBag = gRust.CreateItemBag(rem, self:GetPos() + self:GetForward() * 20, self:GetAngles())
                    if (IsValid(itemBag)) then
                        itemBag:SetVelocity(self:GetForward() * 100)
                    end

                    return
                end
            end
        end
    end
end

function ENT:Think()
    self:DecayThink()
    
    if (self:GetBurning() and (self.NextFurnaceThink or 0) <= CurTime()) then
        self:FurnaceThink()
        self.NextFurnaceThink = CurTime() + gRust.GetConfigValue("farming/furnace.interval")
    end
end

function ENT:TurnOn()
    if (!self:CanBurn()) then return end
    
    self:SetBurning(true)
    self.NextFurnaceThink = CurTime() + gRust.GetConfigValue("farming/furnace.interval")
    self.BurningSound = self:StartLoopingSound("farming/furnace_loop.wav")
    self:EmitSound("furnace.start")

    ParticleEffectAttach("rust_fire", PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:TurnOff()
    self:SetBurning(false)
    self:EmitSound("furnace.stop")
    if (self.BurningSound) then
        self:StopLoopingSound(self.BurningSound)
    end

    self:StopParticles()
end

util.AddNetworkString("gRust.FurnaceToggle")
net.Receive("gRust.FurnaceToggle", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) or !(ent.gRust and ent.Furnace)) then return end
    if (!ent.Looters[pl]) then return end

    if (ent:GetBurning()) then
        ent:TurnOff()
    else
        ent:TurnOn()
    end
end)