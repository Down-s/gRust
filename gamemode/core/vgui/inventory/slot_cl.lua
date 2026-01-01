local PANEL = {}

local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_SetFont = surface.SetFont
local surface_DrawText = surface.DrawText
local surface_GetTextSize = surface.GetTextSize

AccessorFunc(PANEL, "Inventory", "Inventory")
AccessorFunc(PANEL, "Slot", "Slot", FORCE_NUMBER)
AccessorFunc(PANEL, "Quantity", "Quantity", FORCE_NUMBER)
AccessorFunc(PANEL, "Animated", "Animated", FORCE_BOOL)
AccessorFunc(PANEL, "Selectable", "Selectable", FORCE_BOOL)
AccessorFunc(PANEL, "PreviewItem", "PreviewItem", FORCE_STRING)
AccessorFunc(PANEL, "Locked", "Locked", FORCE_BOOL)
AccessorFunc(PANEL, "DrawBackground", "DrawBackground", FORCE_BOOL)

function PANEL:Init()
    self:SetSelectable(true)
    self:SetAnimated(true)
    self:NoClipping(true)
    self:SetDrawBackground(true)

    self.gRustDragPanel = true

    self.Matrix = Matrix()
    self.AnimScale = 1
    self.Hovered = false
    self.HoveredTime = 0
    self.bPressed = false
end

function PANEL:GetMouseDown()
    if (input.IsMouseDown(MOUSE_LEFT)) then
        return MOUSE_LEFT
    elseif (input.IsMouseDown(MOUSE_RIGHT)) then
        return MOUSE_RIGHT
    elseif (input.IsMouseDown(MOUSE_MIDDLE)) then
        return MOUSE_MIDDLE
    end

    return false
end

function PANEL:DropTo(other, mousecode)
    local item = self.Inventory[self.Slot]

    if (item) then
        local quantity = 0
        if (mousecode == MOUSE_LEFT) then
            quantity = item:GetQuantity()
        elseif (mousecode == MOUSE_RIGHT) then
            quantity = 1
        elseif (mousecode == MOUSE_MIDDLE) then
            if (input.IsKeyDown(KEY_LSHIFT)) then
                quantity = math.floor(item:GetQuantity() / 3)
            else
                quantity = math.floor(item:GetQuantity() / 2)
            end
        end
        
        if (quantity > 0) then
            gRust.SwapInventorySlots(self.Inventory, other.Inventory, self.Slot, other.Slot, self:GetQuantity() or quantity)
        end
    end
end

function PANEL:CheckSelection()
    if (!self.Inventory) then return end
    if (!self:GetSelectable()) then return end
    
    if (IsValid(self.LastItem) and !IsValid(self.Inventory[self.Slot])) then
        self:SetSelected(false)
        self.LastItem = nil
        if (self.Slot == gRust.Hotbar.SelectedSlot) then
            --gRust.Hotbar.SelectedSlot = nil
        end
    end

    self.LastItem = self.Inventory[self.Slot]
end

function PANEL:CheckQuickSwap()
    if (vgui.GetHoveredPanel() == self and input.IsKeyDown(KEY_H)) then
        if (!self.QuickSwapData) then
            self:QuickSwap()
        end
    end

    if (self.QuickSwapData and self.QuickSwapData.EndTime < CurTime()) then
        self.QuickSwapData = nil
        if (!self.Inventory[self.Slot]) then return end
        local register = self.Inventory[self.Slot]:GetRegister()
        gRust.PlaySound(register:GetDropSound())
    end
end

function PANEL:Think()
    local mouseDown = self:GetMouseDown()
    self:CheckSelection()
    self:CheckQuickSwap()

    if (vgui.GetHoveredPanel() == self) then
        if (mouseDown && self.bLastMouse == false) then
            if (!self.bPressed) then
                self.bPressed = true
                self.bPressedPos = {gui.MousePos()}
                self.bMouseDown = mouseDown
            end
        end
    end

    if (mouseDown ~= self.bMouseDown) then
        if (self.bPressed || self.bDragging) then
            self.bPressed = false
            self.bPressedPos = nil
            self.bDragging = false

            local item = self.Inventory[self.Slot]
            if (item) then
                local register = item:GetRegister()
                local snd = register:GetDropSound()
                
                if (snd) then
                    gRust.PlaySound(snd)
                end

                local hoveredPanel = vgui.GetHoveredPanel()
                if (hoveredPanel.gRustDragPanel) then
                    self:DropTo(vgui.GetHoveredPanel(), self.bMouseDown)
                elseif (hoveredPanel.ItemDropZone) then
                    gRust.DropItem(self.Inventory, self.Slot, self.bMouseDown == MOUSE_LEFT and item:GetQuantity() or (self.bMouseDown == MOUSE_RIGHT and 1 or math.floor(item:GetQuantity() / 2)))
                end
            end
        end
    elseif (self.bPressed and !self.bDragging) then
        local item = self.Inventory[self.Slot]

        if (IsValid(item)) then
            local register = item:GetRegister()
            local x, y = gui.MousePos()
            local px, py = unpack(self.bPressedPos)
    
            if (math.sqrt((x - px) ^ 2 + (y - py) ^ 2) >= 5) then
                self.bPressed = false
                self.bPressedPos = nil
                self.bDragging = true
    
                local snd = register:GetPickupSound()
                
                if (snd) then
                    gRust.PlaySound(snd)
                end
            end
        end
    end

    self.bLastMouse = mouseDown
