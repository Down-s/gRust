local PLAYER = FindMetaTable("Player")

local function AddMetabolismVariable(name, max, syncvar)
    PLAYER["Get" .. name] = function(self)
        return self:GetSyncVar(name, 0)
    end

    if (SERVER) then
        gRust.MetabolsimVars = gRust.MetabolsimVars or {}
        gRust.MetabolsimVars[#gRust.MetabolsimVars + 1] = {
            name = name,
            type = syncvar,
            max = max
        }

        PLAYER["Set" .. name] = function(self, value)
            self:SetSyncVar(name, math.Clamp(value, 0, max))
        end
    
        PLAYER["Add" .. name] = function(self, value)
            self:SetSyncVar(name, math.Clamp(self:GetSyncVar(name, 0) + value, 0, max))
        end
    end
end

AddMetabolismVariable("Hydration", 250, SyncVar.UInt)
AddMetabolismVariable("Calories", 500, SyncVar.UInt)
AddMetabolismVariable("Bleeding", 100, SyncVar.UInt)
AddMetabolismVariable("Wetness", 100, SyncVar.UInt)
AddMetabolismVariable("Temperature", 100, SyncVar.UInt)
AddMetabolismVariable("Comfort", 100, SyncVar.UInt)
AddMetabolismVariable("Radiation", 500, SyncVar.Float)
AddMetabolismVariable("Poison", 100, SyncVar.UInt)
AddMetabolismVariable("Healing", 100, SyncVar.UInt)

hook.Add("PlayerInitialSpawn", "gRust.RegisterMetabolismVars", function(pl)
    local vars = gRust.MetabolsimVars or {}
    for i = 1, #vars do
        local var = vars[i]
        local bits = math.ceil(math.log(var.max, 2))
        pl:RegisterSyncVar(var.name, var.type, bits)
    end
end)