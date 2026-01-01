AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

util.PrecacheModel("models/darky_m/rust/worldmodels/targComp.mdl")

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "FinishTime")
end

function ENT:Initialize()
    self:SetModel("models/darky_m/rust/worldmodels/targComp.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
end

local SCREEN_POS = Vector(6.5, 10, 18)
local SCREEN_ANG = Angle(0, -90, 90)
local SCREEN_WIDTH = 200
local SCREEN_HEIGHT = 130
local TEXT_COLOR = Color(94, 255, 62)
local CONSOLE_LINES = {
    "c:\\system\\notporn>cd..",
    "c:\\system\\>cd tools",
    "c:\\system\\tools>codebreak.exe",
    "",
    ">Bruteforce attack initialized...",
}

if (CLIENT) then
    surface.CreateFont("gRust.HackingComputerText", {
        font = "Roboto Condensed Bold",
        size = 16,
        weight = 2000,
        antialias = true,
        shadow = false,
    })

    surface.CreateFont("gRust.HackingComputerTime", {
        font = "Roboto Condensed Bold",
        size = 32,
        weight = 2000,
        antialias = true,
        shadow = false,
    })
    
    function ENT:Draw()
        self:DrawModel()
    
        cam.Start3D2D(self:LocalToWorld(SCREEN_POS), self:LocalToWorldAngles(SCREEN_ANG), 0.1)
            surface.SetDrawColor(0, 0, 0, 240)
            surface.DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    
            surface.SetTextColor(TEXT_COLOR)
            surface.SetFont("gRust.HackingComputerText")
            local _, th = surface.GetTextSize("I")
            local yPos = 6
            for i = 1, #CONSOLE_LINES do
                local line = CONSOLE_LINES[i]
                surface.SetTextPos(6, yPos)
                surface.DrawText(line)
                yPos = yPos + th
            end
    
            surface.SetFont("gRust.HackingComputerTime")
            local text = string.FormattedTime(math.max(self:GetFinishTime() - CurTime(), 0), "%02i:%02i")
            surface.SetTextPos(6, yPos)
            surface.DrawText(text)
        cam.End3D2D()
    end
end