local INTRO_ANIM_TIME = 0.65
local PANEL_COLOR = Color(33, 33, 33)
local SKULL_COLOR = Color(29, 29, 29)
local TEXT_COLOR = Color(99, 99, 99)
local STAT_FONT = "gRust.32px"
local STAT_COLOR = Color(255, 255, 255, 125)
local STAT_TITLE_FONT = "gRust.24px"
local STAT_TEXT_COLOR = Color(167, 159, 152)
local BAG_COLORS = {
    Color(146, 62, 48),
    Color(75, 91, 47),
    Color(65, 115, 155)
}

local BAG_ITEMS = {
    ["rust_sleepingbag"] = "sleeping_bag",
    ["rust_bed"] = "bed",
}

local function ShowDeathScreen(timeAlive, killedBy, killedItemIndex, distance)
    if (IsValid(gRust.DeathScreen)) then return end
    
    local pl = LocalPlayer()

    local register = gRust.GetItemRegisterFromIndex(killedItemIndex)
    local killedItem = register and register:GetName() or "Unknown"

    if (timeAlive >= 3600) then
        timeAlive = string.FormattedTime(timeAlive, "%02ih%02im%02is")
    elseif (timeAlive >= 60) then
        timeAlive = string.FormattedTime(timeAlive, "%02im%02is")
    else
        timeAlive = string.format("%is", timeAlive)
    end
    
    local killedByStr = "Unknown"
    if (IsValid(killedBy)) then
        killedByStr = killedBy:Nick()
    end

    local distanceStr = string.format("%.1fm", distance * UNITS_TO_METERS)

    local DeathScreen = vgui.Create("Panel")
    DeathScreen:Dock(FILL)
    DeathScreen:MakePopup()
    
    local PanelHeight = 200 * gRust.Hud.Scaling

    local TopPanel = DeathScreen:Add("Panel")
    TopPanel:Dock(TOP)
    TopPanel:SetPos(0, 0)
    TopPanel:SetSize(ScrW(), PanelHeight)
    TopPanel:SetAlpha(0)
    TopPanel:AlphaTo(255, INTRO_ANIM_TIME, 1)
    TopPanel.Paint = function(me, w, h)
        gRust.DrawPanelColored(0, 0, w, h, PANEL_COLOR)
        
        local x = 250 * gRust.Hud.Scaling
        local y = h * 0.5
        local iconSize = h * 3.25
        local iconPadding = -50 * gRust.Hud.Scaling
        surface.SetDrawColor(SKULL_COLOR)
        surface.SetMaterial(gRust.GetIcon("skull"))
        surface.DrawTexturedRectRotated(x, y, iconSize, iconSize, 15)

        draw.SimpleText("DEAD", "gRust.92px", x, y, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local infoSpacing = 16 * gRust.Hud.Scaling
    local infoHeight = 60 * gRust.Hud.Scaling

    local infoX = (ScrW() * 0.5) + infoSpacing
    local infoY = PanelHeight * 0.5

    local InfoContainer = TopPanel:Add("Panel")
    InfoContainer:SetPos(0, 0)
    InfoContainer:SetSize(ScrW(), PanelHeight)

    local animateInTime = 1.2
    local function AnimateInInfo(panel, delay)
        local localPosX, localPosY = panel:LocalToScreen(0, 0)
        local initialY = -localPosY - infoHeight
        panel:SetY(initialY)
        panel.AnimStart = CurTime() + delay
        panel.Think = function(me)
            local animTime = CurTime() - me.AnimStart
            local toY = PanelHeight * 0.5 - infoHeight * 0.5
            if (animTime >= animateInTime) then
                me:SetY(toY)
                me.Think = nil
                return
            end

            local animProgress = animTime / animateInTime
            local anim = gRust.Anim.InSineBounce(math.Clamp(animProgress, 0, 1))
            local animY = initialY + (toY - initialY) * anim
            me:SetY(animY)
        end
    end
    
    local AliveForStat = InfoContainer:Add("Panel")
    surface.SetFont(STAT_FONT)
    local aliveForW, aliveForH = surface.GetTextSize(timeAlive)
    AliveForStat:SetSize(aliveForW + 64 * gRust.Hud.Scaling, infoHeight)
    local AliveForColor = Color(91, 113, 55)
    local AliveForTextColor = Color(205, 249, 123)
    AliveForStat:NoClipping(true)
    AliveForStat.Paint = function(me, w, h)
        surface.SetDrawColor(AliveForColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(timeAlive, STAT_FONT, w * 0.5, h * 0.5, AliveForTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("ALIVE FOR", STAT_TITLE_FONT, 0, - 8 * gRust.Hud.Scaling, STAT_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    AnimateInInfo(AliveForStat, 2)

    local killedByW, killedByH = surface.GetTextSize(killedByStr)
    local KilledByStatContainer = InfoContainer:Add("Panel")
    KilledByStatContainer:SetSize((killedByW + 64 * gRust.Hud.Scaling) + infoHeight, infoHeight)
    KilledByStatContainer:NoClipping(true)
    local KilledByColor = gRust.Colors.Primary
    KilledByStatContainer.Paint = function(me, w, h)
        surface.SetDrawColor(KilledByColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("KILLED BY", STAT_TITLE_FONT, 0, - 8 * gRust.Hud.Scaling, STAT_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    AnimateInInfo(KilledByStatContainer, 2.5)

    local KilledByStat = KilledByStatContainer:Add("Panel")
    KilledByStat:Dock(FILL)
    surface.SetFont(STAT_FONT)
    local KilledByTextColor = Color(255, 165, 148)
    KilledByStat:NoClipping(true)
    KilledByStat.Paint = function(me, w, h)
        draw.SimpleText(killedByStr, STAT_FONT, w * 0.5, h * 0.5, KilledByTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local KilledByAvatar = KilledByStatContainer:Add("AvatarImage")
    KilledByAvatar:Dock(LEFT)
    KilledByAvatar:SetWide(infoHeight)
    KilledByAvatar:SetPlayer(killedBy, 128)

    local KilledByItemStat = InfoContainer:Add("Panel")
    local DistanceStat = InfoContainer:Add("Panel")

    if (pl != killedBy) then
        if (register) then
            surface.SetFont(STAT_FONT)
            local killedByItemW, killedByItemH = surface.GetTextSize(register:GetName())
            KilledByItemStat:SetSize((killedByItemW + 64 * gRust.Hud.Scaling) + infoHeight, infoHeight)
            KilledByItemStat:NoClipping(true)
            local KilledByColor = gRust.Colors.Primary
            KilledByItemStat.Paint = function(me, w, h)
                surface.SetDrawColor(KilledByColor)
                surface.DrawRect(0, 0, w, h)
    
                draw.SimpleText("WITH A", STAT_TITLE_FONT, 0, - 8 * gRust.Hud.Scaling, STAT_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            end
    
            AnimateInInfo(KilledByItemStat, 3)
            
            local KilledByStat = KilledByItemStat:Add("Panel")
            KilledByStat:Dock(FILL)
            surface.SetFont(STAT_FONT)
            local KilledByTextColor = Color(255, 165, 148)
            KilledByStat:NoClipping(true)
            KilledByStat.Paint = function(me, w, h)
                draw.SimpleText(register:GetName(), STAT_FONT, w * 0.5, h * 0.5, KilledByTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
    
            local KilledByItemIcon = KilledByItemStat:Add("Panel")
            KilledByItemIcon:Dock(LEFT)
            KilledByItemIcon:SetWide(infoHeight)
            KilledByItemIcon:NoClipping(true)
            local extraSize = 16 * gRust.Hud.Scaling
            KilledByItemIcon.Paint = function(me, w, h)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(register:GetIcon())
                surface.DrawTexturedRect(-extraSize, -extraSize, w + extraSize * 2, h + extraSize * 2)
            end
        end

        surface.SetFont(STAT_FONT)
        local distanceW, distanceH = surface.GetTextSize(distanceStr)
        DistanceStat:SetSize(distanceW + 128 * gRust.Hud.Scaling, infoHeight)
        local DistanceColor = Color(74, 73, 69)
        local DistanceTextColor = Color(133, 132, 130)
        DistanceStat:NoClipping(true)
        DistanceStat.Paint = function(me, w, h)
            surface.SetDrawColor(DistanceColor)
            surface.DrawRect(0, 0, w, h)
    
            draw.SimpleText(distanceStr, STAT_FONT, w * 0.5, h * 0.5, DistanceTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("AT A DISTANCE OF", STAT_TITLE_FONT, 0, - 8 * gRust.Hud.Scaling, STAT_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    
        AnimateInInfo(DistanceStat, 3.5)
    else
        
    end

    InfoContainer.PerformLayout = function(me, w, h)
        local paddingBetween = 64 * gRust.Hud.Scaling
        local totalWidth = AliveForStat:GetWide() + KilledByStatContainer:GetWide() + KilledByItemStat:GetWide() + DistanceStat:GetWide() + paddingBetween * 3
        local padding = (w - totalWidth - paddingBetween) * 0.5
        AliveForStat:SetX(padding)
        KilledByStatContainer:SetX(AliveForStat:GetWide() + padding + paddingBetween)
        KilledByItemStat:SetX(KilledByStatContainer:GetWide() + KilledByStatContainer.x + paddingBetween)
        DistanceStat:SetX(KilledByItemStat:GetWide() + KilledByItemStat.x + paddingBetween)
    end
    
    local BottomPanel = DeathScreen:Add("Panel")
    BottomPanel:Dock(BOTTOM)
    BottomPanel:SetPos(0, -170 * gRust.Hud.Scaling)
    BottomPanel:SetSize(ScrW(), 170 * gRust.Hud.Scaling)
    BottomPanel:SetAlpha(0)
    BottomPanel:AlphaTo(255, INTRO_ANIM_TIME, 2)
    local padding = 32 * gRust.Hud.Scaling
    BottomPanel:DockPadding(padding, padding, padding, padding)
    BottomPanel.Paint = function(me, w, h)
        gRust.DrawPanelColored(0, 0, w, h, PANEL_COLOR)
    end

    local RespawnButton = BottomPanel:Add("gRust.Button")
    RespawnButton:Dock(RIGHT)
    RespawnButton:SetWide(320 * gRust.Hud.Scaling)
    RespawnButton:DockMargin(0, 0, 98 * gRust.Hud.Scaling, 0)
    RespawnButton:SetFont("gRust.58px")
    RespawnButton:SetText("RESPAWN >>")
    RespawnButton:SetTextColor(Color(146, 188, 73))
    RespawnButton:SetDefaultColor(Color(58, 64, 41))
    RespawnButton:SetHoveredColor(Color(74, 81, 52))
    RespawnButton:SetSelectedColor(Color(88, 96, 62))
    RespawnButton.DoClick = function(me)
        net.Start("gRust.Respawn")
        net.SendToServer()

        DeathScreen:Remove()
    end

    local CircleRadius = 38 * gRust.Hud.Scaling
    local CircleThickness = 4

    local BagCircle = gRust.CreateCircle()
    BagCircle:SetColor(gRust.Colors.Primary)
    BagCircle:SetFilled(true)
    BagCircle:SetCenter(ScrW() * 0.5, ScrH() * 0.5)
    BagCircle:SetRadius(CircleRadius - CircleThickness)
    --BagCircle:SetThickness(170 * gRust.Hud.Scaling)

    local BagOutlineCircle = gRust.CreateCircle()
    BagOutlineCircle:SetColor(gRust.Colors.Primary)
    BagOutlineCircle:SetFilled(false)
    BagOutlineCircle:SetCenter(ScrW() * 0.5, ScrH() * 0.5)
    BagOutlineCircle:SetRadius(CircleRadius)
    BagOutlineCircle:SetThickness(CircleThickness)

    for k, v in ipairs(pl:GetSleepingBags()) do
        local SleepingBagButton = BottomPanel:Add("gRust.Button")
        SleepingBagButton:Dock(LEFT)
        SleepingBagButton:SetWide(320 * gRust.Hud.Scaling)
        SleepingBagButton:DockMargin(0, 0, 15 * gRust.Hud.Scaling, 0)
        SleepingBagButton:SetFont("gRust.58px")
        SleepingBagButton:SetText(string.upper(v:GetBagName()))
        SleepingBagButton:SetTextColor(Color(251, 240, 230))
        local BagColor = BAG_COLORS[(k - 1) % #BAG_COLORS + 1]
        SleepingBagButton:SetDefaultColor(BagColor)
        SleepingBagButton:SetHoveredColor(Color(BagColor.r + 10, BagColor.g + 10, BagColor.b + 10))
        SleepingBagButton:SetSelectedColor(Color(BagColor.r + 20, BagColor.g + 20, BagColor.b + 20))
        SleepingBagButton:NoClipping(true)
        local BagIcon = gRust.GetItemRegister(BAG_ITEMS[v:GetClass()]):GetIcon() or gRust.GetItemRegister("sleeping_bag"):GetIcon()
        local LockIcon = gRust.GetIcon("lock")
        SleepingBagButton.Paint = function(me, w, h)
            local canRespawn = ((v:GetRespawnTime() + v.BagSpawnTime) - CurTime()) <= 0
            local col = canRespawn and me:GetColor() or Color(25, 25, 25)
            gRust.DrawPanelColored(CircleRadius, 0, w - CircleRadius, h, col)
            draw.SimpleText(string.Cap(me:GetText(), 13), "gRust.36px", CircleRadius * 2 + 12 * gRust.Hud.Scaling, h * 0.5, canRespawn and Color(250, 237, 228) or Color(35, 35, 35), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            BagCircle:SetCenter(CircleRadius, h * 0.5)
            BagCircle:SetColor(Color(col.r - 10, col.g - 10, col.b - 10))
            BagCircle:Draw()

            local iconSize = (canRespawn and 54 or 40) * gRust.Hud.Scaling
            surface.SetDrawColor(canRespawn and color_white or Color(35, 35, 35))
            surface.SetMaterial(canRespawn and BagIcon or LockIcon)
            surface.DrawTexturedRect(CircleRadius - iconSize * 0.5, h * 0.5 - iconSize * 0.5, iconSize, iconSize)

            BagOutlineCircle:SetCenter(CircleRadius, h * 0.5)
            BagOutlineCircle:SetColor(Color(col.r + 35, col.g + 35, col.b + 35))
            BagOutlineCircle:Draw()

            if (!canRespawn) then
                draw.SimpleText(math.ceil((v:GetRespawnTime() + v.BagSpawnTime) - CurTime()), "gRust.42px", CircleRadius + (w - CircleRadius) * 0.5, h * 0.5, Color(199, 196, 196) or Color(40, 40, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        SleepingBagButton.DoClick = function(me)
            if (((v:GetRespawnTime() + v.BagSpawnTime) - CurTime()) > 0) then return end

            net.Start("gRust.BagRespawn")
            net.WriteUInt(k, 8)
            net.SendToServer()

            DeathScreen:Remove()
        end
    end

    gRust.DeathScreen = DeathScreen
end

net.Receive("gRust.PlayerDeathScreen", function(len)
    local aliveFor = net.ReadFloat()
    local killedBy = net.ReadEntity()
    local withA = net.ReadUInt(gRust.ItemIndexBits)
    local distance = net.ReadFloat()

    if (!IsValid(killedBy) or !killedBy:IsPlayer()) then
        killedBy = LocalPlayer()
    end

    gRust.DeathPos = LocalPlayer():GetPos()

    ShowDeathScreen(aliveFor, killedBy, withA, distance)
end)

local view = {}
hook.Add("CalcView", "gRust.FPSDeath", function(pl, origin, angles, fov, znear, zfar)
    if (pl:Alive()) then return end
    
    local ragdoll = pl:GetRagdollEntity()
    if (!IsValid(ragdoll)) then return end
    
    local eyes = ragdoll:LookupAttachment("eyes")
    if (!eyes) then return end
    eyes = ragdoll:GetAttachment(eyes)
    if (!eyes) then return end

    view.origin = eyes.Pos - eyes.Ang:Forward() * 1.25
    view.angles = eyes.Ang
    view.fov = fov

    return view
end)