include("shared.lua")

function ENT:Initialize()
    self.ExtraOptions = self:CreateExtraOptions()
end

function ENT:CreateExtraOptions()
	local PieMenu = gRust.CreatePieMenu()
		
	PieMenu:CreateOption()
		:SetTitle("Open")
		:SetDescription("Open the shop front's storage")
		:SetIcon("open")
		:SetCallback(function()
			gRust.StartLooting(self)
		end)

    PieMenu:CreateOption()
        :SetTitle("Rotate")
        :SetDescription("Rotates the shop front")
        :SetIcon("rotate")
        :SetCallback(function()
            gRust.RotateEntity(self)
        end)

	return PieMenu
end

function ENT:GetInventoryName()
    return "Trading"
end