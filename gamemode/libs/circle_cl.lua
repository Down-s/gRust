local CIRCLE = {}
CIRCLE.__index = CIRCLE

local function CircleAccessorFunc(tbl, name, changeVerts, changeTransform)
    tbl["Set" .. name] = function(self, val)
        if (self[name] == val) then return end
        
        self[name] = val

        if (changeVerts) then
            self.VerticesDirty = true
        end

        if (changeTransform) then
            self.TransformDirty = true
        end
    end

    tbl["Get" .. name] = function(self)
        return self[name]
    end
end

CircleAccessorFunc(CIRCLE, "Radius",        true, false)
CircleAccessorFunc(CIRCLE, "Color",         false, false)
CircleAccessorFunc(CIRCLE, "Material",      false, false)
CircleAccessorFunc(CIRCLE, "Thickness",     true, false)
CircleAccessorFunc(CIRCLE, "Segments",      true, false)
CircleAccessorFunc(CIRCLE, "StartAngle",    true, false)
CircleAccessorFunc(CIRCLE, "EndAngle",      true, false)
CircleAccessorFunc(CIRCLE, "Rotation",      false, true)
CircleAccessorFunc(CIRCLE, "Filled",        false, false)

function CIRCLE:Init()
    self.Radius = 0
    self.Center = Vector(0, 0, 0)
    self.Color = Color(255, 255, 255, 255)
    self.Thickness = 32
    self.Segments = -1
    self.StartAngle = 0
    self.EndAngle = 360
    self.Rotation = 0
    self.Filled = false
    self.Vertices = {}
    self.Matrix = Matrix()
end

function CIRCLE:SetCenter(x, y)
    self.x = x
    self.y = y

    self.TransformDirty = true
end

function CIRCLE:GetCenter()
    return self.x, self.y
end

function CIRCLE:RegenerateVertices()
    if (self.Radius == 0) then return end
    if (self.StartAngle == self.EndAngle) then return end

    local segments = self.Segments
    if (segments == -1) then
        segments = math.ceil(self.Radius / 2)
    end
    
    local vertices = {}
    local innerVertices = {} -- The inside circle that will be used to mask the circle for the thickness

    local step = math.tau / segments
    local startAngle = math.rad(self.StartAngle)
    local endAngle = math.rad(self.EndAngle)

    if (self.StartAngle < 0) then
        startAngle = math.tau + startAngle
    end

    if (self.EndAngle < 0) then
        endAngle = math.tau + endAngle
    end

    if (startAngle > endAngle) then
        local temp = startAngle
        startAngle = endAngle
        endAngle = temp
    end

    local cx, cy = ScrW() / 2, ScrH() / 2
    for rad = startAngle, endAngle + step, step do
        rad = math.min(rad, endAngle)
        
        local x = cx + math.cos(rad) * self.Radius
        local y = cy + math.sin(rad) * self.Radius

        local x2 = cx + math.cos(rad) * (self.Radius - self.Thickness)
        local y2 = cy + math.sin(rad) * (self.Radius - self.Thickness)

        table.insert(vertices, {x = x, y = y})
        table.insert(innerVertices, {x = x2, y = y2})
    end

    -- Insert a vertex at the center of each circle
    if (endAngle - startAngle != 360) then
        table.insert(vertices, 1, {x = cx, y = cy})
        table.insert(innerVertices, 1, {x = cx, y = cy})
    else
        table.remove(vertices)
        table.remove(innerVertices)
    end

    self.Vertices = vertices
    self.InnerVertices = innerVertices

    self.VerticesDirty = false
end

function CIRCLE:RegenerateTransform()
    local cx, cy = ScrW() / 2, ScrH() / 2
    self.Matrix = Matrix()
    self.Matrix:Translate(Vector(self.x, self.y, 0))
    self.Matrix:Rotate(Angle(0, self.Rotation, 0))
    self.Matrix:Translate(Vector(-cx, -cy, 0))

    self.TransformDirty = false
end

function CIRCLE:Draw()
    if (self.Radius == 0) then return end
    if (self.Segments == 0) then return end
    if (self.StartAngle == self.EndAngle) then return end
    if (self.Thickness == 0 and !self.Filled) then return end

    if (self.VerticesDirty) then
        self:RegenerateVertices()
        self.VerticesDirty = false
    end

    if (self.TransformDirty) then
        self:RegenerateTransform()
        self.TransformDirty = false
    end
    
    local vertices = self.Vertices
    local innerVertices = self.InnerVertices
    
    draw.NoTexture()

    render.ClearStencil()

    cam.PushModelMatrix(self.Matrix, true)
        if (!self.Filled) then
            render.SetStencilEnable(true)
            render.SetStencilCompareFunction(STENCIL_NEVER)
            render.SetStencilFailOperation(STENCIL_REPLACE)
            render.SetStencilZFailOperation(STENCIL_REPLACE)
            render.SetStencilWriteMask(1)
            render.SetStencilTestMask(1)
            render.SetStencilReferenceValue(1)

            if (self.Material) then
                surface.SetMaterial(self.Material)
            end

            surface.DrawPoly(innerVertices)

            render.SetStencilCompareFunction(STENCIL_GREATER)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation(STENCIL_KEEP)
        end

        surface.SetDrawColor(self.Color)
        surface.DrawPoly(vertices)

        if (!self.Filled) then
            render.SetStencilEnable(false)
        end
    cam.PopModelMatrix()
end

function gRust.CreateCircle()
    local circle = setmetatable({}, CIRCLE)
    circle:Init()

    return circle
end