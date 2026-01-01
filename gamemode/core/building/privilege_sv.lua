--
-- Build Privilege
--

local PLAYER = FindMetaTable("Player")

util.AddNetworkString("gRust.GiveBuildPrivilege")
function PLAYER:AddBuildPrivilegeEntity(ent)
    if (!IsValid(ent)) then return end
    
    self.BuildPrivilegeEntities = self.BuildPrivilegeEntities or {}
    self.BuildPrivilegeEntities[ent] = true

    if (!self.BuildPrivilege) then
        self.BuildPrivilege = true
        self.BuildPrivilegeEnt = ent
        net.Start("gRust.GiveBuildPrivilege")
        net.WriteEntity(ent)
        net.Send(self)
    end
end

util.AddNetworkString("gRust.RemoveBuildPrivilege")
function PLAYER:RemoveBuildPrivilegeEntity(ent)
    self.BuildPrivilegeEntities = self.BuildPrivilegeEntities or {}
    self.BuildPrivilegeEntities[ent] = nil

    if (table.Count(self.BuildPrivilegeEntities) > 0) then return end

    if (self.BuildPrivilege) then
        self.BuildPrivilege = false
        self.BuildPrivilegeEnt = nil
        net.Start("gRust.RemoveBuildPrivilege")
        net.Send(self)
    end
end

function PLAYER:VerifyBuildPrivilege()
    local validEnts = 0
    for ent, _ in pairs(self.BuildPrivilegeEntities or {}) do
        if (IsValid(ent)) then
            validEnts = validEnts + 1
        end
    end

    if (validEnts == 0) then
        self.BuildPrivilege = false
        self.BuildPrivilegeEnt = nil
        net.Start("gRust.RemoveBuildPrivilege")
        net.Send(self)
    end
end

--
-- Build Block
--

util.AddNetworkString("gRust.SetBuildBlock")

function PLAYER:AddBuildBlockEntity(ent)
    if (!IsValid(ent)) then return end

    self.BuildBlockedEntities = self.BuildBlockedEntities or {}
    self.BuildBlockedEntities[ent] = true

    if (!self.BuildBlock) then
        self.BuildBlock = true
        net.Start("gRust.SetBuildBlock")
        net.WriteBool(true)
        net.Send(self)
    end
end

function PLAYER:RemoveBuildBlockEntity(ent)
    self.BuildBlockedEntities = self.BuildBlockedEntities or {}
    self.BuildBlockedEntities[ent] = nil

    if (table.Count(self.BuildBlockedEntities) > 0) then return end

    if (self.BuildBlock) then
        self.BuildBlock = false
        net.Start("gRust.SetBuildBlock")
        net.WriteBool(false)
        net.Send(self)
    end
end

function PLAYER:VerifyBuildBlock()
    local validEnts = 0
    for ent, _ in pairs(self.BuildBlockedEntities or {}) do
        if (IsValid(ent)) then
            validEnts = validEnts + 1
        end
    end

    if (validEnts == 0) then
        self.BuildBlock = false
        net.Start("gRust.SetBuildBlock")
        net.WriteBool(false)
        net.Send(self)
    end
end

--
-- Other
--

function PLAYER:HasPrivilegeForEntity(ent)
    if (self:IsBuildBlocked()) then return false end

    if (IsValid(ent.ToolCupboard)) then
        return ent.ToolCupboard:IsPlayerAuthorized(self)
    else
        return true
    end
end