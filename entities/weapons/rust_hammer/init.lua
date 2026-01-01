AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

gRust.CreateConfigValue("building/demolish.period", 60 * 60, true)
local DEMOLISH_PERIOD = gRust.GetConfigValue("building/demolish.period")

function SWEP:Initialize()
    self:SetHoldType("melee")
end

function SWEP:UpgradeStructure(ent, level)
    if (ent:GetClass() != "rust_structure") then return end
    local pl = self:GetOwner()
    if (!IsValid(pl)) then return end
    local MaxRange = math.pow((self.UpgradeRange * METERS_TO_UNITS) * 2, 2)
    if (ent:GetPos():DistToSqr(pl:EyePos()) > MaxRange) then return end
    if (ent:GetUpgradeLevel() >= level) then return end
    if (pl:IsBuildBlocked()) then return end

    local twigModel = ent:GetTwigModel()
    local structure = gRust.Structures[twigModel]
    if (!structure) then return end
    local upgradeLevel = self.UpgradeLevels[level]
    if (!upgradeLevel) then return end
    
    local cost = structure.Cost * upgradeLevel.CostMultiplier
    if (pl:ItemCount(upgradeLevel.Item) < cost) then return end

    local newModel = string.Replace(twigModel, "twig", upgradeLevel.ModelPrefix)
    ent:SetModel(newModel)
    ent:SetUpgradeLevel(level)
    ent:SetMaxHP(upgradeLevel.Health)
    ent:SetHP(upgradeLevel.Health)

    pl:RemoveItem(upgradeLevel.Item, cost)

    pl:EmitSound(string.format("building/%s_%i.wav", upgradeLevel.Sound, math.random(1, 3)))
    ParticleEffect("building_smoke", ent:GetPos(), ent:GetAngles())

    ent.Upkeep = {
        {
            Item = upgradeLevel.Item,
            Amount = (structure.Cost * upgradeLevel.CostMultiplier) / 5
        }
    }
end

util.AddNetworkString("gRust.UpgradeStructure")
net.Receive("gRust.UpgradeStructure", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (ent:GetPos():DistToSqr(pl:EyePos()) > MAX_REACH_RANGE_SQR) then return end
    if (pl.LastHammerANextHammerActionction && pl.NextHammerAction > CurTime()) then return end
    pl.NextHammerAction = CurTime() + 0.1
    if (!pl:HasPrivilegeForEntity(ent)) then return end
    local level = net.ReadUInt(3)

    local swep = pl:GetActiveWeapon()
    if (!IsValid(swep) || swep:GetClass() != "rust_hammer") then return end

    swep:UpgradeStructure(ent, level)
end)

util.AddNetworkString("gRust.RotateStructure")
net.Receive("gRust.RotateStructure", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (ent:GetClass() != "rust_structure") then return end
    if (ent:GetPos():DistToSqr(pl:EyePos()) > MAX_REACH_RANGE_SQR) then return end
    if (!pl:HasPrivilegeForEntity(ent)) then return end
    if (pl.LastHammerANextHammerActionction && pl.NextHammerAction > CurTime()) then return end
    pl.NextHammerAction = CurTime() + 0.1
    
    local structure = gRust.Structures[ent:GetTwigModel()]
    if (!structure) then return end

    local rotateAmount = structure.Rotate
    if (!rotateAmount or rotateAmount == 0) then return end

    local newAngles = ent:GetAngles()
    newAngles:RotateAroundAxis(newAngles:Up(), rotateAmount)
    ent:SetAngles(newAngles)

    for k, v in ipairs(ent:GetChildren()) do
        if (v.InitialRotation) then
            local newAngles = v.InitialRotation + rotateAmount
            local ang = v:GetAngles()
            ang:RotateAroundAxis(ang:Up(), rotateAmount)
            v:SetAngles(ang)
            v.InitialRotation = newAngles
        else
            v:SetAngles(v:GetAngles() + Angle(0, rotateAmount, 0))
        end
    end
end)

util.AddNetworkString("gRust.DemolishStructure")
net.Receive("gRust.DemolishStructure", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end
    if (ent:GetClass() != "rust_structure") then return end
    if (ent:GetPos():DistToSqr(pl:EyePos()) > MAX_REACH_RANGE_SQR) then return end
    if (!pl:HasPrivilegeForEntity(ent)) then return end
    if (ent:GetCreationTime() + DEMOLISH_PERIOD < CurTime()) then return end
    if (pl.LastHammerANextHammerActionction && pl.NextHammerAction > CurTime()) then return end
    pl.NextHammerAction = CurTime() + 0.1

    local structure = gRust.Structures[ent:GetTwigModel()]
    if (!structure) then return end
    
    ent:Remove()
end)