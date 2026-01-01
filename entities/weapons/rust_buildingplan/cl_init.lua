include("shared.lua")

function SWEP:Initialize()
    local pl = self:GetOwner()
    self.SelectedBlock = 11
    self.Rotation = 0

    local PieMenu = gRust.CreatePieMenu()
    for k, v in ipairs(self.BuildingBlocks) do
        local structure = gRust.Structures[v.Model]
        PieMenu:CreateOption()
        :SetTitle(v.Name)
        :SetDescription(v.Description)
        :SetIcon(v.Icon)
        :SetFooter(function() return string.format("%i x Wood (%s)", math.ceil(structure.Cost), string.Comma(pl:ItemCount("wood"))) end)
        :SetCallback(function()
            self.SelectedBlock = k
            self.Rotation = 0
            self.PreviewEntity:SetModel(self.BuildingBlocks[k].Model)
        end)
    end

    self.PieMenu = PieMenu
end

function SWEP:Deploy()
    self.PreviewEntity = ClientsideModel(self.WorldModel)
    self.PreviewEntity:SetMoveType(MOVETYPE_NONE)
    self.PreviewEntity:SetMaterial("models/darky_m/rust_building/build_ghost")
    self.PreviewEntity:SetModel(self.BuildingBlocks[self.SelectedBlock].Model)
end

function SWEP:Holster()
    if (IsValid(self.PreviewEntity)) then
        self.PreviewEntity:Remove()
    end

    self.PieMenu:Close()
end

local RightMouseDown = false
function SWEP:DrawHUD()
    local pl = self:GetOwner()
    if (!IsValid(self.PreviewEntity)) then return end

    local pos, ang, valid, reason = self:GetBuildTransform(self.SelectedBlock, self.Rotation)
    
    self.PreviewEntity:SetPos(pos)
    self.PreviewEntity:SetAngles(ang)

    if (valid) then
		self.PreviewEntity:SetMaterial("models/darky_m/rust_building/build_ghost")
    else
		self.PreviewEntity:SetMaterial("models/darky_m/rust_building/build_ghost_disallow")
    end

    if (input.IsMouseDown(MOUSE_RIGHT)) then
        if (!RightMouseDown) then
            RightMouseDown = true
            self.PieMenu:Open()
        end
    else
        if (RightMouseDown) then
            RightMouseDown = false
            self.PieMenu:Close()
        end
    end
end

function SWEP:PrimaryAttack()
    if (!game.SinglePlayer() and !IsFirstTimePredicted()) then return end
    
    net.Start("gRust.PlaceBuilding")
    net.WriteUInt(self.SelectedBlock, 4)
    net.WriteUInt(self.Rotation, 9)
    net.SendToServer()
end

function SWEP:Reload()
    if (!IsFirstTimePredicted()) then return end
    if (self:GetOwner():KeyDownLast(IN_RELOAD)) then return end
    local model = self.BuildingBlocks[self.SelectedBlock].Model
    local structure = gRust.Structures[model]
    self.Rotation = (self.Rotation + (structure.Rotate or 0)) % 360
end

function SWEP:OnRemove()
    self.PieMenu:Close()
    if (IsValid(self.PreviewEntity)) then
        self.PreviewEntity:Remove()
    end
end