include("shared.lua")

function ENT:Interact()
    gRust.OpenInventory("WORKBENCH", function(root)
        local buttonContainer = root:Add("gRust.Panel")
        buttonContainer:Dock(BOTTOM)
        buttonContainer:SetTall(96 * gRust.Hud.Scaling)
        buttonContainer:DockMargin(0, 8 * gRust.Hud.Scaling, 0, 0)

        local button = buttonContainer:Add("gRust.Button")
        button:Dock(FILL)
        button:SetText("OPEN TECH TREE")
        button:SetFont("gRust.32px")
        local sideMargin = 256 * gRust.Hud.Scaling
        local topMargin = 16 * gRust.Hud.Scaling
        button:DockMargin(sideMargin, topMargin, sideMargin, topMargin)
        button:SetDefaultColor(Color(114, 134, 56))
        button:SetHoveredColor(Color(98, 114, 32))
        button:SetSelectedColor(Color(74, 90, 42))
        button.DoClick = function()
            gRust.CloseInventory()
            self:OpenTechTree()
        end

        local textContainer = root:Add("gRust.Panel")
        textContainer:Dock(BOTTOM)
        textContainer:SetTall(128 * gRust.Hud.Scaling)
        
        local text = textContainer:Add("gRust.Label")
        text:Dock(FILL)
        text:SetFont("gRust.Research.Text")
        text:SetText([[You can use the workbench to experiment with scrap and progress through the tech tree by learning new, previously unknown blueprints.]])
        text:SetWrap(true)

        local infoIcon = textContainer:Add("gRust.Icon")
        infoIcon:Dock(LEFT)
        infoIcon:SetWide(128 * gRust.Hud.Scaling)
        infoIcon:SetIcon("info")
        infoIcon:SetPadding(32 * gRust.Hud.Scaling)
        infoIcon:SetColor(gRust.Colors.PrimaryPanel)
    end)
end

function ENT:OpenTechTree()
    local techTree = vgui.Create("gRust.TechTree")
    techTree:SetSize(ScrW(), ScrH())
    techTree:MakePopup()
    techTree:SetEntity(self)
end