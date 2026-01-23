net.Receive("Kit_BobTheBuilder", function()
    -- Create main frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(600, 700)
    frame:Center()
    frame:SetTitle("D-Frame Starter Kit")
    frame:SetVisible(true)
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)
    frame:MakePopup()
    -- Header panel
    local header = vgui.Create("DPanel", frame)
    header:Dock(TOP)
    header:SetHeight(80)
    header.Paint = function(self, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(231, 76, 60), true, true, false, false)
        draw.SimpleText("D-Frame Starter Kit", "DermaLarge", w / 2, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Organized by sections", "DermaDefault", w / 2, 55, Color(255, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Scroll panel for items
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)
    scroll:DockMargin(10, 10, 10, 10)
    -- Items organized by sections
    local sections = {
        {
            name = "Kit Builder",
            color = Color(52, 152, 219),
            items = {
                {
                    name = "100,000x wood",
                    qty = 1,
                    icon = "📦"
                },
                {
                    name = "100,000x Metal Fragments",
                    qty = 1,
                    icon = "📋"
                },
                {
                    name = "1x Furnace",
                    qty = 1,
                    icon = "🔨"
                },
                {
                    name = "1x Wood large box",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "1x building plan",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "1x Hammer",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "1x double metal door",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "2x solo lock",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "1x sleeping bag",
                    qty = 1,
                    icon = "🔧"
                },
                {
                    name = "1x Workbench Level 1",
                    qty = 1,
                    icon = "🔧"
                },
            }
        },
        {
            name = "Kit Starter",
            color = Color(46, 204, 113),
            items = {
                {
                    name = "Bow x1",
                    qty = 1,
                    icon = "🚪"
                },
                {
                    name = "Arrows x10",
                    qty = 2,
                    icon = "🔒"
                },
                {
                    name = "2x Medical Syringes",
                    qty = 1,
                    icon = "🛏️"
                },
            }
        },
    }

    local checkedItems = {}
    local itemIndex = 0
    -- Create sections
    for sectionIdx, section in ipairs(sections) do
        -- Section header with button
        local sectionHeader = vgui.Create("DPanel", scroll)
        sectionHeader:Dock(TOP)
        sectionHeader:DockMargin(0, 10, 0, 5)
        sectionHeader:SetHeight(45)
        sectionHeader.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, section.color)
            draw.SimpleText("[ " .. section.name .. " ]", "DermaLarge", 15, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            -- Count completed items in section
            local completed = 0
            local total = #section.items
            local startIdx = 0
            for i = 1, sectionIdx - 1 do
                startIdx = startIdx + #sections[i].items
            end

            for i = 1, total do
                local globalIdx = startIdx + i
                if checkedItems[globalIdx] then completed = completed + 1 end
            end

            draw.SimpleText(completed .. " / " .. total, "DermaDefault", w - 160, h / 2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        -- Section "Mark Done" button
        local sectionDoneBtn = vgui.Create("DButton", sectionHeader)
        sectionDoneBtn:SetPos(sectionHeader:GetWide() + 150, 8)
        sectionDoneBtn:SetSize(130, 29)
        sectionDoneBtn:SetText("")
        sectionDoneBtn.Paint = function(self, w, h)
            local bgColor = Color(255, 255, 255, 200)
            if self:IsHovered() then bgColor = Color(255, 255, 255, 255) end
            draw.RoundedBox(4, 0, 0, w, h, bgColor)
            -- Check if all items in this section are done
            local startIdx = 0
            for i = 1, sectionIdx - 1 do
                startIdx = startIdx + #sections[i].items
            end

            local allDone = true
            for i = 1, #section.items do
                local globalIdx = startIdx + i
                if not checkedItems[globalIdx] then
                    allDone = false
                    break
                end
            end

            local textColor = section.color
            local btnText = allDone and "✓ Collected" or "📦 Collect Kit"
            draw.SimpleText(btnText, "DermaDefaultBold", w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        sectionDoneBtn.DoClick = function()
            -- Calculate starting index for this section
            local startIdx = 0
            for i = 1, sectionIdx - 1 do
                startIdx = startIdx + #sections[i].items
            end

            -- Check if all items in section are already done
            local allDone = true
            for i = 1, #section.items do
                local globalIdx = startIdx + i
                if not checkedItems[globalIdx] then
                    allDone = false
                    break
                end
            end

            if not allDone then
                -- Mark all items in this section as collected
                for i = 1, #section.items do
                    local globalIdx = startIdx + i
                    checkedItems[globalIdx] = true
                end

                net.Start("KitCollect")
                net.WriteString(section.name)
                net.SendToServer()
                surface.PlaySound("buttons/button14.wav")
                chat.AddText(section.color, "[" .. section.name .. "] ", Color(255, 255, 255), "Kit collected! All items added to inventory.")
                -- Optional: Print items collected to console
                if SERVER then print("[D-Frame Kit] " .. ply:Nick() .. " collected " .. section.name) end
            else
                -- Unmark all items (return items)
                for i = 1, #section.items do
                    local globalIdx = startIdx + i
                    checkedItems[globalIdx] = false
                end

                surface.PlaySound("buttons/button19.wav")
                chat.AddText(section.color, "[" .. section.name .. "] ", Color(255, 255, 255), "Kit returned.")
            end
        end

        local itemCount = #section.items
        local spacing = 18
        local totalSpacing = spacing * (itemCount + 1)
        local availableWidth = 560 - totalSpacing -- Fixed width minus spacing
        local itemWidth = availableWidth / itemCount
        for i, item in ipairs(section.items) do
            itemIndex = itemIndex + 1
            local currentItemIdx = itemIndex
            checkedItems[currentItemIdx] = false
            local xPos = spacing + (i - 1) * (itemWidth + spacing)
            local itemBtn = vgui.Create("DButton", scroll)
            //i//temBtn:SetPos(xPos, 8)
            itemBtn:Dock(TOP)
            itemBtn:SetSize(itemWidth, 54)
            itemBtn:SetText("")
            itemBtn.Paint = function(self, w, h)
                local bgColor = checkedItems[currentItemIdx] and Color(46, 204, 113, 150) or Color(245, 245, 245)
                local borderColor = checkedItems[currentItemIdx] and Color(46, 204, 113) or Color(200, 200, 200)
                if self:IsHovered() then bgColor = checkedItems[currentItemIdx] and Color(46, 204, 113, 200) or Color(235, 235, 235) end
                draw.RoundedBox(6, 0, 0, w, h, bgColor)
                surface.SetDrawColor(borderColor)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
                -- Checkbox (smaller)
                local checkSize = 16
                local checkX = 8
                local checkY = 8
                if checkedItems[currentItemIdx] then
                    draw.RoundedBox(3, checkX, checkY, checkSize, checkSize, Color(46, 204, 113))
                    draw.SimpleText("✓", "DermaDefault", checkX + checkSize / 2, checkY + checkSize / 2 - 1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.RoundedBox(3, checkX, checkY, checkSize, checkSize, Color(255, 255, 255))
                    surface.SetDrawColor(150, 150, 150)
                    surface.DrawOutlinedRect(checkX, checkY, checkSize, checkSize, 1)
                end

                -- Icon (centered)
                draw.SimpleText(item.icon, "DermaLarge", w / 2, 20, Color(50, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                -- Item name (smaller font, centered)
                local textColor = checkedItems[currentItemIdx] and Color(27, 94, 60) or Color(50, 50, 50)
                draw.SimpleText(item.name, "DermaDefault", w / 2, 36, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                -- Quantity badge (top right)
                local badgeColor = checkedItems[currentItemIdx] and Color(46, 204, 113) or Color(243, 156, 18)
                draw.RoundedBox(8, w - 28, 6, 22, 18, badgeColor)
                draw.SimpleText("x" .. item.qty, "DermaDefault", w - 17, 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            itemBtn.DoClick = function()
                checkedItems[currentItemIdx] = not checkedItems[currentItemIdx]
                if checkedItems[currentItemIdx] then
                    surface.PlaySound("buttons/button15.wav")
                else
                    surface.PlaySound("buttons/button19.wav")
                end

                sectionHeader:InvalidateLayout(true)
            end
        end
    end
end)