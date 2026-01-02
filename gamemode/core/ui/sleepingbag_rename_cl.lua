gRust.RenameSleepingBagMenu = gRust.RenameSleepingBagMenu or {}

local BACKGROUND_COLOR = Color(37, 36, 31, 180)
local BACKGROUND_MATERIAL = Material("ui/background_linear.png", "noclamp smooth")

function gRust.OpenSleepingBagRename(ent)
    if (!IsValid(ent)) then return end

    local scrw, scrh = ScrW(), ScrH()

    local panel = vgui.Create("EditablePanel")
    panel:SetSize(scrw, scrh)
    panel:SetPos(0, 0)
    panel:MakePopup()
    panel:SetKeyboardInputEnabled(true)
    panel:SetMouseInputEnabled(true)

    panel.Paint = function(me, w, h)
        gRust.DrawPanelBlurred(0, 0, w, h, 4, BACKGROUND_COLOR, me)

        surface.SetDrawColor(BACKGROUND_COLOR)
        surface.SetMaterial(BACKGROUND_MATERIAL)
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)

        surface.SetDrawColor(Color(115, 140, 68, 2))
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)
    end

    local frameWidth = 500 * gRust.Hud.Scaling
    local frameHeight = 250 * gRust.Hud.Scaling

    local contentPanel = vgui.Create("DPanel", panel)
    contentPanel:SetSize(frameWidth, frameHeight)
    contentPanel:Center()

    contentPanel.Paint = function(me, w, h)
        surface.SetDrawColor(gRust.Colors.Panel)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(gRust.Colors.PrimaryPanel)
        surface.DrawRect(0, 0, w, 60 * gRust.Hud.Scaling)

        draw.SimpleText("RENAME", "gRust.24px", 20 * gRust.Hud.Scaling, 30 * gRust.Hud.Scaling, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local CurrentName = ent:GetBagName() or "Unnamed Bag"

    local textEntry = vgui.Create("gRust.Input", contentPanel)
    textEntry:SetPos(20 * gRust.Hud.Scaling, 90 * gRust.Hud.Scaling)
    textEntry:SetSize(frameWidth - 40 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    textEntry:SetValue(CurrentName)
    textEntry:SetPlaceholder("Enter new name...")
    textEntry:RequestFocus()

    local renameButton = vgui.Create("gRust.Button", contentPanel)
    renameButton:SetPos(20 * gRust.Hud.Scaling, 180 * gRust.Hud.Scaling)
    renameButton:SetSize(frameWidth / 2 - 30 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    renameButton:SetText("RENAME")
    if renameButton.SetFont then
        renameButton:SetFont("gRust.24px")
    end

    renameButton.DoClick = function()
        local newName = textEntry:GetValue()
        if (newName and newName ~= "") then
            net.Start("gRust.RenameSleepingBag")
            net.WriteEntity(ent)
            net.WriteString(newName)
            net.SendToServer()
        end
        panel:Remove()
    end

    textEntry.OnEnter = function()
        renameButton:DoClick()
    end

    local cancelButton = vgui.Create("gRust.Button", contentPanel)
    cancelButton:SetPos(frameWidth / 2 + 10 * gRust.Hud.Scaling, 180 * gRust.Hud.Scaling)
    cancelButton:SetSize(frameWidth / 2 - 30 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    cancelButton:SetText("CANCEL")
    if cancelButton.SetFont then
        cancelButton:SetFont("gRust.24px")
    end

    cancelButton.DoClick = function()
        panel:Remove()
    end
end
