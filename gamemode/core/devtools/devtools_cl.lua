local F1Down = false
hook.Add("Think", "gRust.DevTools", function(pl, button)
    if (input.IsButtonDown(KEY_F1)) then
        if (!F1Down) then
            if (IsValid(gRust.DevTools)) then
                gRust.DevTools:Remove()
            elseif (gRust.Hud.ShouldDraw) then
                gRust.DevTools = vgui.Create("gRust.DevTools")
                gRust.DevTools:SetPos(0, 0)
                gRust.DevTools:SetSize(ScrW(), ScrH() * 0.88)
                gRust.DevTools:MakePopup()
                gRust.DevTools:DockMargin(8, 8, 8, 8)
                
                gRust.DevTools:AddPage("ITEMS", "gRust.DevTools.Items")
            end

            F1Down = true
        end
    else
        F1Down = false
    end
end)