end

function PANEL:PaintOver(w, h)
    local IconPadding = 10 * gRust.Hud.Scaling
    if (self.bDragging) then
        local x, y = self:LocalToScreen(0, 0)
        local mx, my = gui.MousePos()
        mx = mx - w * 0.5
        my = my - h * 0.5
        local w, h = (self:GetWide() - IconPadding * 2) * 1.25  , (self:GetTall() - IconPadding * 2) * 1.25
        x = x + w * 0.5
        y = y + h * 0.5

        local item = self.Inventory[self.Slot]
        if (IsValid(item)) then
            local register = item:GetRegister()
            local icon = register:GetIcon()

            if (icon) then
                draw.Overlay(function()
                    surface_SetDrawColor(200, 200, 200, 200)
                    surface_SetMaterial(icon)
                    surface_DrawTexturedRect(mx, my, w, h)
                end)
            end
        end
    end
end

local AnimTime = 0.3
local AnimIntensity = 0.1
function PANEL:UpdateAnimation()
    local x, y = self:LocalToScreen(0, 0)
    local w, h = self:GetWide(), self:GetTall()
    x = x + w * 0.5
    y = y + h * 0.5

    if (vgui.GetHoveredPanel() == self) then
        if (!self.bHovered) then
            self.bHovered = true
            self.HoveredTime = CurTime()
            gRust.PlaySound("ui.blip")
        end
    else
        if (self.bHovered) then
            self.bHovered = false
        end
    end
    
    local t = Lerp((CurTime() - self.HoveredTime) / AnimTime, 0, 1)

    self.AnimScale = (gRust.Anim.Punch(t) * AnimIntensity) + 1

    self.Matrix:Identity()
    self.Matrix:Translate(Vector(x, y))
    self.Matrix:SetScale(Vector(self.AnimScale, self.AnimScale, 1))
    self.Matrix:Translate(Vector(-x, -y))
end

local QuickSwapCircle = gRust.CreateCircle()
QuickSwapCircle:SetFilled(true)
QuickSwapCircle:SetColor(Color(132, 174, 57))
QuickSwapCircle:SetCenter(ScrW() * 0.5, ScrH() * 0.5)
QuickSwapCircle:SetRadius(64 * gRust.Hud.Scaling)

