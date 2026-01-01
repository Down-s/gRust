local SAVE_DIR = "grust/saves/"

file.CreateDir(SAVE_DIR)
file.CreateDir(SAVE_DIR .. "backups")

gRust.CreateConfigValue("server/save.interval", 120)
local SAVE_INTERVAL = gRust.GetConfigValue("server/save.interval")

gRust.CreateConfigValue("server/backup.max", 30)
local MAX_BACKUPS = gRust.GetConfigValue("server/backup.max")

gRust.CreateConfigValue("server/backup.interval", 1200)
local BACKUP_INTERVAL = gRust.GetConfigValue("server/backup.interval")

function gRust.Save(filename)
    local saveFile = SAVE_DIR .. filename
    if (!file.Exists(saveFile, "DATA")) then
        file.Write(saveFile, "")
    end

    local f = file.Open(saveFile, "wb", "DATA")

    local entCount = 0

    for _, ent in ents.Iterator() do
        if (!ent.ShouldSave) then continue end
        if (!ent.Save) then continue end
        if (ent:CreatedByMap()) then continue end

        f:WriteUShort(string.len(ent:GetClass()))
        f:Write(ent:GetClass())
        ent:Save(f)

        entCount = entCount + 1
    end

    f:Close()

    gRust.LogSuccess(string.format("Saved %i entities", entCount))
end

function gRust.Load(filename)
    local saveFile = SAVE_DIR .. filename
    if (!file.Exists(saveFile, "DATA")) then return end

    local entCount = 0

    local f = file.Open(saveFile, "rb", "DATA")
    while (!f:EndOfFile()) do
        local class = f:ReadString()
        local ent = ents.Create(class)
        
        if (!IsValid(ent)) then
            error("Attempted to create invalid entity class " .. class)
            continue
        end

        ent:Spawn()
        ent:Load(f)

        entCount = entCount + 1
    end

    f:Close()

    gRust.LogSuccess(string.format("Loaded %i entities", entCount))
end

function gRust.ClearSave(filename)
    local saveFile = SAVE_DIR .. filename
    if (file.Exists(saveFile, "DATA")) then
        file.Delete(saveFile)
    end
end

function gRust.AutoSave()
    gRust.Save("autosave.dat")
end

timer.Create("gRust.Save", SAVE_INTERVAL, 0, function()
    if (gRust.Wiping) then return end

    -- Server save is fast enough to not need a message
    -- PrintMessage(HUD_PRINTTALK, "Server Saving...")
    
    gRust.Save("autosave.dat")

    gRust.LastBackup = gRust.LastBackup or CurTime()
    if (gRust.LastBackup + BACKUP_INTERVAL < CurTime()) then
        gRust.LastBackup = CurTime()

        local f = file.Read(SAVE_DIR .. "autosave.dat", "DATA")
        local backupFile = SAVE_DIR .. "backups/autosave_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".dat"
        file.Write(backupFile, f)

        local files = file.Find(SAVE_DIR .. "backups/*.dat", "DATA")
        if (#files > MAX_BACKUPS) then
            table.sort(files, function(a, b)
                return a < b
            end)

            file.Delete(SAVE_DIR .. "backups/" .. files[1])
        end
    end
end)

hook.Add("InitPostEntity", "gRust.Load", function()
    gRust.Load("autosave.dat")
end)

hook.Add("gRust.Wipe", "gRust.ClearAutoSave", function()
    gRust.ClearSave("autosave.dat")
end)

concommand.Add("grust_save", function(pl, cmd, args)
    if (IsValid(pl) and !pl:IsSuperAdmin()) then return end
    gRust.Save(args[1] or "manualsave.dat")
end)

concommand.Add("grust_load", function(pl, cmd, args)
    if (IsValid(pl) and !pl:IsSuperAdmin()) then return end

    for _, ent in ents.Iterator() do
        if (ent.ShouldSave and !ent:CreatedByMap()) then
            ent:Remove()
        end
    end

    gRust.Load(args[1] or "manualsave.dat")
end)