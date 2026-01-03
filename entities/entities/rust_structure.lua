AddCSLuaFile()

ENT.Base = "rust_base"
DEFINE_BASECLASS(ENT.Base)

ENT.DeploySurface = true
ENT.ShouldSave = true

local function FoundationCheck(pos, ang, x, tr)
    local tr = {}
    tr.start = pos + Vector(0, 0, 70)
    tr.endpos = pos - Vector(0, 0, 120)
    tr.filter = pl
    tr = util.TraceLine(tr)
    
    return (tr.Hit and tr.HitTexture == "**displacement**"), "Not in terrain!"
end

gRust.Structures = {
    ["models/building_re/twig_foundation.mdl"] = gRust.CreateDeployable()
        :SetCost(50)
        :SetCustomCheck(FoundationCheck)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(64.5, 0, 0)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("raisedfoundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(-64.5, 0, 0)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("raisedfoundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, 64.5, 0)
                :SetAngle(0, 90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("raisedfoundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, -64.5, 0)
                :SetAngle(0, -90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("raisedfoundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("stairs"),
                
            gRust.CreateSocket()
                :SetPosition(64.5, 0, -64.5)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(-64.5, 0, -64.5)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(0, 64.5, -64.5)
                :SetAngle(0, 90, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(0, -64.5, -64.5)
                :SetAngle(0, -90, 0)
                :AddFemaleTag("raisedfoundation"),
                
                
            gRust.CreateSocket()
                :SetPosition(64.5, 0, 64.5)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(-64.5, 0, 64.5)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(0, 64.5, 64.5)
                :SetAngle(0, 90, 0)
                :AddFemaleTag("raisedfoundation"),
            gRust.CreateSocket()
                :SetPosition(0, -64.5, 64.5)
                :SetAngle(0, -90, 0)
                :AddFemaleTag("raisedfoundation")
        ),
    ["models/building_re/twig_foundation_trig.mdl"] = gRust.CreateDeployable()
        :SetCost(25)
        :SetCustomCheck(FoundationCheck)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 32.25, 0)
                :SetAngle(0, 60, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, -32.25, 0)
                :SetAngle(0, -60, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(-55.858638544096, 0, 0)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),

                
            gRust.CreateSocket()
                :SetPosition(0, 32.25, -64.5)
                :SetAngle(0, 60, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, -32.25, -64.5)
                :SetAngle(0, -60, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(-55.858638544096, 0, -64.5)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),

                
            gRust.CreateSocket()
                :SetPosition(0, 32.25, 64.5)
                :SetAngle(0, 60, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(0, -32.25, 64.5)
                :SetAngle(0, -60, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation"),
            gRust.CreateSocket()
                :SetPosition(-55.858638544096, 0, 64.5)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("foundation")
                :AddMaleTag("foundation")
        ),
    ["models/building_re/twig_wall.mdl"] = gRust.CreateDeployable()
        :SetCost(50)
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(0, 0, 125))
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 129)
                :SetAngle(0, 270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0.1, 129)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall")
        ),
    ["models/building_re/twig_wind.mdl"] = gRust.CreateDeployable()
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(0, 0, 125))
        :SetCost(35)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 129)
                :SetAngle(0, 270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 47.5)
                :SetAngle(0, 0, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("window")
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end),
            gRust.CreateSocket()
                :SetPosition(0, 0.1, 129)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall")
        ),
    ["models/building_re/twig_dframe.mdl"] = gRust.CreateDeployable()
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(0, 0, 125))
        :SetCost(35)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0.1, 129)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 129)
                :SetAngle(0, 270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(25.1, 0, 50)
                :SetAngle(0, 180, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("door"),
            gRust.CreateSocket()
                :SetPosition(-25.1, 0, 50)
                :SetAngle(0, 0, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("door"),
            gRust.CreateSocket()
                :SetPosition(25.1, 0, 50)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("vending_machine"),
            gRust.CreateSocket()
                :SetPosition(-25.1, 0, 50)
                :SetAngle(0, -90, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("vending_machine")
        ),
    ["models/building_re/twig_gframe.mdl"] = gRust.CreateDeployable()
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(0, 0, 125))
        :SetCost(50)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 0, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("doubledoor"),
            gRust.CreateSocket()
                :SetPosition(0.001, 0, 0)
                :SetAngle(0, 180, 0)
                :SetAngleOffset(0, 0, 0)
                :SetCustomCheck(function(ent, pos, ang)
                    return #ent:GetChildren() == 0
                end)
                :AddFemaleTag("doubledoor"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 129)
                :SetAngle(0, 270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall")
        ),
    ["models/building_re/twig_hwall.mdl"] = gRust.CreateDeployable()
        :SetCost(25)
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(59.5, 0, 32.5))
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, -2.1)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 66.6)
                :SetAngle(0, 270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall")
        ),
    ["models/building_re/twig_twall.mdl"] = gRust.CreateDeployable()
        :SetRotate(180)
        :SetFacePlayer(true)
        :SetRequireSocket(true)
        :SetCenter(Vector(59.5, 0, 43))
        :SetCost(25)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 90, 0)
                :SetAngleOffset(0, 90, 0)
                :AddMaleTag("wall")
            --[[gRust.CreateSocket()
                :SetPosition(0, 0, 43)
                :SetAngle(0, -270, 0)
                :SetAngleOffset(0, 0, 0)
                :AddFemaleTag("floor")
                :AddFemaleTag("wall")]]
        ),
    ["models/building_re/twig_floor.mdl"] = gRust.CreateDeployable()
        :SetCenter(Vector(0, 60, 0))
        :SetRequireSocket(true)
        :SetCost(25)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(64.5, 0, 0)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(-64.5, 0, 0)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, 64.5, 0)
                :SetAngle(0, 90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, -64.5, 0)
                :SetAngle(0, -90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("stairs")
        ),
    ["models/building_re/twig_fframe.mdl"] = gRust.CreateDeployable()
        :SetCenter(Vector(0, 60, 0))
        :SetRequireSocket(true)
        :SetCost(25)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(64.5, 0, 0)
                :SetAngle(0, 0, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(-64.5, 0, 0)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, 64.5, 0)
                :SetAngle(0, 90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, -64.5, 0)
                :SetAngle(0, -90, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor")
        ),
    ["models/building_re/twig_floor_trig.mdl"] = gRust.CreateDeployable()
        :SetRequireSocket(true)
        :SetCost(12.5)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 32.25, 0)
                :SetAngle(0, 60, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(0, -32.25, 0)
                :SetAngle(0, -60, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor"),
            gRust.CreateSocket()
                :SetPosition(-55.858638544096, 0, 0)
                :SetAngle(0, 180, 0)
                :AddFemaleTag("wall")
                :AddFemaleTag("floor")
                :AddMaleTag("floor")
        ),
    ["models/building_re/twig_steps.mdl"] = gRust.CreateDeployable()
        :SetCenter(Vector(-45, 27.5, 57.5))
        :SetRequireSocket(true)
        :SetCost(25)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(64.5, 0, -64.5)
                :SetAngle(0, 0, 0)
                :SetAngleOffset(0, -90, 0)
                :AddMaleTag("foundation")
        ),
    ["models/building_re/twig_lst.mdl"] = gRust.CreateDeployable()
        :SetRotate(90)
        :SetCenter(Vector(0, 0, 64.5))
        :SetRequireSocket(true)
        :SetCost(50)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 0, 0)
                :AddMaleTag("stairs")
        ),
    ["models/building_re/twig_ust.mdl"] = gRust.CreateDeployable()
        :SetRotate(90)
        :SetRequireSocket(true)
        :SetCenter(Vector(0, 0, 64.5))
        :SetCost(50)
        :AddSocket(
            gRust.CreateSocket()
                :SetPosition(0, 0, 0)
                :SetAngle(0, 0, 0)
                :AddMaleTag("stairs")
        )
}

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Int", 0, "UpgradeLevel")
end

