AddCSLuaFile()

ENT.Base = "rust_base"
DEFINE_BASECLASS("rust_base")

ENT.Model = "models/deployable/large_wooden_box.mdl"
ENT.Slots = 18

if (SERVER) then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetInteractable(true)
        self:SetInteractText("OPEN")
        self:SetInteractIcon("open")

        if (self.MaxHP) then
            self:SetMaxHP(self.MaxHP)
            self:SetHP(self.MaxHP)
        end
    
        self.Containers = {}
        self:CreateContainers()

        if (CLIENT) then 
            self.ExtraOptions = self:CreateExtraOptions()
        end
    end

    function ENT:IsEmpty()
        for k, v in ipairs(self.Containers) do
            if (!v:IsEmpty()) then
                return false
            end
        end

        return true
    end

    function ENT:OnRemove()
        if (self.Item and !self:IsEmpty()) then
            local ent = ents.Create("rust_stash")
            ent:SetPos(self:GetPos())
            ent:SetAngles(self:GetAngles())
            ent.Containers = {}
            for k, v in ipairs(self.Containers) do
                local inv = v:Copy()
                inv:SetEntity(ent)
            end
            ent:Spawn()
        end

        if (self.Containers) then
            for k, v in ipairs(self.Containers) do
                v:Destroy()
            end
        end
    end
end

function ENT:Think()
    BaseClass.Think(self)
end

function ENT:OnStartLooting(pl)
    if (CLIENT) then
        gRust.PlaySound("box.open")
    end
end

function ENT:OnStopLooting(pl)
    if (CLIENT) then
        gRust.PlaySound("box.close")
    end
end

function ENT:Interact(pl)
    if (CLIENT) then return end
    
    if (!self:IsAuthorizedToLock(pl) and self:IsLocked() and self.LockData and self.LockData.Item == "code_lock") then
        self:EmitSound("codelock.beep")
        return
    end

    gRust.StartLooting(pl, self)
end

function ENT:IsLootable()
    return #self.Containers > 0
end

function ENT:CreateContainers()
    local main = gRust.CreateInventory(self.Slots)
    main:SetEntity(self)
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    self.Containers[1] = inv

    inv.OnUpdated = function(me)
        if (!IsValid(self)) then return end
        self:OnInventoryUpdated(me)
    end
end

function ENT:OnInventoryUpdated()
end

function ENT:CreateLootingPanel(panel)
    local containers = self.Containers
    
    for i = #containers, 1, -1 do
        local v = containers[i]
        local inventory = panel:Add("gRust.Inventory")
        inventory:SetInventory(v)
        inventory:SetName(v:GetName())
        inventory:Dock(BOTTOM)
        inventory:DockMargin(0, i == 1 and 0 or 20 * gRust.Hud.Scaling, 0, 0)
    end
end

function ENT:HasItem(item, quantity)
    quantity = quantity or 1
    
    local amount = 0
    for k, v in ipairs(self.Containers) do
        amount = amount + v:ItemCount(item)

        if (amount >= quantity) then
            return true
        end
    end

    return false
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)

    local len = self.Containers and #self.Containers or 0
    buffer:WriteByte(len)
    
    for i = 1, len do
        local v = self.Containers[i]
        buffer:WriteByte(v:GetSlots())
        for j = 1, v:GetSlots() do
            buffer:WriteItem(v[j])
        end
    end

    buffer:WriteItem(self.Item)
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)

    local containers = {}
    local count = buffer:ReadByte()
    for i = 1, count do
        local slots = buffer:ReadByte()
        local inv = {}
        for j = 1, slots do
            inv[j] = buffer:ReadItem()
        end
        containers[i] = inv
        containers[i].Slots = slots
    end

    self.Item = buffer:ReadItem()

    timer.Simple(0, function()
        for i = 1, #containers do
            local inv = containers[i]
            local container = self.Containers[i]
            for j = 1, inv.Slots do
                container[j] = inv[j]
            end
        end
    end)
end