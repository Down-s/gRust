hook.Add("KeyPress", "gRust.InteractSystem", function(pl, key)
    if (key == IN_USE) then
        pl.InteractStart = CurTime()
    end
end)

local tr = {mins = Vector(-6, -6, -6), maxs = Vector(6, 6, 6)}
hook.Add("KeyRelease", "gRust.InteractSystem", function(pl, key)
    if (key == IN_USE) then
        if (!pl.InteractStart) then return end
        if (CurTime() - pl.InteractStart > 0.2) then return end
        if (pl.NextInteract and pl.NextInteract > CurTime()) then return end
        pl.NextInteract = CurTime() + 0.2
        
        pl:LagCompensation(true)
        tr.start = pl:GetShootPos()
        tr.endpos = tr.start + pl:GetAimVector() * 96
        tr.filter = pl
        local trace = util.TraceHull(tr)
        pl:LagCompensation(false)
        
        local ent = trace.Entity
        if (!IsValid(ent)) then return end
        
        if (ent.Interact and ent:GetInteractable() and IsFirstTimePredicted()) then
            ent:Interact(pl)
        end
    end
end)

local function CanPlayerInteract(pl, ent)
    if (ent:GetPos():DistToSqr(pl:GetPos()) > 20000) then return false end
    if (util.TraceLine({
        start = pl:EyePos(),
        endpos = ent:LocalToWorld(ent:OBBCenter()),
        filter = pl
    }).Entity != ent) then return false end

    return true
end

if (CLIENT) then
    local PLAYER = FindMetaTable("Player")
    function PLAYER:RequestInteract(ent)
        if (!IsValid(ent)) then return end
        if (!ent.Interact) then return end
        if (!ent:GetInteractable()) then return end
        if (!CanPlayerInteract(self, ent)) then return end
    
        ent:Interact(self)
        
        net.Start("gRust.Interact")
            net.WriteEntity(ent)
        net.SendToServer()
    end
else
    util.AddNetworkString("gRust.Interact")
    net.Receive("gRust.Interact", function(len, pl)
        local ent = net.ReadEntity()
        if (!IsValid(ent)) then return end
        if (!ent.Interact) then return end
        if (!ent:GetInteractable()) then return end
        if (!CanPlayerInteract(pl, ent)) then return end
    
        ent:Interact(pl)
    end)
end

local function GetInteractData(ent)
    local data = {}
    if (ent:GetInteractable()) then
        data.Text = ent:GetInteractText()
        data.Icon = ent:GetInteractIcon()
    end
    
    data.HP = ent:GetHP()
    data.MaxHP = ent:GetMaxHP()

    return data
end

