include("shared.lua")

DEFINE_BASECLASS("rust_container")

local POS_OFFSET = Vector(15, -3, 80)
local ANG_OFFSET = Angle(0, 90, 90)
local SCREEN_WIDTH, SCREEN_HEIGHT = 210, 195
local SCREEN_MATERIAL = Material("ui/vending_machine_screen.png")
local X_ICON_SIZE = 152
local TEXT_COLOR = Color(0, 255, 0)

local BLUR_MATERIAL = Material("pp/blurscreen")
local BLUR_AMOUNT = 8

function ENT:OpenAdministrationMenu()
	local scaling = gRust.Hud.Scaling

	local Frame = vgui.Create("DFrame")
	Frame:Dock(FILL)
	Frame:MakePopup()
	Frame:DockPadding(166 * scaling, 0, 92 * scaling, 0)
	Frame.Paint = function(self, w, h)
		surface.SetDrawColor(Color(14, 14, 14, 225))
		surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(BLUR_MATERIAL)
        for i = 1, BLUR_AMOUNT do
            BLUR_MATERIAL:SetFloat("$blur", (i / BLUR_AMOUNT) * 6)
            BLUR_MATERIAL:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        end
	end

	local LeftPanel = Frame:Add("Panel")
	LeftPanel:Dock(LEFT)
	LeftPanel:SetWide(426 * scaling)
	LeftPanel:DockPadding(0, 32 * scaling, 0, 0)

	local LeftTitle = LeftPanel:Add("gRust.Label")
	LeftTitle:Dock(TOP)
	LeftTitle:SetTextSize(36)
	LeftTitle:SetText("Add Sell Order")
	LeftTitle:SetTall(64 * scaling)
	LeftTitle:SetContentAlignment(5)
	LeftTitle:SetTextColor(gRust.Colors.Text)

	local BuySellContainer = LeftPanel:Add("Panel")
	BuySellContainer:Dock(TOP)
	BuySellContainer:SetTall(200 * scaling)

	local UpdateItemList
	local SelectedCol

	local SellingItem
	local SellingQuantity = 1

	local BuyingItem
	local BuyingQuantity = 1

	local spacing = 82 * scaling
	for i = 1, 2 do
		local selling = i == 1

		local ItemContainer = BuySellContainer:Add("Panel")
		ItemContainer:Dock(i == 1 and LEFT or FILL)
		ItemContainer:DockMargin(i == 2 and spacing * 0.5 or 0, 0, i == 1 and spacing * 0.5 or 0, 0)

		local Item = ItemContainer:Add("Panel")
		Item:Dock(TOP)
		Item:SetTall(72 * scaling)
		Item:DockMargin(0, 0, 0, 16 * scaling)
		Item.Paint = function(me, w, h)
			draw.SimpleText(selling and "Sell" or "For", "gRust.28px", 0, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(gRust.Colors.Background)
			surface.DrawRect((w * 0.5) - (h * 0.5), 0, h, h)

			local item = selling and SellingItem or BuyingItem
			if (item) then
				local padding = 4 * scaling

				surface.SetDrawColor(245, 245, 245)
				surface.SetMaterial(gRust.GetItemRegister(item):GetIcon())
				surface.DrawTexturedRect((w * 0.5) - (h * 0.5) + padding, padding, h - padding * 2, h - padding * 2)

				local amount = selling and SellingQuantity or BuyingQuantity
				if (amount and amount > 1) then
					draw.SimpleText("x"..string.Comma(amount), "gRust.24px", (w * 0.5) - (h * 0.5) + padding + h - 8 * scaling, h - padding * 2 - 4 * scaling, gRust.Colors.Text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end
		end

		local Options = ItemContainer:Add("Panel")
		Options:Dock(TOP)
		Options:SetTall(88 * scaling)
		Options:DockPadding(18 * scaling, 0, 18 * scaling, 0)

		local Search = Options:Add("gRust.Input")
		Search:Dock(TOP)
		Search:SetTall(40 * scaling)
		Search:SetPlaceholder("Search...")
		Search:SetTextSize(26)
		Search:DockMargin(0, 0, 0, 8 * scaling)
		Search:SetMargin(10 * scaling, 0, 0, 0)
		Search.OnValueChanged = function(self, value)
			UpdateItemList(value)
			SelectedCol = i
		end

		local Amount = Options:Add("gRust.Spinner")
		Amount:Dock(TOP)
		Amount:SetTall(40 * scaling)
		Amount:SetValue(1)
		Amount.Think = function(me)
			if (selling) then
				SellingQuantity = math.Clamp(me:GetValue(), 1, 1000)
			else
				BuyingQuantity = math.Clamp(me:GetValue(), 1, 1000)
			end
		end
	end

	BuySellContainer.PerformLayout = function(self)
		local w, h = self:GetSize()
		local itemWidth = (w - spacing) / 2

		for i, v in ipairs(self:GetChildren()) do
			v:SetWide(itemWidth)
		end
	end

	local AddSellOrder = LeftPanel:Add("gRust.Button")
	AddSellOrder:Dock(TOP)
	AddSellOrder:SetTall(64 * scaling)
	AddSellOrder:SetText("Add Sell Order")
	AddSellOrder:SetTextColor(gRust.Colors.Text)
	AddSellOrder:SetFont("gRust.28px")
	AddSellOrder:SetContentAlignment(5)
    AddSellOrder:SetTextColor(color_white)
    AddSellOrder:SetDefaultColor(Color(58, 64, 41))
    AddSellOrder:SetHoveredColor(Color(74, 81, 52))
    AddSellOrder:SetSelectedColor(Color(88, 96, 62))
	AddSellOrder:DockMargin(18 * scaling, 0, 18 * scaling, 0)
	AddSellOrder.DoClick = function()
		local selling = gRust.GetItemRegister(SellingItem)
		local buying = gRust.GetItemRegister(BuyingItem)
		if (!selling or !buying) then return end

		net.Start("gRust.AddSellOrder")
			net.WriteEntity(self)
			net.WriteUInt(selling:GetIndex(), gRust.ItemIndexBits)
			net.WriteUInt(SellingQuantity, 16)
			net.WriteUInt(buying:GetIndex(), gRust.ItemIndexBits)
			net.WriteUInt(BuyingQuantity, 16)
		net.SendToServer()
	end

	local Items = LeftPanel:Add("gRust.Scroll")
	Items:Dock(TOP)
	Items:SetTall(320 * scaling)
	Items:DockMargin(0, 12 * scaling, 0, 0)
	UpdateItemList = function(query)
		for k, v in ipairs(Items.Canvas:GetChildren()) do
			v:Remove()
		end

		local items = gRust.GetItems()
		for i = 1, #items do
			local item = items[i]
			local register = gRust.GetItemRegister(item)

			if (!string.find(string.lower(register:GetName()), string.lower(query))) then continue end
			if (register:IsBlueprint()) then continue end

			local Item = Items:Add("gRust.Button")
			Item:Dock(TOP)
			Item:SetTall(64 * scaling)
			Item:SetText(register:GetName())
			Item:SetTextColor(gRust.Colors.Text)
			Item:DockMargin(0, 0, 0, 3 * scaling)
			Item.Paint = function(me, w, h)
				gRust.DrawPanelColored(0, 0, w, h, me:GetColor())

				surface.SetDrawColor(245, 245, 245)
				surface.SetMaterial(register:GetIcon())
				surface.DrawTexturedRect(16 * scaling, 4 * scaling, h - 8 * scaling, h - 8 * scaling)

				draw.SimpleText(register:GetName(), "gRust.26px", h + 20 * scaling, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			Item.DoClick = function()
				if (SelectedCol == 1) then
					SellingItem = item
				else
					BuyingItem = item
				end
			end
		end
	end

	local RightPanel = Frame:Add("Panel")
	RightPanel:Dock(RIGHT)
	RightPanel:SetWide(420 * scaling)
	RightPanel:DockPadding(0, 48 * scaling, 0, 0)

	local RightTitle = RightPanel:Add("gRust.Label")
	RightTitle:Dock(TOP)
	RightTitle:SetTextSize(36)
	RightTitle:SetText("Existing Sell Orders")
	RightTitle:SetTall(64 * scaling)
	RightTitle:SetContentAlignment(5)
	RightTitle:SetTextColor(gRust.Colors.Text)

	local SellOrders = RightPanel:Add("Panel")
	SellOrders:Dock(FILL)

	Frame.ReloadSellOrders = function(me)
		for k, v in ipairs(SellOrders:GetChildren()) do
			v:Remove()
		end

		for k, v in ipairs(self.SellOrders) do
			local SellOrder = SellOrders:Add("Panel")
			SellOrder:Dock(TOP)
			SellOrder:SetTall(88 * scaling)
			SellOrder:DockMargin(0, 0, 0, 6 * scaling)
			SellOrder.Paint = function(me, w, h)
				gRust.DrawPanelColored(0, 0, w, h, gRust.Colors.Panel)

				draw.SimpleText("For", "gRust.32px", w * 0.5, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				local spacing = 46 * scaling
				local margin = 4 * scaling
				for i = 1, 2 do
					local item = i == 1 and v.SellItem or v.BuyItem
					local quantity = i == 1 and v.SellAmount or v.BuyAmount

					local register = gRust.GetItemRegisterFromIndex(item)
					if (!register) then continue end
					
					local y = margin
					local size = h - margin * 2
					local x = (w * 0.5) + (i == 1 and (-spacing - size) or spacing)
					
					surface.SetDrawColor(gRust.Colors.Panel)
					surface.DrawRect(x, y, size, size)

					local iconMargin = 4 * scaling
					surface.SetDrawColor(245, 245, 245)
					surface.SetMaterial(register:GetIcon())
					surface.DrawTexturedRect(x + iconMargin, y + iconMargin, size - iconMargin * 2, size - iconMargin * 2)

					if (quantity and quantity > 1) then
						draw.SimpleText("x"..string.Comma(quantity), "gRust.26px", x + size - iconMargin, y + size, gRust.Colors.Text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
					end
				end
			end

			local CancelButton = SellOrder:Add("gRust.Button")
			local size = 32 * scaling
			CancelButton:SetSize(size, size)
			CancelButton:SetPos(0, 0)
			CancelButton:SetText("x")
			CancelButton:SetTextColor(gRust.Colors.Text)
			CancelButton:SetFont("gRust.32px")
			CancelButton:SetContentAlignment(5)
			CancelButton:SetTextColor(color_white)
			CancelButton:SetDefaultColor(Color(146, 62, 48))
			CancelButton:SetHoveredColor(Color(186, 78, 60))
			CancelButton:SetSelectedColor(Color(226, 94, 72))
			CancelButton.DoClick = function()
				net.Start("gRust.RemoveSellOrder")
					net.WriteEntity(self)
					net.WriteUInt(k, 4)
				net.SendToServer()
			end

			SellOrder.PerformLayout = function(me)
				local w, h = me:GetSize()
				CancelButton:SetPos(w - size - 4 * scaling, 4 * scaling)
			end
		end
	end

	Frame:ReloadSellOrders()

	self.AdministrationMenu = Frame
end

net.Receive("gRust.AddSellOrder", function()
	local ent = net.ReadEntity()
	if (!IsValid(ent)) then return end

	local selling = net.ReadUInt(gRust.ItemIndexBits)
	local sellingQuantity = net.ReadUInt(16)
	local buying = net.ReadUInt(gRust.ItemIndexBits)
	local buyingQuantity = net.ReadUInt(16)

	ent.SellOrders[#ent.SellOrders + 1] = {
        SellItem = selling,
        SellAmount = sellingQuantity,
		BuyItem = buying,
		BuyAmount = buyingQuantity,
	}

	if (IsValid(ent.AdministrationMenu)) then
		ent.AdministrationMenu:ReloadSellOrders()
	end
end)

net.Receive("gRust.RemoveSellOrder", function()
	local ent = net.ReadEntity()
	if (!IsValid(ent)) then return end

	local index = net.ReadUInt(4)
	table.remove(ent.SellOrders, index)

	if (IsValid(ent.AdministrationMenu)) then
		ent.AdministrationMenu:ReloadSellOrders()
	end
end)

function ENT:Initialize()
	local PieMenu = gRust.CreatePieMenu()

	PieMenu:CreateOption()
		:SetTitle("Administrate")
		:SetDescription("Open the Administration Panel.")
		:SetIcon("gear")
		:SetCallback(function()
			self:OpenAdministrationMenu()
		end)

	PieMenu:CreateOption()
		:SetTitle("Start Broadcasting")
		:SetDescription("Start broadcasting the vending machine.")
		:SetIcon("broadcast")
		:SetCondition(true, function()
			return !self:GetBroadcasting()
		end)
		:SetCallback(function()
			net.Start("gRust.ToggleVendingMachineBroadcast")
				net.WriteEntity(self)
			net.SendToServer()
		end)

	PieMenu:CreateOption()
		:SetTitle("Stop Broadcasting")
		:SetDescription("Stop broadcasting the vending machine.")
		:SetIcon("close")
		:SetCondition(true, function()
			return self:GetBroadcasting()
		end)
		:SetCallback(function()
			net.Start("gRust.ToggleVendingMachineBroadcast")
				net.WriteEntity(self)
			net.SendToServer()
		end)
		
	PieMenu:CreateOption()
		:SetTitle("Open")
		:SetDescription("Open the tool cupboard.")
		:SetIcon("open")
		:SetCallback(function()
			gRust.StartLooting(self)
		end)

	self.MachineOptions = PieMenu
	self.SellOrders = {}

	net.Start("gRust.SyncVendingMachine")
		net.WriteEntity(self)
	net.SendToServer()
end

net.Receive("gRust.SyncVendingMachine", function()
	local ent = net.ReadEntity()
	if (!IsValid(ent)) then return end

	ent:SetBroadcasting(net.ReadBool())
	ent.SellOrders = {}

	local sellOrders = net.ReadUInt(4)
	for i = 1, sellOrders do
		ent.SellOrders[i] = {
			SellItem = net.ReadUInt(gRust.ItemIndexBits),
			SellAmount = net.ReadUInt(16),
			BuyItem = net.ReadUInt(gRust.ItemIndexBits),
			BuyAmount = net.ReadUInt(16),
		}
	end
end)

function ENT:Think()
	if (self:IsPlayerInFront(LocalPlayer())) then
		self.ExtraOptions = self.MachineOptions
	else
		self.ExtraOptions = nil
	end

	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:Draw()
    self:DrawModel()

	cam.Start3D2D(self:LocalToWorld(POS_OFFSET), self:LocalToWorldAngles(ANG_OFFSET), 0.1)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(SCREEN_MATERIAL)
		surface.DrawTexturedRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		
		if (self:GetVending()) then
			surface.SetDrawColor(137, 227, 118)
			surface.SetMaterial(gRust.GetIcon("vending"))
			surface.DrawTexturedRectRotated(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, X_ICON_SIZE, X_ICON_SIZE, CurTime() * 220)
		elseif (#self.SellOrders == 0) then
			surface.SetDrawColor(137, 227, 118)
			surface.SetMaterial(gRust.GetIcon("cross"))
			surface.DrawTexturedRect(SCREEN_WIDTH / 2 - X_ICON_SIZE / 2, SCREEN_HEIGHT / 2 - X_ICON_SIZE / 2, X_ICON_SIZE, X_ICON_SIZE)
		else
			local index = math.floor((CurTime() * (1 / 5)) % #self.SellOrders + 1)

			local item = self.SellOrders[index]
			local register = gRust.GetItemRegisterFromIndex(item.SellItem)
			if (!register) then return end

			local iconSize = 100
			surface.SetDrawColor(245, 245, 245)
			surface.SetMaterial(register:GetIcon())
			surface.DrawTexturedRectRotated(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, iconSize, iconSize, math.sin(CurTime()) * 5)

			draw.SimpleText(register:GetName(), "gRust.24px", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 82, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("x"..string.Comma(item.SellAmount), "gRust.32px", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + iconSize * 0.5, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(-200, -20, 150, 100)
	cam.End3D2D()
end

function ENT:Interact(pl)
	BaseClass.Interact(self, pl)
end

function ENT:CreateLootingPanel(panel)
	local scaling = gRust.Hud.Scaling
	if (self:IsPlayerInFront(LocalPlayer())) then
		BaseClass.CreateLootingPanel(self, panel)
	else
		local container = panel:Add("Panel")
		container:Dock(FILL)
		panel.Title = nil

		local function UpdateSellOrders()
			for k, v in ipairs(container:GetChildren()) do
				v:Remove()
			end

			if (self:GetVending()) then
				local VendingContainer = container:Add("gRust.Panel")
				VendingContainer:Dock(BOTTOM)
				VendingContainer:SetTall(512 * scaling)
				local oldPaint = VendingContainer.Paint
				VendingContainer.Paint = function(me, w, h)
					oldPaint(me, w, h)

					local size = 256 * scaling

					surface.SetDrawColor(gRust.Colors.Text)
					surface.SetMaterial(gRust.GetIcon("vending"))
					surface.DrawTexturedRectRotated(w * 0.5, h * 0.5 - 40 * scaling, size, size, CurTime() * 220)

					draw.SimpleText("VENDING", "gRust.48px", w * 0.5, h * 0.5 + size * 0.5 + 16 * scaling, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			else
				local leftMargin = 32 * scaling
				local padding = 12 * scaling
		
				for k, v in ipairs(self.SellOrders) do
					local Item = container:Add("Panel")
					Item:Dock(BOTTOM)
					Item:SetTall(144 * scaling)
					Item:DockMargin(0, 0, 0, 8 * scaling)
					Item.Paint = function(me, w, h)
						gRust.DrawPanel(0, 0, w, h)

						local size = h - (padding * 2)
						local iconMargin = 8 * scaling
		
						for i = 1, 2 do
							local item = (i == 1) and v.SellItem or v.BuyItem
							local register = gRust.GetItemRegisterFromIndex(item)
							
							local x = (i == 1) and leftMargin or leftMargin + 300 * scaling
							gRust.DrawPanel(x, padding, size, size)
		
							surface.SetDrawColor(245, 245, 245)
							surface.SetMaterial(register:GetIcon())
							surface.DrawTexturedRect(x + iconMargin, padding + iconMargin, size - (iconMargin * 2), size - (iconMargin * 2))
		
							local amount = (i == 1) and v.SellAmount or v.BuyAmount
							if (amount and amount > 1) then
								draw.SimpleText("x"..string.Comma(amount), "gRust.30px", x + size - iconMargin, padding + size, gRust.Colors.Text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
							end
						end
					end
					
					local BuyAmount = 1
		
					local BuyContainer = Item:Add("Panel")
					BuyContainer:Dock(RIGHT)
					BuyContainer:SetWide(192 * scaling)
					BuyContainer:DockMargin(0, padding, 20 * scaling, padding)
		
					local BuyButton = BuyContainer:Add("gRust.Button")
					BuyButton:Dock(TOP)
					BuyButton:SetTall(64 * scaling)
					BuyButton:DockMargin(32 * scaling, 0, 32 * scaling, 0)
					BuyButton:SetFont("gRust.32px")
					BuyButton.DoClick = function()
						net.Start("gRust.VendingMachineBuy")
							net.WriteEntity(self)
							net.WriteUInt(k, 4)
							net.WriteUInt(BuyAmount, 10)
						net.SendToServer()
					end
		
					local function UpdateBuyButton()
						local register = gRust.GetItemRegisterFromIndex(v.BuyItem)
						if (self:CanBuyItem(LocalPlayer(), k, BuyAmount)) then
							BuyButton:SetText("BUY")
							BuyButton:SetTextColor(Color(153, 197, 61))
							BuyButton:SetDefaultColor(Color(99, 122, 61))
							BuyButton:SetHoveredColor(Color(122, 151, 76))
							BuyButton:SetSelectedColor(Color(91, 119, 29))
						else
							if (!LocalPlayer():HasItem(register:GetId(), v.BuyAmount * BuyAmount)) then
								BuyButton:SetText("BUY")
							else
								BuyButton:SetText("NO STOCK")
							end

							BuyButton:SetTextColor(Color(238, 106, 106))
							BuyButton:SetDefaultColor(Color(146, 62, 48))
							BuyButton:SetHoveredColor(Color(186, 78, 60))
							BuyButton:SetSelectedColor(Color(226, 94, 72))
						end
					end
				
					BuyButton.Think = UpdateBuyButton
		
					local Amount = BuyContainer:Add("gRust.Spinner")
					Amount:Dock(FILL)
					Amount:SetValue(1)
					Amount:DockMargin(0, 12 * scaling, 0, 0)
					Amount:SetMin(1)
					Amount:SetMax(1000)
					Amount.Think = function(me)
						BuyAmount = me:GetValue()
					end
				end
		
				local Header = container:Add("gRust.Panel")
				Header:SetPrimary(true)
				Header:Dock(BOTTOM)
				Header:SetTall(42 * scaling)
				Header:DockMargin(0, 0, 0, 8 * scaling)
				Header.PaintOver = function(me, w, h)
					draw.SimpleText("FOR SALE", "gRust.30px", leftMargin, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
					draw.SimpleText("COST", "gRust.30px", leftMargin + 300 * scaling, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
		end
		
		UpdateSellOrders()

		local lastVending = self:GetVending()
		container.Think = function(me)
			if (lastVending != self:GetVending()) then
				lastVending = self:GetVending()
				UpdateSellOrders()
			end
		end
	end
end

function ENT:OnStartLooting(pl)
    gRust.PlaySound("vendingmachine.open")
    BaseClass.OnStartLooting(self, pl)
end

function ENT:OnStopLooting(pl)
    gRust.PlaySound("toolbox.close")
    BaseClass.OnStopLooting(self, pl)
end