local TextColor = Color(255, 255, 255, 100)
local HighlightedColor = gRust.Colors.Secondary
local LOCK_OVERLAY = Material("ui/tile_grid.png", "noclamp")
local BLUEPRINT_ICON = Material("items/misc/blueprint.png", "smooth")
local BROKEN_ICON = gRust.GetIcon("broken")
function PANEL:Paint(w, h)
    local IconPadding = 10 * gRust.Hud.Scaling

    if (self.Animated and !self.Locked) then
        self:UpdateAnimation()
        self.Matrix:Translate(Vector(x, y))
        cam.PushModelMatrix(self.Matrix)
    end

    if (self:GetDrawBackground()) then
        if (self:GetSelected()) then
            gRust.DrawPanelColored(0, 0, w, h, HighlightedColor)
        else
            gRust.DrawPanel(0, 0, w, h)
        end
    end

    if (self.Inventory) then
        local item = self.Inventory[self.Slot]

        if (item) then
            if (!item.GetRegister) then return end -- TODO: Fix
            local register = item:GetRegister()
            local icon = register:GetIcon()

            if (register:IsInCategory("Blueprints")) then
                local BlueprintPadding = 6 * gRust.Hud.Scaling
                surface_SetDrawColor(200, 200, 200, 245)
                surface_SetMaterial(BLUEPRINT_ICON)
                surface_DrawTexturedRect(BlueprintPadding, BlueprintPadding - 2 * gRust.Hud.Scaling, w - BlueprintPadding * 2 * gRust.Hud.Scaling, h - BlueprintPadding * 2 * gRust.Hud.Scaling)
            end

            if (icon) then
                surface_SetDrawColor(200, 200, 200, 255)
                surface_SetMaterial(icon)
                surface_DrawTexturedRect(IconPadding, IconPadding - 6 * gRust.Hud.Scaling, w - IconPadding * 2 * gRust.Hud.Scaling, h - IconPadding * 2 * gRust.Hud.Scaling)
            end

            if (register:GetCondition()) then
                local condition = item:GetCondition()
                local damage = item:GetDamage()
                
                surface_SetDrawColor(83, 102, 51, 100)
                surface_DrawRect(0, 0, 8 * gRust.Hud.Scaling, h)

                surface_SetDrawColor(103, 129, 58)
                surface_DrawRect(0, h - h * condition, 8 * gRust.Hud.Scaling, h * condition)

                surface_SetDrawColor(117, 65, 54)
                surface_DrawRect(0, 0, 8 * gRust.Hud.Scaling, h * damage)

                if (condition <= 0) then
                    local brokenIconSize = 32 * gRust.Hud.Scaling
                    local brokenIconMargin = 8 * gRust.Hud.Scaling

                    surface_SetDrawColor(255, 255, 255, 255)
                    surface_SetMaterial(BROKEN_ICON)
                    surface_DrawTexturedRect(w - brokenIconSize - brokenIconMargin, brokenIconMargin, brokenIconSize, brokenIconSize)
                end
            end

            local quantity = self:GetQuantity() or item:GetQuantity()
            local font = "gRust.34px"
            surface_SetFont(font)
            local text
            if (register:GetClipSize()) then
                text = item:GetClip()
            elseif (quantity > 1) then
                text = string.Comma(quantity)
                text = string.format(register:GetFormat(), text)
            end

            if (text) then
                local tw, th = surface_GetTextSize(text)
                draw.SimpleText(text, font, w - 6 * gRust.Hud.Scaling, h - 2 * gRust.Hud.Scaling, TextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            end
            
            -- Mods

            if (item.Inventory) then
                local x = 12 * gRust.Hud.Scaling
                local y = 8 * gRust.Hud.Scaling
                local w, h = 8 * gRust.Hud.Scaling, 8 * gRust.Hud.Scaling
                local itemCount = item.Inventory:ItemCount()
                for i = 1, math.min(item.Inventory:GetSlots(), 3) do
                    if (i <= itemCount) then
                        surface.SetDrawColor(255, 255, 255, 255)
                    else
                        surface.SetDrawColor(220, 220, 200, 50)
                    end

                    surface.DrawRect(x, y, w, h)

                    y = y + (h + 2 * gRust.Hud.Scaling)
                end
            end
        else
            if (self.PreviewItem) then
                local register = gRust.GetItemRegister(self.PreviewItem)
                local icon = register:GetIcon()

                if (icon) then
                    surface_SetDrawColor(200, 200, 200, 50)
                    surface_SetMaterial(icon)
                    surface_DrawTexturedRect(IconPadding, IconPadding - 6 * gRust.Hud.Scaling, w - IconPadding * 2 * gRust.Hud.Scaling, h - IconPadding * 2 * gRust.Hud.Scaling)
                end
            end
        end

        if (self.Locked) then
            surface_SetDrawColor(255, 255, 255, 7)
            surface_SetMaterial(LOCK_OVERLAY)
            surface_DrawTexturedRectUV(0, 0, w, h, 0, 0, w * 0.5, h * 0.5)
        end
    end

    if (self.QuickSwapData) then
        local startTime = self.QuickSwapData.StartTime
        local endTime = self.QuickSwapData.EndTime
        local endAngle = 360 * (1 - (endTime - CurTime()) / (endTime - startTime))
        endAngle = math.Clamp(endAngle, 0, 360)

        QuickSwapCircle:SetCenter(w * 0.5, h * 0.5)
        QuickSwapCircle:SetRadius(30 * gRust.Hud.Scaling)
        QuickSwapCircle:SetStartAngle(360 + 90)
        QuickSwapCircle:SetEndAngle(90 + endAngle)
        QuickSwapCircle:Draw()
    end

    if (self.Animated and !self.Locked) then
        cam.PopModelMatrix()
    end
end

local LastClicked
function PANEL:OnMousePressed(mouseCode)
    if (!self:GetSelectable()) then return end

    if (mouseCode == MOUSE_LEFT or mouseCode == MOUSE_RIGHT) then
        self.bClicked = true
        LastClicked = self
    end
end

function PANEL:QuickSwap()
    if (self.QuickSwapData) then return end
    if (!self.Inventory or !self.Slot) then return end
    if (!self.Inventory[self.Slot]) then return end
    self.QuickSwapData = gRust.AddToQuickSwapQueue(self.Inventory, self.Slot)
    local register = self.Inventory[self.Slot]:GetRegister()

    gRust.PlaySound(register:GetPickupSound())
end

function PANEL:OnMouseReleased(mouseCode)
    if (!self:GetSelectable()) then return end
    
    if (!self.bDragging && self.bClicked && LastClicked == self) then
        if (mouseCode == MOUSE_LEFT) then
            if (IsValid(gRust.ActiveInventorySlot) && gRust.ActiveInventorySlot != self) then
                gRust.ActiveInventorySlot:SetSelected(false)
            end
    
            gRust.ActiveInventorySlot = self
            if (gRust.Hotbar.SelectedSlot && gRust.Hotbar.Slots[gRust.Hotbar.SelectedSlot]) then
                gRust.Hotbar.Slots[gRust.Hotbar.SelectedSlot]:SetSelected(false)
            end
            
            self:SetSelected(true)
            hook.Run("OnInventorySlotSelected", self)
        elseif (mouseCode == MOUSE_RIGHT) then
            local item = self.Inventory[self.Slot]
            if (!item) then return end

            self:QuickSwap()
        end
    end

    self.bClicked = false
end

function PANEL:SetSelected(selected)
    self.Selected = selected
end

function PANEL:GetSelected()
    return self.Selected
end

vgui.Register("gRust.Slot", PANEL, "gRust.Panel")