DEFINE_BASECLASS("rust_container")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

gRust.CreateConfigValue("building/tool_cupboard.radius", 625)
local BUILD_RADIUS = gRust.GetConfigValue("building/tool_cupboard.radius") ^ 2

gRust.ToolCupboards = gRust.ToolCupboards or {}

function ENT:Initialize()
    BaseClass.Initialize(self)
    gRust.ToolCupboards[#gRust.ToolCupboards + 1] = self
    self.ToolCupboardIndex = #gRust.ToolCupboards
end

function ENT:OnRemove()
    BaseClass.OnRemove(self)
    table.remove(gRust.ToolCupboards, self.ToolCupboardIndex)

    for k, v in ipairs(gRust.ToolCupboards) do
        v.ToolCupboardIndex = k
    end
end

function ENT:Interact(pl)
    if (self:IsAuthorizedToLock(pl) or !self:IsLocked()) then
        if (!self:IsPlayerAuthorized(pl)) then
            self:AuthorizePlayer(pl)
            
            if (!pl:IsBuildBlocked()) then
                pl:GiveBuildPrivilege(self)
            end
        end
    elseif (self.LockData and self.LockData.Item == "code_lock") then
        self:EmitSound("codelock.beep")
    end
end

util.AddNetworkString("gRust.ToolCupboard.Deauthorize")
net.Receive("gRust.ToolCupboard.Deauthorize", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) || ent:GetClass() != "rust_toolcupboard") then return end

    if (ent:IsPlayerAuthorized(pl)) then
        ent:DeauthorizePlayer(pl)
    end
end)

util.AddNetworkString("gRust.ToolCupboard.ClearAuthorized")
net.Receive("gRust.ToolCupboard.ClearAuthorized", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) || ent:GetClass() != "rust_toolcupboard") then return end

    if (ent:IsPlayerAuthorized(pl)) then
        ent.AuthorizedPlayers = {}
    end
end)

function ENT:CanPlayerAccess(pl)
    if (self:GetPos():DistToSqr(pl:GetPos()) > 20000) then return false end
    if (!self:IsAuthorizedToLock(pl)) then return false end
    if (util.TraceLine({
        start = pl:EyePos(),
        endpos = self:LocalToWorld(self:OBBCenter()),
        filter = pl
    }).Entity != self) then return false end

    return self:IsPlayerAuthorized(pl)
end

function ENT:AuthorizePlayer(pl)
    self.AuthorizedPlayers = self.AuthorizedPlayers or {}
    self.AuthorizedPlayers[pl:SteamID()] = true
end

function ENT:DeauthorizePlayer(pl)
    self.AuthorizedPlayers = self.AuthorizedPlayers or {}
    self.AuthorizedPlayers[pl:SteamID()] = nil
end

function ENT:IsPlayerAuthorized(pl)
    self.AuthorizedPlayers = self.AuthorizedPlayers or {}
    return self.AuthorizedPlayers[pl:SteamID()]
end

local THINK_INTERVAL = 3.5
local SECONDS_PER_HP = 20
function ENT:AddUpkeepItem(item, amount, ent)
    self.UpkeepItems = self.UpkeepItems or {}
    self.UpkeepItems[item] = (self.UpkeepItems[item] or 0) + amount
    local container = self.Containers[1]
    local itemCount = container:ItemCount(item)

    if (self.UpkeepItems[item] >= 1) then
        if (itemCount != 0) then
            local removeAmount = math.min(math.floor(self.UpkeepItems[item]), itemCount)
    
            container:RemoveItemLast(item, removeAmount)
            self.UpkeepItems[item] = self.UpkeepItems[item] - removeAmount
            
            ent:SetHP(math.max(0, ent:GetHP() + (THINK_INTERVAL / SECONDS_PER_HP)))
        else
            self.UpkeepItems[item] = 1
        end
    end

    if (itemCount == 0) then
        if (ent.DoDecay) then
            ent:DoDecay(THINK_INTERVAL)
        end
    end
end

