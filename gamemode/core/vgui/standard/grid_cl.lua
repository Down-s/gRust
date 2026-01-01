local PANEL = {}

AccessorFunc(PANEL, "Centered", "Centered", FORCE_BOOL)

function PANEL:Init()

end

function PANEL:Paint(w, h)
end

function PANEL:GetCols()
    return self.Cols
end

function PANEL:SetCols(cols)
    self.Cols = cols
    self:InvalidateLayout()
end

function PANEL:SetColWide(wide)
    self.ColWide = wide
    self:InvalidateLayout()
end

function PANEL:SetRows(rows)
    self.Rows = rows
    self:InvalidateLayout()
end

function PANEL:SetRowTall(tall)
    self.RowTall = tall
    self:InvalidateLayout()
end

function PANEL:SetCellSize(size)
    self.CellSize = size
    self:InvalidateLayout()
end

function PANEL:SetCellSpacing(spacing)
    self.CellSpacing = spacing
    self:InvalidateLayout()
end

function PANEL:GetColWide()
    return self.ColWide
end

function PANEL:GetRowTall()
    return self.RowTall
end

function PANEL:PerformLayout(w, h)
    local cols = self.Cols or 1
    local rows = self.Rows or 1
    local colWide = self.ColWide or w / cols
    local rowTall = self.RowTall or h / rows
    local cellSize = self.CellSize or math.min(colWide, rowTall)
    local cellSpacing = self.CellSpacing or 0

    local x = 0
    local y = 0

    for k, v in pairs(self:GetChildren()) do
        v:SetSize(cellSize, cellSize)
        v:SetPos(x, y)

        x = x + cellSize + cellSpacing

        if (x + cellSize > w) then
            x = 0
            y = y + cellSize + cellSpacing
        end
    end

    -- Shift all children to the center if needed
    if (self:GetCentered()) then
        local totalWidth = (cellSize + cellSpacing) * cols
        local totalHeight = (cellSize + cellSpacing) * rows

        local offsetX = (w - totalWidth) / 2
        local offsetY = (h - totalHeight) / 2

        for k, v in pairs(self:GetChildren()) do
            v:SetPos(v.x + offsetX, v.y + offsetY)
        end
    end
end

vgui.Register("gRust.Grid", PANEL, "Panel")