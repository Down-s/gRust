SWEP.Base = "rust_swep"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_hammer.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_hammer.mdl"

SWEP.ViewModelPos = Vector(-1, 3, 0.5)
SWEP.UpgradeRange = 1.75
SWEP.Range = 1.5
SWEP.AttackDelay = 0.35
SWEP.Hammer = true

SWEP.UpgradeLevels = {
    {
        Name = "Wood",
        Description = [[Wood is a medium strength building material but vulnerable to fire]],
        CostMultiplier = 4,
        ModelPrefix = "wood",
        Icon = "level_wood",
        Item = "wood",
        Sound = "hammer_saw",
        Health = 250,
    },
    {
        Name = "Stone",
        Description = [[A strong material. Impervious to fire and melee damage.]],
        CostMultiplier = 6,
        ModelPrefix = "stone",
        Icon = "level_stone",
        Item = "stones",
        Sound = "rust_stone",
        Health = 500,
    },
    {
        Name = "Sheet Metal",
        Description = [[Sheet metal is twice as strong as stone]],
        CostMultiplier = 4,
        ModelPrefix = "metal",
        Icon = "level_metal",
        Item = "metal_fragments",
        Sound = "rust_metal",
        Health = 1000,
    },
    {
        Name = "Armored",
        Description = [[Strongest class of material, 4x as strong as stone.]],
        CostMultiplier = 0.5,
        ModelPrefix = "hq",
        Icon = "level_top",
        Item = "hq_metal",
        Sound = "rust_metal",
        Health = 2000,
    }
}

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextAttack")
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DEPLOY)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextAttack(0)

    return true
end

function SWEP:PrimaryAttack()
    if (!IsValid(self:GetItem())) then return end
    
    local pl = self:GetOwner()
    local tr = self:TraceRange()
    
    if (tr.Hit) then
        self:SendWeaponAnim(ACT_VM_SWINGHIT)
        self:SetNextAttack(CurTime() + self.AttackDelay)

        if (SERVER) then
            local ent = tr.Entity
            timer.Simple(0.35, function()
                if (!IsValid(self)) then return end
                if (IsValid(ent) and ent.gRust) then
                    if (!ent.Upkeep) then return end
                    if (!IsValid(pl)) then return end
                    
                    local repairAmount = math.min(ent:GetMaxHP() - ent:GetHP(), ent:GetMaxHP() / 3)
                    local repairPercentage = repairAmount / (ent:GetMaxHP() / 3)
                    if (repairAmount < 1) then return end
    
                    for k, v in ipairs(ent.Upkeep) do
                        if (!pl:HasItem(v.Item, math.ceil(v.Amount * repairPercentage))) then return end
                    end
        
                    for k, v in ipairs(ent.Upkeep) do
                        pl:RemoveItem(v.Item, math.ceil(v.Amount * repairPercentage), ITEM_HARVEST)
                    end
    
                    ent:SetHP(ent:GetHP() + repairAmount)
                end
            end)
        end
    else
        self:SendWeaponAnim(ACT_VM_SWINGMISS)
    end

    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound("weapons/rust/hammer-attack.wav")
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:OnHit()
    local tr = self:TraceRange()
    if (!tr.Hit) then return end
    local pl = self:GetOwner()
    
    self:EmitSound("weapons/rust/hammer-strike.wav")

    local ent = tr.Entity
end

function SWEP:Think()
    local nextAttack = self:GetNextAttack()
    if (nextAttack != 0 and self:GetNextAttack() <= CurTime()) then
        self:OnHit()

        self:SetNextAttack(0)
    end
end
