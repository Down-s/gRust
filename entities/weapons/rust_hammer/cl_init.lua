include("shared.lua")

local HIGHLIGHT_MATERIAL = Material("models/darky_m/rust_building/build_noise")
local DEMOLISH_PERIOD = 60 * 60

hook.Add("gRust.ConfigUpdated", "gRust.RadiationSound", function()
    DEMOLISH_PERIOD = gRust.GetConfigValue("building/demolish.period")
end)

function SWEP:Initialize()
    local pl = self:GetOwner()
    
    local PieMenu = gRust.CreatePieMenu()
    PieMenu:SetAngleOffset(0)
    for k, v in ipairs(self.UpgradeLevels) do
        PieMenu:CreateOption()
            :SetTitle("Upgrade to " .. v.Name)
            :SetDescription(v.Description)
            :SetIcon(v.Icon)
            :SetFooter(function()
                if (!IsValid(self.UpgradeEntity)) then return false end
                local twigModel = self.UpgradeEntity:GetTwigModel()
                local itemRegister = gRust.GetItemRegister(v.Item)
                local cost = gRust.Structures[twigModel].Cost
                return string.format("%i x %s (%s)", math.ceil(cost * v.CostMultiplier), itemRegister:GetName(), pl:ItemCount(v.Item))
            end)
            :SetCondition(false, function()
                if (!IsValid(self.UpgradeEntity)) then return false end
                local twigModel = self.UpgradeEntity:GetTwigModel()
                local cost = gRust.Structures[twigModel].Cost
                
                local hasItem = pl:HasItem(v.Item, math.ceil(cost * v.CostMultiplier))
                local higherLevel = self.UpgradeEntity:GetUpgradeLevel() < k
                return hasItem and higherLevel
            end)
            :SetCallback(function()
                net.Start("gRust.UpgradeStructure")
                net.WriteEntity(self.UpgradeEntity)
                net.WriteUInt(k, 3)
                net.SendToServer()
            end)
    end

    PieMenu:CreateOption()
        :SetTitle("Demolish")
        :SetDescription("Slowly and automatically dismantle this block")
        :SetIcon("demolish")
        :SetCondition(true, function()
            if (!IsValid(self.UpgradeEntity)) then return false end
            return LocalPlayer():HasBuildPrivilege() and self.UpgradeEntity:GetCreationTime() + DEMOLISH_PERIOD > CurTime()
        end)
        :SetCallback(function()
            net.Start("gRust.DemolishStructure")
            net.WriteEntity(self.UpgradeEntity)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Rotate")
        :SetDescription("Rotate or flip this block to face a different direction")
        :SetIcon("rotate")
        :SetCondition(true, function()
            return LocalPlayer():HasBuildPrivilege()
        end)
        :SetCallback(function()
            net.Start("gRust.RotateStructure")
            net.WriteEntity(self.UpgradeEntity)
            net.SendToServer()
        end)
    
    self.PieMenu = PieMenu
end

function SWEP:UpdatePieMenu()
    if (input.IsMouseDown(MOUSE_RIGHT)) then
        if (!self.RightMouseDown) then
            local tr = self:TraceRange(self.UpgradeRange)
            if (IsValid(tr.Entity) and tr.Entity:GetClass() == "rust_structure") then
                self.UpgradeEntity = tr.Entity
                self.PieMenu:Open()
            end
        end
        
        self.RightMouseDown = true
    else
        if (self.RightMouseDown) then
            self.RightMouseDown = false
            self.PieMenu:Close()
        end
    end
end

function SWEP:UpdateHighlight()
    local tr = self:TraceRange(self.UpgradeRange)
    local ent = tr.Entity

    if (IsValid(ent) and ent:GetClass() == "rust_structure") then
        if (self.HighlightedEnt ~= ent) then
            self:ClearHighlight()
            self.HighlightedEnt = ent
    
            ent.RenderOverride = function(me)
                me:DrawModel()
                
                render.MaterialOverride(HIGHLIGHT_MATERIAL)
                render.SetColorModulation(0, 0.55, 1)
                render.SetBlend(0.6)
    
                me:DrawModel()
                render.MaterialOverride()
                render.SetBlend(1)
            end
        end
    else
        self:ClearHighlight()
    end
end

function SWEP:ClearHighlight()
    if (!IsValid(self.HighlightedEnt)) then return end
    self.HighlightedEnt.RenderOverride = nil
    self.HighlightedEnt = nil
end

function SWEP:CheckPickup()
    local pl = self:GetOwner()
    if (pl:KeyDown(IN_USE)) then
        if (self.MenuOpen) then return end
        if (!self.UseDown) then
            self.UseDown = CurTime()
        end

        if (self.UseDown + 0.5 < CurTime()) then
            self.MenuOpen = true

            local tr = self:TraceRange(self.UpgradeRange)
            if (IsValid(tr.Entity) and tr.Entity.PickupType == PickupType.Hammer) then
                self.InteractMenu = gRust.CreateInteractMenu("Pickup", "give", 0.5, function()
                    gRust.PickupEntity(tr.Entity)
                end)
            end
        end
    else
        if (self.UseDown) then
            self.UseDown = nil
            self.MenuOpen = false

            if (IsValid(self.InteractMenu)) then
                self.InteractMenu:Close()
            end
        end
    end
end

function SWEP:Holster()
    self.PieMenu:Close()
    self:ClearHighlight()
end

function SWEP:OnRemove()
    self.PieMenu:Close()
    self:ClearHighlight()
end

function SWEP:DrawHUD()
    self:UpdateHighlight()
    self:UpdatePieMenu()
    self:CheckPickup()
end
