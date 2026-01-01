AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Initialize()
    BaseClass.Initialize(self)

    self:SetInteractable(true)
    self:SetInteractText("OPEN DOOR")
    self:SetInteractIcon("circle")

    local id = self:GetName()
    timer.Simple(0, function()
        for k, v in ipairs(ents.FindByClass("rust_puzzledoor")) do
            if (v:GetName() != id) then continue end
            self.Door = v
        end
    end)
end

function ENT:Interact()
	self:ResetSequence("use")
    self.Door:Open()

	self:SetInteractable(false)
	timer.Simple(1, function()
		self:SetInteractable(true)
	end)
end