local PANEL = {}

AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "TextColor", "TextColor")
AccessorFunc(PANEL, "Placeholder", "Placeholder")

local DefaultColor = ColorAlpha(gRust.Colors.Panel, 25)
local HoveredColor = Color(253, 217, 98, 45)
local PressedColor = Color(255, 255, 255, 100)
local PlaceholderColor = ColorAlpha(gRust.Colors.Text, 50)
function PANEL:Init()
    self:SetCursor("hand")
    self:SetColor(DefaultColor)
    self:SetPlaceholder("Input...")
    self:SetTextColor(gRust.Colors.Text)
    self:SetTextSize(38)
    
    self.TextEntry = self:Add("DTextEntry")
    self.TextEntry:SetFont("gRust." .. self.TextSize .. "px")
    self.TextEntry:SetDrawLanguageID(false)
    self.TextEntry:Dock(FILL)
    self.TextEntry:SetCursor("hand")
    self.TextEntry.Paint = function(me, w, h)
        local col = self:GetTextColor()

        me:DrawTextEntryText(col, col, col)

        if (me:GetValue() == "") then
            draw.SimpleText(self:GetPlaceholder(), "gRust." .. self.TextSize .. "px", 0, h * 0.5, PlaceholderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
    self.TextEntry.OnCursorEntered = function(me)
        self:ColorTo(HoveredColor, 0.1, 0)
    end
    self.TextEntry.OnCursorExited = function(me)
        if (!self.Focused) then
            self:ColorTo(DefaultColor, 0.1, 0)
        end
    end
    self.TextEntry.OnFocusChanged = function(me, gained)
        if (gained) then
            self:ColorTo(HoveredColor, 0.1, 0)
            self.Focused = true
        else
            self:ColorTo(DefaultColor, 0.1, 0)
            self.Focused = false
        end
    end
    self.TextEntry.OnMousePressed = function(me)
        -- self:PopupParent()
    end

    self.OnCursorEntered = self.TextEntry.OnCursorEntered
    self.OnCursorExited = self.TextEntry.OnCursorExited
    self.TextEntry.OnTextChanged = function(me)
        self:OnValueChanged(me:GetValue())
    end
    
    self:SetValue("")
end

function PANEL:SetValue(value)
    self.TextEntry:SetValue(value)
end

function PANEL:GetValue()
    return self.TextEntry:GetValue()
end

function PANEL:SetTextSize(size)
    self.TextSize = size

    if (IsValid(self.TextEntry)) then
        self.TextEntry:SetFont("gRust." .. size .. "px")
    end
end

function PANEL:GetTextSize()
    return self.TextSize
end

function PANEL:OnMousePressed()
    self.TextEntry:RequestFocus()
end

function PANEL:Paint(w, h)
    gRust.DrawPanelColored(0, 0, w, h, self:GetColor())
end

function PANEL:SetNumeric(bool)
    self.TextEntry:SetNumeric(bool)
end

function PANEL:SetContentAlignment(align)
    self.TextEntry:SetContentAlignment(align)
end

function PANEL:SetMargin(left, top, right, bottom)
    self.TextEntry:DockMargin(left, top, right, bottom)
end

function PANEL:PopupParent()
    -- Get the 2nd panel from the top
    local parent = self:GetParent()
    while (parent:GetParent()) do
        if (IsValid(parent:GetParent():GetParent())) then
            parent = parent:GetParent()
        else
            break
        end
    end

    parent:MakePopup()
end

function PANEL:UnPopupParent()
    local parent = self:GetParent()
    while (parent:GetParent()) do
        parent = parent:GetParent()
    end
end

function PANEL:OnValueChanged(value)
end

vgui.Register("gRust.Input", PANEL, "Panel")