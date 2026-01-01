AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

ENT.Models = {
    "models/darky_m/rust/junkpiles/a.mdl",
    "models/darky_m/rust/junkpiles/b.mdl",
    "models/darky_m/rust/junkpiles/c.mdl",
    "models/darky_m/rust/junkpiles/d.mdl",
    "models/darky_m/rust/junkpiles/e.mdl",
    "models/darky_m/rust/junkpiles/f.mdl",
    "models/darky_m/rust/junkpiles/g.mdl"
}

function ENT:Initialize()
    self:SetRespawn(true)

    local mdl = self.Models[math.random(#self.Models)]
    self:SetModel(mdl)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    timer.Simple(0, function()
        local class = math.random(1, 2) == 1 and "rust_crate" or "rust_toolbox"

        local attachment = self:GetAttachment(1)
        
        if (attachment) then
            local crate = ents.Create(class)
            if (IsValid(crate)) then
                crate:SetPos(attachment.Pos)
                crate:SetAngles(attachment.Ang)
                crate:Spawn()
                crate:SetParent(self)
                crate:SetRespawn(false)
            end
        end

        for i = 2, 4 do
            local attachment = self:GetAttachment(i)

            if (attachment) then
                local barrel = ents.Create(math.random(1, 2) == 1 and "rust_barrel" or "rust_oilbarrel")
                if (IsValid(barrel)) then
                    barrel:SetPos(attachment.Pos)
                    barrel:SetAngles(attachment.Ang)
                    barrel:Spawn()
                    barrel:SetParent(self)
                    barrel:SetRespawn(false)
                end
            end
        end
    end)
end

function ENT:Think()
    if (#self:GetChildren() == 0) then
        self:CreateRespawn()
        self:Remove()
    end

    self:NextThink(CurTime() + 200)
    return true
end