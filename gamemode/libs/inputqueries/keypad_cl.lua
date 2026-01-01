gRust.InputQuery = gRust.InputQuery or {}

local TEXT_COLOR = Color(0, 0, 0, 200)
local BACKGROUND_COLOR = Color(37, 36, 31, 180)
local BACKGROUND_MATERIAL = Material("ui/background_linear.png", "noclamp smooth")
function gRust.InputQuery.Keypad(title, callback)
    local keypadWidth = 250 * gRust.Hud.Scaling
    local keypadMargin = 6 * gRust.Hud.Scaling

    local CurrentInput = ""

    local scrw, scrh = ScrW(), ScrH()

    local panel = vgui.Create("Panel")
    panel:SetPos(0, 0)
    panel:SetSize(scrw, scrh)
    panel:MakePopup()
    panel:SetKeyboardInputEnabled(true)
    panel:SetMouseInputEnabled(true)
    panel.Paint = function(me, w, h)
        gRust.DrawPanelBlurred(0, 0, w, h, 4, BACKGROUND_COLOR, self)

        surface.SetDrawColor(BACKGROUND_COLOR)
        surface.SetMaterial(BACKGROUND_MATERIAL)
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)

        surface.SetDrawColor(Color(115, 140, 68, 2))
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)
    end

    local container = panel:Add("Panel")
    container:SetWide(keypadWidth)

    local AddRow = function()
        local row = container:Add("Panel")
        row:Dock(TOP)
        row:SetTall(80 * gRust.Hud.Scaling)
        row:DockMargin(0, keypadMargin, 0, 0)
        
        return row
    end

    local AddNumber = function(n)
        CurrentInput = CurrentInput .. n
        gRust.PlaySound("codelock.beep")

        if (string.len(CurrentInput) >= 4) then
            callback(CurrentInput)
            panel:Remove()
        end
    end

    local Title = container:Add("Panel")
    Title:Dock(TOP)
    Title:SetTall(50 * gRust.Hud.Scaling)
    Title.Paint = function(me, w, h)
        draw.SimpleTextOutlined(title, "gRust.50px", w / 2, h / 2, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, TEXT_COLOR)
    end

    local Top = AddRow()
    Top:DockMargin(0, 0, 0, keypadMargin)

    local Input = Top:Add("Panel")
    Input:Dock(FILL)
    Input.Paint = function(me, w, h)
        surface.SetDrawColor(0, 0, 0, 225)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(CurrentInput, "gRust.64px", w / 2, h / 2, gRust.Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local currentRow
    for i = 1, 9 do
        if ((i - 1) % 3 == 0) then
            currentRow = AddRow()
        end

        local num = 9 - i + 1
        num = i % 3 == 0 and num + 2 or num
        num = i % 3 == 1 and num - 2 or num

        local button = currentRow:Add("gRust.Button")
        button:Dock(LEFT)
        local isMiddle = i % 3 == 2
        button:DockMargin(isMiddle and keypadMargin or 0, 0, isMiddle and keypadMargin or 0, 0)
        button:SetWide(80 * gRust.Hud.Scaling)
        button:SetText(num)
        button:SetFont("gRust.64px")
        button:SetTextColor(TEXT_COLOR)
        button.DoClick = function(me)
            AddNumber(num)
        end
    end

    local Bottom = AddRow()

    local Zero = Bottom:Add("gRust.Button")
    Zero:Dock(LEFT)
    Zero:DockMargin(0, 0, keypadMargin, 0)
    Zero:SetWide(160 + keypadMargin * gRust.Hud.Scaling)
    Zero:SetText("0")
    Zero:SetFont("gRust.64px")
    Zero:SetTextColor(TEXT_COLOR)
    Zero.DoClick = function(me)
        AddNumber(0)
    end

    local Reset = Bottom:Add("gRust.Button")
    Reset:Dock(FILL)
    Reset:SetFont("gRust.64px")
    Reset:SetText("C")
    Reset:SetTextColor(TEXT_COLOR)
    Reset.DoClick = function(me)
        CurrentInput = ""
    end
    
    container.PerformLayout = function(me, w, h)
        local totalWidth, totalHeight = 0, 0
        for _, child in pairs(me:GetChildren()) do
            local childW, childH = child:GetSize()
            totalWidth = totalWidth + childW
            totalHeight = totalHeight + childH
            totalHeight = totalHeight + keypadMargin
        end

        me:SetTall(totalHeight)

        container:Center()
    end
end