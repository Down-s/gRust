include("shared.lua")
DEFINE_BASECLASS("rust_swep")

local CHECK_DISTANCE = 192

local HIGHLIGHT_ANIM_TIME = 0.05
local HIGHLIGHT_ANIM_SCALE = 1.25
local HIGHLIGHT_ANIM_COLOR = Color(255, 225, 0)

local BOX_SIZE = Vector(1, 1, 1)
local BOX_COLOR = Color(255, 255, 255, 255)
local WIRE_COLOR = Color(0, 255, 0)

function SWEP:Deploy()
    self.Routes = {}
    self.DrawMatrix = Matrix()
    self.DrawMatrix:SetScale(Vector(0, 0, 0))
    hook.Add("PreDrawOpaqueRenderables", self, function(self)
        self:UpdateHighlightedIO()
        self:DrawIO()
        self:DrawConnection()
    end)
end

function SWEP:Holster()
    hook.Remove("PreDrawOpaqueRenderables", self)
end

local HUD_ANIM_TIME = 0.1
function SWEP:DrawHUD()
    if (self.ConnectingFrom) then
        local wireDist = 0
        local fromData = self.ConnectingFrom.isinput and self.ConnectingFrom.ent.Inputs or self.ConnectingFrom.ent.Outputs
        for i = 0, #self.Routes - 1 do
            local from = self.Routes[i] or self.ConnectingFrom.ent:LocalToWorld(fromData[self.ConnectingFrom.slot].Pos)
            local to = self.Routes[i + 1]
            wireDist = wireDist + from:DistToSqr(to)
        end

        local lastRoute = self.Routes[#self.Routes] or self.ConnectingFrom.ent:LocalToWorld(fromData[self.ConnectingFrom.slot].Pos)
        wireDist = wireDist + lastRoute:DistToSqr(self:GetOwner():GetEyeTraceNoCursor().HitPos)

        local maxDist = self.MaxWireLength
        local maxRoutes = self.MaxWireRoutes

        local wireDist = math.sqrt(wireDist)
        local distRemaining = (maxDist - wireDist) * UNITS_TO_METERS

        local routesLeft = maxRoutes - #self.Routes

        local y = ScrH() * 0.525
        draw.SimpleTextOutlined(string.format("%.2f", distRemaining), "gRust.48px", ScrW() * 0.5, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
        draw.SimpleTextOutlined(routesLeft, "gRust.32px", ScrW() * 0.5, y + 36 * gRust.Hud.Scaling, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    end

    local progress = 0
    if (self.HighlightedIO) then
        progress = math.Clamp((CurTime() - self.HighlightedIO.time) / HUD_ANIM_TIME, 0, 1)
        self.HudIO = self.HighlightedIO
    else
        if (self.HudIO) then
            progress = 1 - math.Clamp((CurTime() - self.HudIO.stop) / HUD_ANIM_TIME, 0, 1)
        end
    end

    if (progress <= 0.05) then return end
    
    local io = self.HudIO
    if (!io) then return end
    local ent = io.ent
    local data = io.isinput and ent.Inputs or ent.Outputs
    local slot = data[io.slot]

    local x, y = ScrW() * 0.5, ScrH() * 0.45
    local offsetY = 32 * gRust.Hud.Scaling

    local scale = Vector(1, 1, 0) * progress
    self.DrawMatrix:Identity()
    self.DrawMatrix:Translate(Vector(x, y, 0))
    self.DrawMatrix:Scale(scale)
    self.DrawMatrix:Translate(Vector(-x, -y, 0))

    cam.PushModelMatrix(self.DrawMatrix)

    draw.SimpleTextOutlined(slot.Name, "gRust.48px", x, y - offsetY, HIGHLIGHT_ANIM_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    draw.SimpleTextOutlined("Empty", "gRust.24px", x, y + 36 * gRust.Hud.Scaling - offsetY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)

    cam.PopModelMatrix()
end

local function TraverseIO(ent, tbl, checkpos)
    local ang = ent:GetAngles()
    for i = 1, #tbl do
        local slot = tbl[i]
        local pos = ent:LocalToWorld(slot.Pos)

        if (pos:DistToSqr(checkpos) < 2^2) then
            return i
        end
    end
end

function SWEP:UpdateHighlightedIO()
    local pl = self:GetOwner()
    local checkPos = pl:GetEyeTraceNoCursor().HitPos
    local entities = ents.FindInSphere(pl:GetPos(), CHECK_DISTANCE)

    self.IOEntities = {}

    local found = false
    for i = 1, #entities do
        local ent = entities[i]
        if (!ent.IOEntity) then continue end

        self.IOEntities[#self.IOEntities + 1] = ent

        if (!found) then
            local inp = TraverseIO(ent, ent.Inputs, checkPos)
            if (inp) then
                self:SetHighlightedIO(ent, inp, true)
                found = true
                continue
            end
    
            local out = TraverseIO(ent, ent.Outputs, checkPos)
            if (out) then
                self:SetHighlightedIO(ent, out, false)
                found = true
                continue
            end
        end

        if (self.HighlightedIO and self.HighlightedIO.ent == ent) then
            if (self.HighlightedIO.stop) then
                if (CurTime() - self.HighlightedIO.stop > HIGHLIGHT_ANIM_TIME) then
                    self.HighlightedIO = nil
                end
            else
                self.HighlightedIO.stop = CurTime()
            end
        end
    end
end

function SWEP:SetHighlightedIO(ent, slot, isinput)
    local io = self.HighlightedIO
    if (!io or io.ent != ent or io.slot != slot or io.isinput != isinput) then
        self.HighlightedIO = {
            ent = ent,
            slot = slot,
            isinput = isinput,
            time = CurTime()
        }
    end
end

function SWEP:DrawIOTable(ent, isinput)
    local tbl = isinput and ent.Inputs or ent.Outputs
    local ang = ent:GetAngles()
    local io = self.HighlightedIO
    for i = 1, #tbl do
        local slot = tbl[i]
        local pos = ent:LocalToWorld(slot.Pos)

        local col = BOX_COLOR
        local progress = 0
        local connFrom = self.ConnectingFrom
        if (connFrom and connFrom.ent == ent and connFrom.slot == i and connFrom.isinput == isinput) then
            progress = 1
            col = WIRE_COLOR
        elseif (io and io.ent == ent and io.slot == i and io.isinput == isinput) then
            if (io.stop) then
                progress = 1 - math.Clamp((CurTime() - io.stop) / HIGHLIGHT_ANIM_TIME, 0, 1)
            else
                progress = math.Clamp((CurTime() - io.time) / HIGHLIGHT_ANIM_TIME, 0, 1)
            end
            
            col = math.LerpColor(BOX_COLOR, HIGHLIGHT_ANIM_COLOR, progress)
        end

        local size = BOX_SIZE * (1 + progress * (HIGHLIGHT_ANIM_SCALE - 1))
        render.DrawBox(pos, ang, -size, size, col, true)
    end
end

local BOX_SIZE = Vector(1, 1, 1)
local BOX_COLOR = Color(255, 255, 255, 255)
function SWEP:DrawIO()
    cam.Start3D()
    render.OverrideDepthEnable(true, true)
    render.SetColorMaterial()

    local pl = self:GetOwner()
    local ioentities = self.IOEntities
    for i = 1, #ioentities do
        local ent = ioentities[i]
        local inputs = ent.Inputs
        local outputs = ent.Outputs

        self:DrawIOTable(ent, true)
        self:DrawIOTable(ent, false)
    end

    render.OverrideDepthEnable(false, false)
    cam.End3D()
end

function SWEP:DoEffects(pos)
    local effectData = EffectData()
    effectData:SetOrigin(pos)
    util.Effect("ManhackSparks", effectData)

    EmitSound("wiretool.place", pos, -1, CHAN_AUTO, 0.1, 100)
end

function SWEP:CreateRoute(pos)
    self.Routes[#self.Routes + 1] = pos
end

function SWEP:CompleteConnection()
    local inp, out
    if (self.ConnectingFrom.isinput) then
        inp = self.ConnectingFrom
        out = self.HighlightedIO
    else
        inp = self.HighlightedIO
        out = self.ConnectingFrom

        self.Routes = table.Reverse(self.Routes)
    end

    net.Start("gRust.IO.CreateConnection")
    net.WriteEntity(inp.ent)
    net.WriteUInt(inp.slot, 4)
    net.WriteEntity(out.ent)
    net.WriteUInt(out.slot, 4)
    net.WriteUInt(#self.Routes, 5)
    for i = 1, #self.Routes do
        net.WriteVector(self.Routes[i])
    end
    net.SendToServer()

    self.Routes = {}
    self.ConnectingFrom = nil
end

function SWEP:PrimaryAttack()
    if (!IsFirstTimePredicted()) then return end

    local pl = self:GetOwner()
    local io = self.HighlightedIO

    if (self.ConnectingFrom) then
        local pos = pl:GetEyeTraceNoCursor().HitPos
        self:DoEffects(pos)
        
        if (io) then
            self:CompleteConnection()
        else
            self:CreateRoute(pos)
        end
    elseif (io) then
        self.ConnectingFrom = io
        
        local ent = io.ent
        local data = io.isinput and ent.Inputs or ent.Outputs
        local slot = data[io.slot]
        local pos = ent:LocalToWorld(slot.Pos)
        self:DoEffects(pos)
    end
end

function SWEP:SecondaryAttack()
    if (self.ConnectingFrom) then
        self.ConnectingFrom = nil
        self.Routes = {}
    end
end

function SWEP:DrawConnection()
    if (!self.ConnectingFrom) then return end

    local pl = self:GetOwner()

    local fromEnt = self.ConnectingFrom.ent
    local data = self.ConnectingFrom.isinput and fromEnt.Inputs or fromEnt.Outputs
    local fromSlot = data[self.ConnectingFrom.slot]

    local fromPos = #self.Routes == 0 and
        fromEnt:LocalToWorld(fromSlot.Pos) or
        self.Routes[#self.Routes]
    
    local toPos = pl:GetEyeTraceNoCursor().HitPos
    if (self.HighlightedIO) then
        local toEnt = self.HighlightedIO.ent
        local toSlot = self.HighlightedIO.isinput and toEnt.Inputs or toEnt.Outputs
        local toSlot = toSlot[self.HighlightedIO.slot]
        toPos = toEnt:LocalToWorld(toSlot.Pos)
    end

    cam.Start3D()
    render.OverrideDepthEnable(true, true)
    render.SetColorMaterial()

    for i = 0, #self.Routes - 1 do
        local from = self.Routes[i] or fromEnt:LocalToWorld(fromSlot.Pos)
        local to = self.Routes[i + 1]
        cam.Start3D()
        render.SetColorMaterial()
        render.DrawBeam(from, to, 0.3, 0, 10, WIRE_COLOR)
        cam.End3D()
    end

    render.DrawBeam(fromPos, toPos, 0.25, 0, 10, WIRE_COLOR)
    render.DrawSphere(toPos, 0.4, 10, 10, WIRE_COLOR)
    render.OverrideDepthEnable(false, false)
    cam.End3D()
end