gRust.UpkeepEntities = gRust.UpkeepEntities or {}
hook.Add("OnEntityCreated", "gRust.ToolCupboard.OnEntityCreated", function(ent)
    timer.Simple(0, function()
        if (ent.Upkeep) then
            local index = #gRust.UpkeepEntities + 1
            gRust.UpkeepEntities[index] = ent
            ent.UpkeepIndex = index
        end
    end)
end)

hook.Add("EntityRemoved", "gRust.ToolCupboard.EntityRemoved", function(ent)
    if (ent.UpkeepIndex) then
        table.remove(gRust.UpkeepEntities, ent.UpkeepIndex)
        for k, v in ipairs(gRust.UpkeepEntities) do
            v.UpkeepIndex = k
        end
    end
end)

function ENT:Think()
    if (self.NextThinkTime && self.NextThinkTime > CurTime()) then return end
    self.NextThinkTime = CurTime() + THINK_INTERVAL

    local upkeep = {
        wood = 0,
        stones = 0,
        metal_fragments = 0,
        hq_metal = 0
    }

    local pos = self:GetPos()
    local entities = gRust.UpkeepEntities
    for i = 1, #entities do
        local v = entities[i]
        if (pos:DistToSqr(v:GetPos()) <= BUILD_RADIUS) then
            if (IsValid(v.ToolCupboard) and v.ToolCupboard != self) then continue end

            local entUpkeep = v.Upkeep
            v.ToolCupboard = self

            for i = 1, #entUpkeep do
                local data = entUpkeep[i]
                local item = data.Item
                local amount = data.Amount

                self:AddUpkeepItem(item, (amount / 86400) * THINK_INTERVAL, v)

                upkeep[item] = upkeep[item] + amount
            end
        end
    end

    self:SetWoodUpkeep(upkeep["wood"] or 0)
    self:SetStoneUpkeep(upkeep["stones"] or 0)
    self:SetMetalUpkeep(upkeep["metal_fragments"] or 0)
    self:SetHQUpkeep(upkeep["hq_metal"] or 0)

    local upkeepEnd = self:GetUpkeepEnd()
    local protectedFor = self:GetProtectedFor()
    local newUpkeepEnd = CurTime() + protectedFor
    if (upkeepEnd != newUpkeepEnd) then
        self:SetUpkeepEnd(newUpkeepEnd)
    end
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)
    
    buffer:WriteUShort(table.Count(self.AuthorizedPlayers or {}))
    for k, v in pairs(self.AuthorizedPlayers or {}) do
        buffer:WriteString(k)
    end
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)

    local count = buffer:ReadUShort()
    self.AuthorizedPlayers = {}
    for i = 1, count do
        self.AuthorizedPlayers[buffer:ReadString()] = true
    end
end

local GIVE_PRIVILEGE = 0
local REMOVE_PRIVILEGE = 1
local BLOCK_BUILDING = 2
local function UpdatePlayers()
    local tcs = gRust.ToolCupboards
    local tcCount = #tcs
    for _, pl in player.Iterator() do
        if (!pl:IsNetworkReady()) then continue end

        local plPos = pl:GetPos()

        for j = 1, tcCount do
            local tc = tcs[j]
            local inRadius = tc:GetPos():DistToSqr(plPos) <= BUILD_RADIUS
            local isAuthorized = tc:IsPlayerAuthorized(pl)

            if (inRadius) then
                if (isAuthorized) then
                    pl:AddBuildPrivilegeEntity(tc)
                    pl:RemoveBuildBlockEntity(tc)
                else
                    pl:RemoveBuildPrivilegeEntity(tc)
                    pl:AddBuildBlockEntity(tc)
                end
            else
                pl:RemoveBuildBlockEntity(tc)
                pl:RemoveBuildPrivilegeEntity(tc)
            end
        end
        
        pl:VerifyBuildPrivilege()
        pl:VerifyBuildBlock()
    end
end

timer.Create("gRust.ToolCupboards.UpdatePlayers", 0.25, 0, UpdatePlayers)