function ENT:StructureSetup()
    local upgradeLevel = string.match(self:GetModel(), ".*/(.-)_")
    self.TwigModel = string.Replace(self:GetModel(), upgradeLevel, "twig")

    self:SetupSockets()

    if (SERVER) then
        local structure = gRust.Structures[self.TwigModel]
        if (!structure) then
            self:Remove()
            return
        end
    
        self.Upkeep = {
            {
                Item = "wood",
                Amount = structure.Cost / 5
            }
        }
    
        self.Decay = 2 * 60*60 -- 2 hours
    end
end

function ENT:Initialize()
    if (SERVER) then
        timer.Simple(0, function()
            self:PhysicsInitStatic(SOLID_VPHYSICS)
            self:SetMoveType(MOVETYPE_NONE)
            self:SetSolid(SOLID_VPHYSICS)
            
            if (string.find(self:GetModel(), "twig")) then
                self:SetMaxHP(10)
                self:SetHP(10)
            end
        end)
    end

    if (self:GetModel() and self:GetModel() != "models/error.mdl") then
        self:StructureSetup()
    end
end

function ENT:SetupSockets()
    local structure = gRust.Structures[self:GetTwigModel()]
    if (!structure) then return end
    local sockets = structure.Sockets
    for i = 1, #sockets do
        self:AddSocket(sockets[i])
    end
