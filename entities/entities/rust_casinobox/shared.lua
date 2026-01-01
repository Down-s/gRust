ENT.Base = "rust_container"

ENT.Model = "models/environment/dropbox.mdl"
ENT.Slots = 6

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    
    self.Containers[1] = inv
    inv.CanAcceptItem = function(inv, item, container)
        if (self.CasinoWheel:GetNextSpin() <= CurTime()) then return false end
        local ent = container:GetEntity()
        if (ent ~= self) then
            if (!IsValid(ent) or !ent:IsPlayer()) then return false end
            if (!ent:InVehicle()) then return false end
        end

        return item:GetId() == "scrap"
    end
    inv.CanRemoveItem = function(inv, item, container)
        if (self.CasinoWheel:GetNextSpin() <= CurTime()) then return false end
        local ent = container:GetEntity()
        if (ent ~= self) then
            if (!IsValid(ent) or !ent:IsPlayer()) then return false end
            if (!ent:InVehicle()) then return false end
        end
        
        return true
    end
    inv.CustomCheck = function(inv, pl)
        if (self.CasinoWheel:GetNextSpin() <= CurTime()) then return false end
        if (!pl:InVehicle()) then return false end -- Is sitting in a chair
        return true
    end
end