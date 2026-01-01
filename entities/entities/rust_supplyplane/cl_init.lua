include("shared.lua")

local FALLOFF_DISTANCE = 1024
function ENT:Initialize()
    self.Sound = CreateSound(LocalPlayer(), "rust/airdrop-plane-loop.mp3")
    self.Sound:ChangeVolume(0.001, 0.001)
    self.Sound:Play()

    self.ReplayTime = CurTime() + 24

    hook.Add("Think", self, function()
        if (CurTime() >= self.ReplayTime) then
            self.Sound:Play()
            self.ReplayTime = CurTime() + 24
        end
    
        local relativePos = self:GetPos() - LocalPlayer():GetPos()
        relativePos.z = 0
    
        local distance = relativePos:Length()
        local volume = 1 / (distance / FALLOFF_DISTANCE)
        volume = math.Clamp(volume, 0, 1)
        
        self.Sound:ChangeVolume(volume, 0.1)
    end)
end

function ENT:OnRemove()
    self.Sound:Stop()
end