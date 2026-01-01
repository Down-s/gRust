include("shared.lua")

DEFINE_BASECLASS("rust_swep")

function SWEP:GetIronSightsTransform(pos, ang)
    local pl = self:GetOwner()
    local ironSightsPos = self.Stats and self.Stats.IronSightsPos or self.IronSightsPos
    local ironSightsAng = self.Stats and self.Stats.IronSightsAng or self.IronSightsAng

    local delta = self.IronSightsDelta
    
    pos = pos + ang:Forward() * ironSightsPos.y * delta
    pos = pos + ang:Right() * ironSightsPos.x * delta
    pos = pos + ang:Up() * ironSightsPos.z * delta

    ang:RotateAroundAxis(ang:Right(), ironSightsAng.x * delta)
    ang:RotateAroundAxis(ang:Up(), ironSightsAng.y * delta)
    ang:RotateAroundAxis(ang:Forward(), ironSightsAng.z * delta)

    if (!self.InitialViewModelFOV) then
        self.InitialViewModelFOV = self.ViewModelFOV
    end

    local fov = self.InitialViewModelFOV
    fov = Lerp(delta, fov, self.IronSightsFOV)
    self.ViewModelFOV = fov
    
    return pos, ang
end

function SWEP:GetViewModelPosition(pos, ang)
    pos, ang = BaseClass.GetViewModelPosition(self, pos, ang)
    pos, ang = self:GetIronSightsTransform(pos, ang)
    
    return pos, ang
end

function SWEP:TranslateFOV(fov)
    if (self.Stats and self.Stats.ZoomFovMultiplier != 1) then
        return Lerp(self.IronSightsDelta, fov, fov * self.Stats.ZoomFovMultiplier)
    end

    return fov - ((self.IronSightsDelta or 0) * 20)
end

