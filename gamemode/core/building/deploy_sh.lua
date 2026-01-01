local DEPLOYABLE = {}
DEPLOYABLE.__index = DEPLOYABLE

gRust.AccessorFunc(DEPLOYABLE, "Cost")
gRust.AccessorFunc(DEPLOYABLE, "Sound")
gRust.AccessorFunc(DEPLOYABLE, "Center")
gRust.AccessorFunc(DEPLOYABLE, "Rotate")
gRust.AccessorFunc(DEPLOYABLE, "OnDeployed")
gRust.AccessorFunc(DEPLOYABLE, "FacePlayer")
gRust.AccessorFunc(DEPLOYABLE, "RequireSocket")
gRust.AccessorFunc(DEPLOYABLE, "InitialRotation")
gRust.AccessorFunc(DEPLOYABLE, "PreviewCallback")

function DEPLOYABLE:Initialize()
end

function DEPLOYABLE:AddSocket(...)
    self.Sockets = self.Sockets or {}
    for _, socket in pairs({...}) do
        table.insert(self.Sockets, socket)
    end
    return self
end

function DEPLOYABLE:SetCustomCheck(func)
    self.CustomCheck = func
    return self
end

function DEPLOYABLE:HasCustomCheck()
    return self.CustomCheck ~= nil
end

function DEPLOYABLE:GetCustomCheck(...)
    if (self.CustomCheck) then
        return self.CustomCheck(...)
    end

    return true
end

function DEPLOYABLE:SetModel(model)
    util.PrecacheModel(model)
    self.Model = model
    return self
end

function DEPLOYABLE:GetModel()
    return self.Model
end

function gRust.CreateDeployable()
    local self = setmetatable({}, DEPLOYABLE)
    self:Initialize()
    return self
end