end

function ENT:GetTwigModel()
    return self.TwigModel
end

local FORWARD = Vector(1, 0, 0)
local RIGHT = Vector(0, 1, 0)
local UP = Vector(0, 0, 1)
local DOWN = Vector(0, 0, -1)
local WEAK_SIDES = {
    ["models/building_re/twig_wall.mdl"] = RIGHT,
    ["models/building_re/twig_wind.mdl"] = RIGHT,
    ["models/building_re/twig_dframe.mdl"] = RIGHT,
    ["models/building_re/twig_gframe.mdl"] = RIGHT,
    ["models/building_re/twig_hwall.mdl"] = RIGHT,
    ["models/building_re/twig_twall.mdl"] = RIGHT,
    ["models/building_re/twig_floor.mdl"] = DOWN,
    ["models/building_re/twig_floor_trig.mdl"] = DOWN
}

local DAMAGE_SCALES = {
    [0] = {
        Bullet = 0.1,
        Melee = 0.2,
        Explosive = 0.1,
    },
    [1] = {
        Bullet = 0.0175,
        Melee = 0.01,
        Explosive = 0.475,
    },
    [2] = {
        Bullet = 0.007,
        Melee = 0.002,
        Explosive = 0.475,
    },
    [3] = {
        Bullet = 0.000075,
        Melee = 0.0005,
        Explosive = 0.475,
    },
    [4] = {
        Bullet = 0.0000375,
        Melee = 0.0005,
        Explosive = 0.475,
    }
}

function ENT:OnTakeDamage(dmg)
    local weakSide = WEAK_SIDES[self:GetTwigModel()]
    local damageScale = DAMAGE_SCALES[self:GetUpgradeLevel()]
    local inflictor = dmg:GetInflictor()

    if (damageScale) then
        if (dmg:GetDamageType() == DMG_BULLET) then
            damageScale = damageScale.Bullet
        elseif (dmg:GetDamageType() == DMG_BLAST) then
            damageScale = damageScale.Explosive
        else
            damageScale = damageScale.Melee
        end

        if (IsValid(inflictor)) then
            if (inflictor.RaidEfficiency) then
                damageScale = damageScale * math.pow(inflictor.RaidEfficiency, self:GetUpgradeLevel())
            end
        end
    end

    if (weakSide) then
        local center = self:GetPos()
        local dmgPos = dmg:GetDamagePosition()
        local dir = (dmgPos - center):GetNormalized()
        local weakSide = self:LocalToWorldAngles(weakSide:Angle()):Forward()
        local isWeakSide = dir:Dot(weakSide) > 0
    
        if (isWeakSide) then
            damageScale = damageScale * 2
        end
    end

    local newHP = self:GetHP() - (dmg:GetDamage() * damageScale)
    if (newHP <= 0) then
        self:OnKilled(dmg)
    else
        self:SetHP(newHP)
    end
end

--
-- Saving and Loading
--

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)
    buffer:WriteString(self:GetModel())
    
    buffer:WriteFloat(self:GetHP())
    buffer:WriteFloat(self:GetMaxHP())
    
    buffer:WriteByte(self:GetUpgradeLevel())

    buffer:WriteByte(#self.Upkeep)
    for i = 1, #self.Upkeep do
        local data = self.Upkeep[i]
        buffer:WriteString(data.Item)
        buffer:WriteFloat(data.Amount)
    end
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)
    self:SetModel(buffer:ReadString())

    self:SetHP(buffer:ReadFloat())
    self:SetMaxHP(buffer:ReadFloat())
    
    self:StructureSetup()
    self:SetUpgradeLevel(buffer:ReadByte())

    local upkeep = {}
    local count = buffer:ReadByte()
    for i = 1, count do
        local item = buffer:ReadString()
        local amount = buffer:ReadFloat()
        upkeep[#upkeep + 1] = {
            Item = item,
            Amount = amount
        }
    end

    self.Upkeep = upkeep
end