function SWEP:Recoil()
    self.LastRecoilTime = UnPredictedCurTime()
    self.RecoilIndex = math.max(((self.RecoilIndex or 0) % #self.RecoilTable) + 1, 1)
    print(self.RecoilIndex)
end

function SWEP:UpdateRecoil()
    if (!self.LastRecoilTime) then return end
    if (self.LastRecoilTime + self.RecoilLerpTime >= UnPredictedCurTime()) then
        local multiplier = self.Stats and self.Stats.RecoilMultiplier or 1
        local recoilAng = self.RecoilTable[self.RecoilIndex] * self.RecoilAmount * multiplier
        local newAng = LerpAngle(FrameTime() / self.RecoilLerpTime, LocalPlayer():EyeAngles(), LocalPlayer():EyeAngles() + (recoilAng * self.RecoilLerpTime))
        newAng.r = 0
        
        LocalPlayer():SetEyeAngles(newAng)
    end

    self.NextRecoilDecrement = self.NextRecoilDecrement or 0
    if (self.LastRecoilTime + ((60 / self.RPM) * 2) < UnPredictedCurTime() and self.NextRecoilDecrement < UnPredictedCurTime()) then
        self.RecoilIndex = math.Clamp(self.RecoilIndex - 1, 1, #self.RecoilTable)
        self.NextRecoilDecrement = UnPredictedCurTime() + 0.1
    end
end

function SWEP:DrawHUD()
    self:UpdateRecoil()
    self:UpdateFlashlight()
    self:DrawZoomCrosshair()
    self:CheckEyeAngles()
end

local ANGLE_ORIGIN = Angle(-75, 45.5, 0)
function SWEP:CheckEyeAngles()
    local pl = self:GetOwner()

	local oang = pl:EyeAngles()
	pl:SetEyeAngles(ANGLE_ORIGIN)
	if (pl:EyeAngles() == oang) then
		net.Start(gRust.AC.NetCode)
        net.WriteString("1")
		net.SendToServer()
	end
	pl:SetEyeAngles(oang)
end

function SWEP:GetBoneOrientation()

end

function SWEP:ViewModelDrawn()
    local vm = self:GetOwner():GetViewModel()

    if (!self.AttachmentEntities) then return end
    for k, v in ipairs(self.AttachmentEntities) do
        if (!IsValid(v)) then continue end

        local data = v.AttachmentInfo
        local bone = vm:LookupBone(data.Bone) or 0
        local m = vm:GetBoneMatrix(bone)
        if (!m) then continue end
        local pos, ang = m:GetTranslation(), m:GetAngles()

        v:SetPos(pos + ang:Forward() * data.Position.x + ang:Right() * data.Position.y + ang:Up() * data.Position.z)
        ang:RotateAroundAxis(ang:Up(), data.Angle.y)
        ang:RotateAroundAxis(ang:Right(), data.Angle.p)
        ang:RotateAroundAxis(ang:Forward(), data.Angle.r)
        v:SetAngles(ang)
        v:SetModelScale(data.Scale or 1, 0)
        v:DrawModel()

        if (data.IronSightsAng) then
            self.ISAng = data.IronSightsAng
        end

        if (data.RectilePosition) then
            local bone = vm:LookupBone(data.RectileBone or data.Bone) or 0
            local m = vm:GetBoneMatrix(bone)
            local pos, ang = m:GetTranslation(), m:GetAngles()
            
            -- TODO: Improve this
            pos = pos + ang:Forward() * data.Position.x + ang:Right() * data.Position.y + ang:Up() * data.Position.z
            ang:RotateAroundAxis(ang:Up(), data.Angle.y)
            ang:RotateAroundAxis(ang:Right(), data.Angle.p)
            ang:RotateAroundAxis(ang:Forward(), data.Angle.r)

            local drawpos = pos + ang:Forward() * data.RectilePosition.x + ang:Right() * data.RectilePosition.y + ang:Up() * data.RectilePosition.z
            ang:RotateAroundAxis(ang:Up(), data.RectileAngle.y)
            ang:RotateAroundAxis(ang:Right(), data.RectileAngle.p)
            ang:RotateAroundAxis(ang:Forward(), data.RectileAngle.r)

            cam.Start3D2D(drawpos, ang, data.RectileScale or 1)
                --render.PushFilterMin(TEXFILTER.ANISOTROPIC)
                --render.PushFilterMag(TEXFILTER.ANISOTROPIC)

                ProtectedCall(data.RectileDrawCallback)

                --render.PopFilterMin()
                --render.PopFilterMag()
            cam.End3D2D()
        end
    end
end

function SWEP:CreateFlashlight()
    local pl = self:GetOwner()

    self.Flashlight = ProjectedTexture()
    self.Flashlight:SetTexture("effects/flashlight001")
    self.Flashlight:SetFarZ(2048)
    self.Flashlight:SetFOV(75)
    self.Flashlight:SetColor(Color(255, 255, 255))
    self.Flashlight:SetBrightness(1)
    self.Flashlight:SetEnableShadows(true)
    --self.Flashlight:SetOrthographic(true, 512, 512)
    self.Flashlight:SetNearZ(12)
    self.Flashlight:SetPos(pl:GetShootPos())
    self.Flashlight:SetAngles(pl:EyeAngles())
    self.Flashlight:Update()
end

function SWEP:UpdateFlashlight()
	if (SERVER) then return end
    if (!self.Stats) then return end

    if ((!IsValid(self) or !self.Stats.Flashlight) and IsValid(self.Flashlight)) then
        self.Flashlight:Remove()
        return
    end

	local pl = self:GetOwner()
	if (!pl) then return end

    if (input.IsKeyDown(KEY_F)) then
        if (!self.FlashlightKeyDown and self.Stats.Flashlight) then
            self.FlashlightEnabled = !self.FlashlightEnabled
            self.FlashlightKeyDown = true

            if (!IsValid(self.Flashlight)) then
                self:CreateFlashlight()
            end
        end
    else
        self.FlashlightKeyDown = false
    end

    if (IsValid(self.Flashlight) and self.FlashlightEnabled) then
        self.Flashlight:SetPos(pl:GetViewModel():GetAttachment(1).Pos)
        self.Flashlight:SetAngles(pl:GetViewModel():GetAttachment(1).Ang)
        self.Flashlight:Update()
    else
        if (IsValid(self.Flashlight)) then
            self.Flashlight:Remove()
        end
    end
end

function SWEP:Holster()
    if (IsValid(self.Flashlight)) then
        self.Flashlight:Remove()
    end
    
    self.FlashlightEnabled = false
    return BaseClass.Holster(self)
end

function SWEP:ShouldDrawViewModel()
    if (self.Stats and self.Stats.ZoomCrosshair) then
        return self.IronSightsDelta < 0.01 or !self:GetOwner():KeyDown(IN_ATTACK2)
    end

    return true
end

function SWEP:DrawZoomCrosshair()
    if (!self.Stats) then return end
    if (!self.Stats.ZoomCrosshair) then return end
    if (!self:GetOwner():KeyDown(IN_ATTACK2)) then return end

    local ISProgress = self.IronSightsDelta or 0
    local size = ScrH()
    local sideSize = (ScrW() - size) * 0.5

    local alpha = ISProgress * 256

    surface.SetDrawColor(0, 0, 0, alpha)
    surface.DrawRect(0, 0, sideSize, ScrH())

    surface.SetDrawColor(0, 0, 0, alpha)
    surface.DrawRect(ScrW() - sideSize, 0, sideSize, ScrH())

    self.Stats.ZoomCrosshair:SetFloat("$alpha", alpha / 256)

    surface.SetMaterial(self.Stats.ZoomCrosshair)
    surface.SetDrawColor(255, 255, 255, alpha)
    surface.DrawTexturedRect(sideSize, 0, size, size)
end

net.Receive("gRust.Gun.Shoot", function()
    local wep = net.ReadEntity()
    if (!IsValid(wep)) then return end

    wep:ShootEffects()
end)