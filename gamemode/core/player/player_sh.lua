function GM:Move(pl, mv)
    if (!pl:CanSprint()) then
        mv:SetMaxClientSpeed(pl:GetWalkSpeed())
    end

    if (mv:KeyPressed(IN_JUMP) && pl:IsOnGround()) then
        pl:ViewPunch(Angle(-3, 0, 0))
        mv:SetVelocity(mv:GetVelocity() * 0.8)
    end
end

local PLAYER = FindMetaTable("Player")
function PLAYER:CanSprint()
    if ((self.SprintHaltEnd or 0) > CurTime()) then return false end
    if (self:KeyDown(IN_BACK) or self:KeyDown(IN_MOVERIGHT) or self:KeyDown(IN_MOVELEFT)) then return false end
    if (self:GetRadiation() >= 100) then return false end
    if (self:GetHydration() <= 0) then return false end

    return true
end

function PLAYER:IsSprinting()
    return self:KeyDown(IN_SPEED) and self:CanSprint() and not self:Crouching()
end

function PLAYER:HaltSprint(time)
    self.SprintHaltEnd = self.SprintHaltEnd or 0
	self.SprintHaltEnd = math.max(self.SprintHaltEnd, CurTime() + time)
end

--
-- Player Methods
--

PLAYER.gRust = true

function PLAYER:Health()
    return self:GetSyncVar("Health", 100)
end

function PLAYER:GetHP()
    return self:Health()
end

function PLAYER:GetMaxHP()
    return self:GetMaxHealth()
end

function PLAYER:OnReady()
    self.NetworkReady = true

    if (SERVER) then
        self.Belt:SyncAll()
        self.Inventory:SyncAll()
        self.Attire:SyncAll()
    end
end

function PLAYER:IsNetworkReady()
    return self.NetworkReady
end

function PLAYER:OnInventoryAttached(inventory)
    if (inventory:GetSize() == 6) then
        self.Belt = inventory
        hook.Run("OnPlayerBeltAttached", self, inventory)

        self.Belt.OnUpdated = function(belt)
            hook.Run("OnPlayerBeltUpdated", self)
        end
    elseif (inventory:GetSize() == 7) then
        self.Attire = inventory
        hook.Run("OnPlayerAttireAttached", self, inventory)

        self.Attire.CanAcceptItem = function(inv, item, other)
            if (inv == other) then return true end
            return hook.Run("CanPlayerWearAttire", self, item) != false
        end

        self.Attire.OnUpdated = function(attire)
            hook.Run("OnPlayerAttireUpdated", self)
        end
    else
        self.Inventory = inventory
        hook.Run("OnPlayerInventoryAttached", self, inventory)

        self.Inventory.OnUpdated = function(inventory)
            hook.Run("OnPlayerInventoryUpdated", self)
        end
    end
end

function PLAYER:ItemCount(item)
    local count = 0

    if (self.Belt) then
        count = count + self.Belt:ItemCount(item)
    end

    if (self.Inventory) then
        count = count + self.Inventory:ItemCount(item)
    end

    if (self.Attire) then
        count = count + self.Attire:ItemCount(item)
    end

    return count
end

function PLAYER:HasItem(item, amount)
    return self:ItemCount(item) >= (amount or 1)
end

function PLAYER:ChatPrint(...)
    if (SERVER) then
        self:ChatMessage(color_white, ...)
    else
        chat.AddText(color_white, ...)
    end
end