if (CLIENT) then
    local InteractData
    local Alpha = 0
    local CROSSHAIR_COLOR = gRust.Colors.Text
    local MAX_HEALTH_COLOR = Color(115, 136, 71)
    local TEXT_COLOR = Color(255, 255, 255, 255)
    local LastEnt

    local function EntityHud(ent)
        local mAlpha = 0
        local holdingHammer = LocalPlayer():GetActiveWeapon().Hammer

        if (IsValid(ent) and ent.gRust and (ent:GetInteractable() or ((ent:GetHP() / ent:GetMaxHP()) < 0.95) or holdingHammer) and !gRust.InteractMenu) then
            InteractData = GetInteractData(ent)
            Alpha = Lerp(FrameTime() / 0.1, Alpha, 1)
            mAlpha = math.ease.OutCirc(Alpha)
        else
            Alpha = Lerp(FrameTime() / 0.1, Alpha, 0)
            mAlpha = math.ease.InCirc(Alpha)
        end
        
        if (Alpha == 0) then return end
        if (!InteractData) then return end

        surface.SetAlphaMultiplier(mAlpha)

        local scrw, scrh = ScrW(), ScrH()
        local crosshairSize = 8 * gRust.Hud.Scaling
        surface.SetDrawColor(CROSSHAIR_COLOR)
        surface.SetMaterial(gRust.GetIcon("circle"))
        surface.DrawTexturedRect(scrw * 0.5 - crosshairSize, scrh * 0.5 - crosshairSize, crosshairSize * 2, crosshairSize * 2)
        
        if (InteractData.Text and InteractData.Text != "") then
            draw.SimpleText(InteractData.Text, "gRust.32px", scrw * 0.5, scrh * 0.5 - 52 * gRust.Hud.Scaling, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if (InteractData.Icon and InteractData.Icon != "") then
            local IconSize = 50 * gRust.Hud.Scaling
            surface.SetDrawColor(TEXT_COLOR)
            surface.SetMaterial(gRust.GetIcon(InteractData.Icon))
            surface.DrawTexturedRect(scrw * 0.5 - IconSize * 0.5, scrh * 0.5 - IconSize * 0.5 - 94 * gRust.Hud.Scaling, IconSize, IconSize)
        end

        if (InteractData.MaxHP and InteractData.MaxHP > 0) then
            local ratio = math.Clamp(InteractData.HP / InteractData.MaxHP, 0, 1)
            if (ratio < 0.95 or holdingHammer) then
                local healthWidth = 296 * gRust.Hud.Scaling
                local healthHeight = 16 * gRust.Hud.Scaling
                local healthOffset = -398 * gRust.Hud.Scaling
                local healthX = scrw * 0.5 - healthWidth * 0.5
                local healthY = scrh * 0.5 + healthOffset * gRust.Hud.Scaling
        
                surface.SetDrawColor(MAX_HEALTH_COLOR)
                surface.DrawRect(healthX, healthY, healthWidth, healthHeight)
    
                surface.SetDrawColor(TEXT_COLOR)
                surface.DrawRect(healthX, healthY, healthWidth * ratio, healthHeight)

                draw.SimpleText(math.ceil(InteractData.HP) .. " / " .. InteractData.MaxHP, "gRust.26px", scrw * 0.5 + healthWidth * 0.5, healthY, TEXT_COLOR, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            end
        end

        surface.SetAlphaMultiplier(1)
    end

    hook.Add("gRust.Loaded", "gRust.ExtraOptionsFont", function()
        surface.CreateFont("gRust.ExtraOptions", {
            font = "Roboto Condensed",
            size = 32 * gRust.Hud.Scaling,
            weight = 200,
            antialias = true
        })
    end)

    local ExtraOptionsAlpha = -2
    local UseDown = false
    local UseTime = 0
    local Using = false
    local function ExtraOptionsHud(ent)
        local pl = LocalPlayer()
        local wep = pl:GetActiveWeapon()
        if (IsValid(ent) and ent.ExtraOptions and ent:GetInteractable() and (!IsValid(wep) or wep:GetClass() != "rust_hammer")) then
            ExtraOptionsAlpha = Lerp(FrameTime() / 0.25, ExtraOptionsAlpha, 1)

            if (pl:KeyDown(IN_USE)) then
                if (!UseDown) then
                    UseDown = true
                    UseTime = CurTime() + 0.25
                    Using = false
                end

                if (UseTime < CurTime() and !Using and !vgui.CursorVisible()) then
                    ent.ExtraOptions:Open()
                    Using = true
                end
            else
                UseTime = 0
                if (UseDown) then
                    UseDown = false
                    ent.ExtraOptions:Close()
                end
            end
        else
            ExtraOptionsAlpha = Lerp(FrameTime() / 0.25, ExtraOptionsAlpha, -2)
        end

        if (ExtraOptionsAlpha <= 0) then return end

        surface.SetAlphaMultiplier(ExtraOptionsAlpha)
        
        local scrw, scrh = ScrW(), ScrH()
        local x, y = scrw * 0.5, scrh * 0.5
        local lineOffset = 32 * gRust.Hud.Scaling
        local offset = 64 * gRust.Hud.Scaling
        
        draw.SimpleText("More options are available", "gRust.ExtraOptions", x, y + offset, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Hold down [USE] to open menu", "gRust.ExtraOptions", x, y + offset + lineOffset, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("HUDPaint", "gRust.Interact", function()
        if (!gRust.Hud.ShouldDraw) then return end

        tr.start = LocalPlayer():GetShootPos()
        tr.endpos = tr.start + LocalPlayer():GetAimVector() * 96
        tr.filter = LocalPlayer()
        local trace = util.TraceHull(tr)
        local ent = trace.Entity
    
        EntityHud(ent)
        ExtraOptionsHud(ent)
    end)
end