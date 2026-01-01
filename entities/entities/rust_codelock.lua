AddCSLuaFile()

ENT.Base = "rust_base"

ENT.Deploy = gRust.CreateDeployable()
    :SetModel("models/deployable/keypad.mdl")
    :SetRequireSocket(true)
    :SetInitialRotation(0)
    :SetCenter(Vector(0, 0, 46))
    :SetRotate(0)
    :SetSound("doors/keypad_deploy.wav")
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 0, 0)
            :SetAngle(0, 0, 0)
            :AddMaleTag("lock")
    )
    :SetOnDeployed(function(self, pl, ent, item)
        if (ent.LockBodygroup and !ent.LockData) then
            ent:AddLock("code_lock")
            ent:AuthorizeToLock(pl)
            ent:Unlock()
            ent.LockItem = item
        end

        self:Remove()
    end)