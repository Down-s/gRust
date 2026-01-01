local round = math.Round

local PANEL = {}

function PANEL:Init()
    gRust.Hud.ShouldDraw = false

    hook.Add("gRust.BlueprintLearned", self, self.ReloadTechTree)

    local Side = self:Add("Panel")
    Side:Dock(RIGHT)
    Side:SetWide(512 * gRust.Hud.Scaling)
    Side:DockMargin(0, 0, 0, 0)
    Side:SetZPos(100)
    Side.Paint = function(me, w, h)
        surface.SetDrawColor(39, 38, 29)
        surface.DrawRect(0, 0, w, h)
    end

    local padding = 32 * gRust.Hud.Scaling
    local SideContent = Side:Add("Panel")
    SideContent:Dock(FILL)
    SideContent:DockPadding(padding, padding, padding, padding)

    self.Side = SideContent

    local Button = Side:Add("gRust.Button")
    Button:Dock(TOP)
    Button:SetTall(84 * gRust.Hud.Scaling)
    local IconSize = 48 * gRust.Hud.Scaling
    Button.Paint = function(me, w, h)
        surface.SetFont("gRust.56px")
        local tw, th = surface.GetTextSize("Close")
        surface.SetTextColor(gRust.Colors.Text)
        surface.SetTextPos((w / 2 - tw / 2) + IconSize * 0.5, h / 2 - th / 2)
        surface.DrawText("CLOSE")

        surface.SetDrawColor(gRust.Colors.Text)
        surface.SetMaterial(gRust.GetIcon("techtree.close"))
        surface.DrawTexturedRect((w * 0.5) - IconSize * 2, h * 0.5 - IconSize * 0.5, IconSize, IconSize)
    end
    Button.DoClick = function(me)
        self:Remove()
    end
    
    self:NoClipping(true)

    local ZoomPanel = self:Add("gRust.ZoomPanel")
    ZoomPanel:Dock(FILL)
    ZoomPanel:NoClipping(true)

    self.Container = ZoomPanel
end

function PANEL:OnRemove()
    gRust.Hud.ShouldDraw = true
end

