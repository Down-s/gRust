local PANEL = {}

AccessorFunc(PANEL, "Entity", "Entity")

local BACKGROUND_COLOR = Color(0, 0, 0, 235)
local FOREGROUND_COLOR = Color(73, 69, 65, 100)

function PANEL:Init()
    local scaling = gRust.Hud.Scaling

    self.Padding = 8 * scaling

    local Container = self:Add("Panel")
    Container:Dock(FILL)
    Container:DockMargin(self.Padding, self.Padding, self.Padding, self.Padding)

    local Title = Container:Add("Panel")
    Title:SetPos(0, 0)
    Title:SetSize(192 * scaling, 32 * scaling)
    Title.Paint = function(me, w, h)
        surface.SetDrawColor(FOREGROUND_COLOR)
        surface.DrawRect(0, 0, w, h)
    end

    local TitleText = Title:Add("gRust.Label")
    TitleText:SetFont("gRust.24px")
    TitleText:SetTextColor(color_white)
    TitleText:Dock(FILL)
    TitleText:SetContentAlignment(5)

    self.TitleText = TitleText

    local TextContainer = Container:Add("Panel")
    TextContainer:Dock(TOP)
    TextContainer:DockMargin(0, self.Padding + 32 * scaling, 0, 0)
    TextContainer:SetTall(128 * scaling)
    TextContainer.Paint = function(me, w, h)
        surface.SetDrawColor(FOREGROUND_COLOR)
        surface.DrawRect(0, 0, w, h)
    end

    local Text = TextContainer:Add("gRust.Label")
    Text:SetFont("gRust.22px")
    Text:SetTextColor(color_white)
    Text:Dock(FILL)
    Text:SetContentAlignment(7)
    Text:DockMargin(self.Padding, self.Padding, self.Padding, self.Padding)
    Text:SetTextColor(Color(200, 200, 200))

    self.Text = Text

    local ButtonContainer = Container:Add("Panel")
    ButtonContainer:Dock(FILL)
    ButtonContainer:DockMargin(0, self.Padding, 0, 0)
    ButtonContainer:SetTall(32 * scaling)

    self.ButtonContainer = ButtonContainer

    local CloseButton = self:Add("gRust.Button")
    CloseButton:SetText("x")
    CloseButton:SetSize(32 * scaling, 32 * scaling)
    CloseButton:SetFont("gRust.32px")
    CloseButton.DoClick = function()
        self:Remove()
    end

    self.CloseButton = CloseButton
end

function PANEL:PerformLayout(w, h)
    self.CloseButton:SetPos(w - self.CloseButton:GetWide() - self.Padding, self.Padding)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(BACKGROUND_COLOR)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:SetTitle(title)
    self.TitleText:SetText(title)
end

function PANEL:SetText(text)
    self.Text:SetText(text)
end

function PANEL:AddOption(text, callback)
    local scaling = gRust.Hud.Scaling

    local Button = self.ButtonContainer:Add("gRust.Button")
    Button:SetText(text)
    Button:SetFont("gRust.22px")
    Button:Dock(TOP)
    Button:DockMargin(0, 0, 0, self.Padding)
    Button:SetWide(128 * scaling)
    Button:SetTall(32 * scaling)
    Button.DoClick = function()
        callback()
        self:Remove()
    end
end

vgui.Register("gRust.Dialogue", PANEL, "Panel")