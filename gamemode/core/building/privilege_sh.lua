local PLAYER = FindMetaTable("Player")
function PLAYER:HasBuildPrivilege()
    return self.BuildPrivilege
end

function PLAYER:IsBuildBlocked()
    return self.BuildBlock
end

function PLAYER:CanBuild()
    return !self:IsBuildBlocked()
end