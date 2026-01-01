net.Receive("gRust.Combat.UpdateBlock", function(len)
    local endTime = net.ReadFloat()
    local pl = LocalPlayer()

    pl.CombatBlockEnd = endTime
end)

local BLOCK_COLOR = Color(255, 0, 0)
local OUTLINE_COLOR = Color(0, 0, 0)
hook.Add("PostRenderVGUI", "gRust.Combat.Block", function()
    local pl = LocalPlayer()
    if (pl.CombatBlockEnd and pl.CombatBlockEnd > CurTime()) then
        local scrw, scrh = ScrW(), ScrH()
        local scaling = gRust.Hud.Scaling
        local icon = gRust.GetIcon("target")
        local marginX = 32 * scaling
        local marginY = 24 * scaling
        local iconSize = 36 * scaling
        
        if (IsValid(gRust.Inventory)) then
            local outline = 1
            local timeRemaining = pl.CombatBlockEnd - CurTime()
            local timeRemainingText = string.FormattedTime(timeRemaining, "%02i:%02i")
            draw.SimpleTextOutlined(timeRemainingText, "gRust.32px", scrw - marginX, marginY, BLOCK_COLOR, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, outline, OUTLINE_COLOR)
    
            surface.SetFont("gRust.32px")
            local textWidth, textHeight = surface.GetTextSize(timeRemainingText)
            local totalWidth = textWidth + iconSize + marginX
            local x, y = scrw - totalWidth - 12 * scaling, marginY
            
            surface.SetMaterial(icon)
            
            surface.SetDrawColor(BLOCK_COLOR)
            surface.DrawTexturedRect(x, y, iconSize, iconSize)
        else
            surface.SetMaterial(icon)
            surface.SetDrawColor(BLOCK_COLOR)
            surface.DrawTexturedRect(scrw - marginX - iconSize, marginY, iconSize, iconSize)
        end

        if (pl:IsInSafeZone()) then
            local timeRemaining = pl.CombatBlockEnd - CurTime()
            local timeRemainingText = string.FormattedTime(timeRemaining, "%02i:%02i")
            
            local scrw, scrh = ScrW(), ScrH()
            local scaling = gRust.Hud.Scaling
            local icon = gRust.GetIcon("skull")
            local marginY = 192 * scaling
            local iconSize = 72 * scaling

            local text = "YOU ARE CONSIDERED HOSTILE - LETHAL FORCE AUTHORIZED"
            draw.SimpleTextOutlined(text, "gRust.38px", scrw * 0.5, marginY, BLOCK_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 * scaling, OUTLINE_COLOR)
            draw.SimpleTextOutlined(timeRemainingText, "gRust.38px", scrw * 0.5, marginY + 48 * scaling, BLOCK_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 * scaling, OUTLINE_COLOR)

            local tw, th = surface.GetTextSize(text)
            
            surface.SetMaterial(icon)
            surface.SetDrawColor(BLOCK_COLOR)

            surface.DrawTexturedRect(scrw * 0.5 - tw * 0.5 - iconSize - 16 * scaling, marginY - iconSize * 0.5, iconSize, iconSize)
            surface.DrawTexturedRect(scrw * 0.5 + tw * 0.5 + 16 * scaling, marginY - iconSize * 0.5, iconSize, iconSize)
        end
    end
end)