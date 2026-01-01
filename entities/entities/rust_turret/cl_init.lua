include("shared.lua")

function ENT:Initialize()
    self.YawEntity = ClientsideModel(self.YawModel)
    self.YawEntity:SetParent(self)
    self.YawEntity:SetLocalPos(self.YawPos)
    self.YawEntity:SetLocalAngles(Angle(0, 0, 0))

    self.PitchEntity = ClientsideModel(self.PitchModel)
    self.PitchEntity:SetParent(self.YawEntity)
    self.PitchEntity:SetLocalPos(self.PitchPos)
    self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))

    self.ExtraOptions = self:CreateExtraOptions()

    self.IdleOffset = self:EntIndex()
end

function ENT:OnRemove()
    if (IsValid(self.YawEntity)) then
        self.YawEntity:Remove()
    end

    if (IsValid(self.PitchEntity)) then
        self.PitchEntity:Remove()
    end

    if (IsValid(self.WeaponEntity)) then
        self.WeaponEntity:Remove()
    end
end

function ENT:Think()
    if (!IsValid(self.YawEntity) or !IsValid(self.PitchEntity)) then return end

    if (!self.NextEntitiesUpdate or self.NextEntitiesUpdate < CurTime()) then
        self:UpdateEntities()
        self.NextEntitiesUpdate = CurTime() + 5
    end

    self:UpdateRotation()

    local yaw = self.Rotation.y
    local pitch = self.Rotation.p

    self.YawEntity:SetLocalAngles(Angle(0, yaw, 0))
    self.PitchEntity:SetLocalAngles(Angle(pitch, 0, 0))

    self:SetNextClientThink(CurTime())
    return true
end

function ENT:UpdateEntities()
    local weaponID = self:GetWeaponID()
    if (weaponID != 0) then
        local weapon = gRust.GetItemRegisterFromIndex(weaponID)
        if (weapon) then
            if (!IsValid(self.WeaponEntity)) then
                self.WeaponEntity = ClientsideModel(weapon:GetModel())
                self.WeaponEntity:SetParent(self.PitchEntity)
                self.WeaponEntity:SetLocalPos(self.GunPos)
                self.WeaponEntity:SetLocalAngles(Angle(0, 0, 0))

                self.WeaponData = weapons.GetStored(weapon:GetWeapon())
            elseif (self.LastWeaponID != weaponID) then
                self.WeaponEntity:SetModel(weapon:GetModel())                

                self.WeaponData = weapons.GetStored(weapon:GetWeapon())
            end
        end
    else
        if (IsValid(self.WeaponEntity)) then
            self.WeaponEntity:Remove()

            self.WeaponEntity = nil
            self.WeaponData = nil
        end
    end

    if (IsValid(self.WeaponEntity)) then
        self.WeaponEntity:SetParent(self.PitchEntity)
        self.WeaponEntity:SetLocalPos(self.GunPos)
        self.WeaponEntity:SetLocalAngles(Angle(0, 0, 0))
    end

    if (!IsValid(self.YawEntity)) then
        self.YawEntity = ClientsideModel(self.YawModel)
        self.YawEntity:SetParent(self)
        self.YawEntity:SetLocalPos(self.YawPos)
        self.YawEntity:SetLocalAngles(Angle(0, 0, 0))
    end

    if (!IsValid(self.PitchEntity)) then
        self.PitchEntity = ClientsideModel(self.PitchModel)
        self.PitchEntity:SetParent(self.YawEntity)
        self.PitchEntity:SetLocalPos(self.PitchPos)
        self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))
    end

    self.YawEntity:SetParent(self)
    self.YawEntity:SetLocalPos(self.YawPos)
    self.YawEntity:SetLocalAngles(Angle(0, 0, 0))
    
    self.PitchEntity:SetParent(self.YawEntity)
    self.PitchEntity:SetLocalPos(self.PitchPos)
    self.PitchEntity:SetLocalAngles(Angle(0, 0, 0))
end

