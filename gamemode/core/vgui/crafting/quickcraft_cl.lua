local PANEL = {}

surface.CreateFont("gRust.QuickCraft", {
    font = "Roboto Condensed",
    size = 32 * gRust.Hud.Scaling,
    weight = 500,
    antialias = true,
    shadow = false
})

function PANEL:Init()
    self:Build()
end

function PANEL:Clear()
    for k, v in pairs(self:GetChildren()) do
        v:Remove()
    end
end

function PANEL:Build()
    local TextPadding = 32 * gRust.Hud.Scaling

    self.Craftables = {}
    for k, v in pairs(gRust.GetItems()) do
        if (LocalPlayer():CanCraft(v)) then
            self.Craftables[#self.Craftables + 1] = v
            
            if (#self.Craftables >= 18) then
                break
            end
        end
    end
    
    if (#self.Craftables == 0) then
        self:SetTall(162 * gRust.Hud.Scaling)
        self:DockPadding(TextPadding, TextPadding, TextPadding, TextPadding)
        
        local InfoLabel = self:Add("gRust.Label")
        InfoLabel:SetFont("gRust.QuickCraft")
        InfoLabel:Dock(FILL)
        InfoLabel:SetText("This box shows items that you can craft with your currect resources. You don't have enough resources to craft anything right now.")
        InfoLabel:SetColor(gRust.Colors.Text)
        InfoLabel:SetWrap(true)
    else
        self:SetTall((128 * (math.floor((#self.Craftables - 1) / 6) + 1)) * gRust.Hud.Scaling)

        local grid = self:Add("gRust.CraftGrid")
        grid:Dock(FILL)
        grid:SetCols(6)
        grid:SetItemMargin(0)
        grid:SetIconMargin(6 * gRust.Hud.Scaling)
        for k, v in ipairs(self.Craftables) do
            grid:AddItem(v)
        end

        grid:Rebuild()
        grid.OnItemSelected = function(self, item)
            gRust.Craft(item, 1)
        end
    end
end

function PANEL:Reconstruct()
    self:Clear()
    self:Build()
end

function PANEL:Paint(w, h)
    if (#self.Craftables == 0) then
        gRust.DrawPanel(0, 0, w, h)
        gRust.DrawPanel(0, 0, w, h)
    else
        
    end
end

function PANEL:PerformLayout(w, h)
    
end

vgui.Register("gRust.QuickCraft", PANEL, "Panel")