function PANEL:PopulateSide()
    for k, v in ipairs(self.Side:GetChildren()) do
        v:Remove()
    end

    if (!self.SelectedItem) then return end

    local ItemInfo = self.Side:Add("Panel")
    ItemInfo:Dock(TOP)
    ItemInfo:SetTall(156 * gRust.Hud.Scaling)
    ItemInfo:DockMargin(0, 128 * gRust.Hud.Scaling, 0, 0)

    local iconPadding = 8 * gRust.Hud.Scaling
    local ItemIcon = ItemInfo:Add("Panel")
    ItemIcon:Dock(LEFT)
    ItemIcon:SetWide(156 * gRust.Hud.Scaling)
    ItemIcon.Paint = function(me, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.SelectedItem:GetIcon())
        surface.DrawTexturedRect(iconPadding, iconPadding, w - iconPadding * 2, h - iconPadding * 2)
    end

    local ItemName = ItemInfo:Add("Panel")
    ItemName:Dock(FILL)
    ItemName.Paint = function(me, w, h)
        draw.SimpleText(string.Cap(self.SelectedItem:GetName(), 16), "gRust.42px", w * 0.5, h * 0.5, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local ItemDescription = self.Side:Add("gRust.Label")
    ItemDescription:Dock(TOP)
    ItemDescription:SetTall(128 * gRust.Hud.Scaling)
    ItemDescription:DockMargin(0, 32 * gRust.Hud.Scaling, 0, 0)
    ItemDescription:SetFont("gRust.24px")
    ItemDescription:SetColor(gRust.Colors.Text)
    ItemDescription:SetText(string.Cap(self.SelectedItem:GetDescription(), 180))
    ItemDescription:SetWrap(true)
    ItemDescription:SetContentAlignment(7)

    local Recipe = self.Side:Add("Panel")
    Recipe:Dock(TOP)
    Recipe:SetTall(128 * gRust.Hud.Scaling)
    Recipe:DockMargin(0, 112 * gRust.Hud.Scaling, 0, 0)

    local recipe = self.SelectedItem:GetRecipe()
    if (recipe) then
        for i = 1, #recipe do
            local item = recipe[i]
            local register = gRust.GetItemRegister(item.Item)
    
            local Item = Recipe:Add("gRust.Label")
            Item:Dock(TOP)
            Item:SetTall(32 * gRust.Hud.Scaling)
            Item:DockMargin(0, 0, 0, 0)
            Item:SetFont("gRust.28px")
            Item:SetColor(LocalPlayer():HasItem(item.Item, item.Quantity) and gRust.Colors.Text or Color(253, 213, 78))
            Item:SetText(string.format("%d %s", item.Quantity, register:GetName()))
            Item:SetContentAlignment(4)
        end
    end

    local ItemInformation = self.Side:Add("gRust.ItemInfo")
    ItemInformation:Dock(TOP)
    ItemInformation:SetTall(280 * gRust.Hud.Scaling)
    ItemInformation:DockMargin(0, 32 * gRust.Hud.Scaling, 0, 0)
    ItemInformation:SetItem(self.SelectedItem:GetId())
    ItemInformation:Rebuild()

    local UnlockContainer = self.Side:Add("DPanel")
    UnlockContainer:Dock(BOTTOM)
    UnlockContainer:SetTall(100 * gRust.Hud.Scaling)
    UnlockContainer.Paint = function(me, w, h)
        surface.SetDrawColor(18, 20, 18)
        surface.DrawRect(0, 0, w, h)
    end

    local cost = tonumber(self.SelectedItemCost or 0)
    local hasEnoughScrap = LocalPlayer():HasItem("scrap", cost)

    local UnlockButton = UnlockContainer:Add("gRust.Button")
    UnlockButton:Dock(RIGHT)
    UnlockButton:SetWide(236 * gRust.Hud.Scaling)
    UnlockButton:SetContentAlignment(5)
    if (IsValid(self.SelectedNode) and self.SelectedNode.Unlocked) then
        UnlockButton:SetDefaultColor(Color(81, 108, 38))
        UnlockButton:SetHoveredColor(Color(81, 108, 38))
        UnlockButton:SetSelectedColor(Color(81, 108, 38))
        UnlockButton:SetTextColor(Color(255, 255, 255))
        UnlockButton:SetText("UNLOCKED")
        UnlockButton:Dock(FILL)
    elseif (IsValid(self.SelectedNode) and self.SelectedNode.Locked) then
        UnlockButton:SetDefaultColor(Color(150, 29, 1))
        UnlockButton:SetHoveredColor(Color(173, 57, 30))
        UnlockButton:SetSelectedColor(Color(117, 22, 0))
        UnlockButton:SetText("NO PATH")
    elseif (hasEnoughScrap) then
        UnlockButton:SetDefaultColor(Color(81, 108, 38))
        UnlockButton:SetHoveredColor(Color(97, 138, 31))
        UnlockButton:SetSelectedColor(Color(123, 189, 18))
        UnlockButton:SetTextColor(Color(255, 255, 255))
        UnlockButton:SetText("UNLOCK")
        UnlockButton.DoClick = function(me)
            net.Start("gRust.TechTree.UnlockItem")
                net.WriteEntity(self.Entity)
                net.WriteUInt(self.SelectedItem:GetIndex(), gRust.ItemIndexBits)
            net.SendToServer()

            gRust.PlaySound("techtree.unlock")
        end
    else
        UnlockButton:SetDefaultColor(Color(150, 29, 1))
        UnlockButton:SetHoveredColor(Color(173, 57, 30))
        UnlockButton:SetSelectedColor(Color(117, 22, 0))
        UnlockButton:SetText("CAN'T AFFORD")
    end

    if (IsValid(self.SelectedNode) and !self.SelectedNode.Unlocked) then
        local Cost = UnlockContainer:Add("Panel")
        Cost:Dock(FILL)
        local scrapIcon = gRust.GetItemRegister("scrap"):GetIcon()
        Cost.Paint = function(me, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(scrapIcon)
            surface.DrawTexturedRect(12 * gRust.Hud.Scaling, h * 0.5 - 24 * gRust.Hud.Scaling, 48 * gRust.Hud.Scaling, 48 * gRust.Hud.Scaling)
    
            local color = hasEnoughScrap and gRust.Colors.Text or Color(179, 76, 2)
            draw.SimpleText(cost, "gRust.42px", 92 * gRust.Hud.Scaling, h * 0.5, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:SelectNode(node)
    local cost = node.props["cost"]
    local id = node.props["id"]
    local item = gRust.GetItemRegister(id)

    self.SelectedItem = item
    self.SelectedItemCost = cost
    self:PopulateSide()
end

local BLUR_MATERIAL = Material("pp/blurscreen")
local BLUR_AMOUNT = 3
function PANEL:Paint(w, h)
    surface.SetDrawColor(39, 38, 29, 235)
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

local NODE_SIZE = 192
local NODE_SPACING = 100
local BORDER_SIZE = 5
function PANEL:VisitTechTreeNode(node, x, y, parent)
    local id = node.props["id"]
    local TechNode

    local nodeSize = round(NODE_SIZE * gRust.Hud.Scaling)
    local nodeSpacing = round(NODE_SPACING * gRust.Hud.Scaling)
    local borderSize = round(BORDER_SIZE * gRust.Hud.Scaling)

    if (id) then
        if (node.name == "Item") then
            
            local hasBlueprint = LocalPlayer():HasBlueprint(id)
            
            TechNode = self.Container:Add("gRust.TechTree.Node")
            TechNode:SetSize(nodeSize, nodeSize)
            TechNode:SetItem(id)
            TechNode:SetPos(x, y)
            TechNode:NoClipping(true)
            if (IsValid(parent) and (!parent:GetUnlocked() or parent:GetLocked())) then
                TechNode:SetLocked(true)
            elseif (hasBlueprint) then
                TechNode:SetUnlocked(true)
            end
    
            TechNode.DoClick = function(me)
                if (IsValid(self.SelectedNode)) then
                    self.SelectedNode:SetSelected(false)
                end
    
                me:SetSelected(true)
                me:MoveToFront()
                self.SelectedNode = me
    
                self:SelectNode(node)
            end
    
            if (IsValid(parent)) then
                TechNode.Parents[#TechNode.Parents + 1] = parent
            end

            self.Nodes[id] = TechNode
        elseif (node.name == "Reference") then
            self.References[#self.References + 1] = {
                id = id,
                node = parent
            }
        end
    end

    local children = node.children
    local float = node.props["float"] or "middle"

    local childx = x
    if (float == "left") then
        childx = childx - (#children * nodeSize) + nodeSize
    elseif (float == "middle") then
        childx = childx - (#children * (nodeSize - borderSize) * 0.5) + ((nodeSize - borderSize) * 0.5)
    end

    local childy = y + nodeSize + nodeSpacing
    for i = 1, #children do
        local child = children[i]
        local offset = child.props["offset"] or 0
        childx = childx + (offset * (nodeSize + nodeSpacing))

        self:VisitTechTreeNode(child, childx, childy, TechNode)

        childx = childx + (nodeSize - borderSize)
    end
    
    self:PopulateSide()
end

function PANEL:ReloadTechTree()
    if (!IsValid(self.Entity)) then return end

    self.Nodes = {}
    self.References = {}

    self.SelectedItem = nil
    local data = self.Entity.TechTree
    self.Lines = {}
    self:VisitTechTreeNode(data[1], ScrW() * 0.5, 0)

    for k, v in pairs(self.References) do
        local node = self.Nodes[v.id]
        local parent = v.node

        if (IsValid(parent) and IsValid(node)) then
            node.Parents[#node.Parents + 1] = parent
            if (parent:GetUnlocked()) then
                node:SetLocked(false)
            end
        end
    end
end

function PANEL:SetEntity(ent)
    local data = ent.TechTree
    
    self.Entity = ent
    self:ReloadTechTree()
end

vgui.Register("gRust.TechTree", PANEL, "Panel")