function ENT:CreateExtraOptions()
	local PieMenu = gRust.CreatePieMenu()
		
	PieMenu:CreateOption()
		:SetTitle("Open")
		:SetDescription("Open the auto turret's storage")
		:SetIcon("open")
		:SetCallback(function()
			gRust.StartLooting(self)
		end)

    PieMenu:CreateOption()
        :SetTitle("Peacekeeper mode")
        :SetDescription("Only target hostile players")
        :SetIcon("peacekeeper")
        :SetCondition(true, function()
            return !self:GetPeacekeeper()
        end)
        :SetCallback(function()
            net.Start("gRust.AutoTurret.Peacekeeper")
            net.WriteEntity(self)
            net.SendToServer()
        end)

    PieMenu:CreateOption()
        :SetTitle("Disable peacekeeper")
        :SetDescription("Target all unauthorized players")
        :SetIcon("peacekeeper")
        :SetCondition(true, function()
            return self:GetPeacekeeper()
        end)
        :SetCallback(function()
            net.Start("gRust.AutoTurret.Peacekeeper")
            net.WriteEntity(self)
            net.SendToServer()
        end)

	return PieMenu
end

function ENT:CreateLootingPanel(panel)
    local scaling = gRust.Hud.Scaling

    local Ammo = panel:Add("gRust.Inventory")
    Ammo:SetInventory(self.Containers[2])
    Ammo:Dock(BOTTOM)

    local Container = panel:Add("Panel")
    Container:Dock(BOTTOM)
    Container:SetTall(172 * scaling)
    Container:DockMargin(0, 0, 0, 8 * scaling)

    local Weapon = Container:Add("gRust.Slot")
    Weapon:SetInventory(self.Containers[1])
    Weapon:SetSlot(1)
    Weapon:Dock(LEFT)
    Weapon:SetWide(172 * scaling)

    local InfoContainer = Container:Add("gRust.Panel")
    InfoContainer:Dock(FILL)
    InfoContainer:DockMargin(8 * scaling, 0, 0, 0)
    InfoContainer:DockPadding(16 * scaling, 8 * scaling, 0, 0)

    local Title = InfoContainer:Add("gRust.Label")
    Title:Dock(TOP)
    Title:SetTextSize(56)
    Title:SetContentAlignment(7)
    Title:SetTall(56 * gRust.Hud.Scaling)
    Title:SetText("Weapon")
    Title:SetTextColor(gRust.Colors.Text2)

    local Description = InfoContainer:Add("gRust.Label")
    Description:Dock(FILL)
    Description:SetContentAlignment(7)
    Description:SetWrap(true)
    Description:SetText("The auto turret will use this weapon")
    Description:SetFont("gRust.Research.Text")
    Description:SetTextColor(gRust.Colors.Text2)

    local Panel = panel:Add("gRust.Panel")
    Panel:Dock(BOTTOM)
    Panel:SetTall(48 * scaling)
    Panel:DockMargin(0, 0, 0, 8 * scaling)
end

net.Receive("gRust.AutoTurret.ShootEffects", function(len)
    local turret = net.ReadEntity()
    if (!IsValid(turret) or turret:GetClass() != "rust_turret") then return end

    local ent = turret.WeaponEntity
    if (!IsValid(ent)) then return end

    local effect = turret.WeaponData.MuzzleEffect or "CS_MuzzleFlash"
	if (effect and effect != "") then
		local attachment = ent:GetAttachment(1)
		if (!attachment) then return end

		local fx = EffectData()
		fx:SetOrigin(attachment.Pos)
		fx:SetEntity(ent)
		fx:SetAngles(attachment.Ang)
		fx:SetScale(2)
		fx:SetAttachment(1)
		util.Effect(effect, fx)
	end

	local effect = turret.WeaponData.ShellEffect or "EjectBrass_762Nato"
	if (effect and effect != "") then
		local attachment = ent:GetAttachment(2)
		if (!attachment) then return end

		local fx = EffectData()
		fx:SetOrigin(attachment.Pos + attachment.Ang:Right() * 12 + attachment.Ang:Up() * -8)
		fx:SetEntity(ent)
		fx:SetAngles(attachment.Ang)
		fx:SetFlags(50)
		fx:SetAttachment(2)
		util.Effect(effect, fx)
	end
end)