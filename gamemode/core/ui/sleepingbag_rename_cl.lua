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

    local contentPanel = panel:Add("Panel")
    contentPanel:SetSize(frameWidth, frameHeight)
    contentPanel:Center()
    contentPanel.Paint = function(me, w, h)
        surface.SetDrawColor(gRust.Colors.Panel)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(gRust.Colors.PrimaryPanel)
        surface.DrawRect(0, 0, w, 60 * gRust.Hud.Scaling)

        draw.SimpleText("RENAME", "gRust.24px", 20 * gRust.Hud.Scaling, 30 * gRust.Hud.Scaling, gRust.Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local currentName = ent:GetBagName() or "Unnamed Bag"

    local textEntry = contentPanel:Add("gRust.Input")
    textEntry:SetPos(20 * gRust.Hud.Scaling, 90 * gRust.Hud.Scaling)
    textEntry:SetSize(frameWidth - 40 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    textEntry:SetValue(currentName)
    textEntry:SetPlaceholder("Enter new name...")
    textEntry:RequestFocus()

    local renameButton = contentPanel:Add("gRust.Button")
    renameButton:SetPos(20 * gRust.Hud.Scaling, 180 * gRust.Hud.Scaling)
    renameButton:SetSize(frameWidth / 2 - 30 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    renameButton:SetText("RENAME")
    renameButton:SetFont("gRust.24px")
    renameButton.DoClick = function()
        local newName = textEntry:GetValue()
        if (newName and newName != "") then
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

    local cancelButton = contentPanel:Add("gRust.Button")
    cancelButton:SetPos(frameWidth / 2 + 10 * gRust.Hud.Scaling, 180 * gRust.Hud.Scaling)
    cancelButton:SetSize(frameWidth / 2 - 30 * gRust.Hud.Scaling, 50 * gRust.Hud.Scaling)
    cancelButton:SetText("CANCEL")
    cancelButton:SetFont("gRust.24px")
    cancelButton.DoClick = function()
        panel:Remove()
    end
end