AddCSLuaFile()

SWEP.Base = "rust_melee"
SWEP.Author = "Down"

SWEP.Damage         = 60
SWEP.AttackRate     = 30
SWEP.AttackSize     = 0.4
SWEP.AttackDelay    = 0.5
SWEP.Range          = 1.3
SWEP.OreGather      = 0
SWEP.TreeGather     = 0
SWEP.FleshGather    = 0

SWEP.HoldType       = "melee2"

SWEP.PrimaryAttacks = {
    {
        StartAct = ACT_VM_MISSLEFT,
        EndAct = ACT_VM_HITLEFT,
    },
    {
        StartAct = ACT_VM_MISSCENTER,
        EndAct = ACT_VM_HITCENTER,
    },
    {
        StartAct = ACT_VM_MISSRIGHT,
        EndAct = ACT_VM_HITRIGHT,
    }
}

SWEP.ViewModel = "models/weapons/darky_m/rust/c_salvaged_Cleaver.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_salvaged_Cleaver.mdl"

SWEP.SwingSound = "darky_rust.2handed-cleaver-attack"
SWEP.HitSound = "darky_rust.2handed-cleaver-strike"