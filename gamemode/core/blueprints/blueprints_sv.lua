hook.Add("gRust.Loaded", "gRust.InitBlueprints", function()
    gRust.LocalQuery([[
        CREATE TABLE IF NOT EXISTS grust_blueprints(
            sid64 BIGINT NOT NULL,
            item VARCHAR(32) NOT NULL,
            PRIMARY KEY(sid64, item)
        )
    ]])

    gRust.CreateConfigValue("crafting/blueprints.enable", true, true)
end)

hook.Add("gRust.Wipe", "gRust.ClearBlueprints", function(bpWipe, scheduled)
    if (bpWipe) then
        gRust.LocalQuery("DELETE FROM grust_blueprints")
    end
end)

local PLAYER = FindMetaTable("Player")
util.AddNetworkString("gRust.BlueprintLearned")
function PLAYER:LearnBlueprint(item)
    if (self:HasBlueprint(item)) then return end
    
    self.Blueprints = self.Blueprints or {}
    self.Blueprints[item] = true

    gRust.LocalQuery(string.format("REPLACE INTO grust_blueprints(sid64, item) VALUES(%s, %s)", self:SteamID64(), sql.SQLStr(item)))
    
    net.Start("gRust.BlueprintLearned")
        net.WriteUInt(gRust.GetItemRegister(item):GetIndex(), gRust.ItemIndexBits)
    net.Send(self)

    hook.Run("gRust.BlueprintLearned", self, item)
end

util.AddNetworkString("gRust.BlueprintUnlearned")
function PLAYER:UnlearnBlueprint(item)
    self.Blueprints[item] = nil

    gRust.LocalQuery(string.format("DELETE FROM grust_blueprints WHERE sid64 = %s AND item = %s", self:SteamID64(), sql.SQLStr(item)))

    net.Start("gRust.BlueprintUnlearned")
        net.WriteUInt(gRust.GetItemRegister(item):GetIndex(), gRust.ItemIndexBits)
    net.Send(self)

    hook.Run("gRust.BlueprintUnlearned", self, item)
end

util.AddNetworkString("gRust.SyncBlueprints")
function PLAYER:SyncBlueprints()
    self.Blueprints = {}

    gRust.LocalQuery(string.format("SELECT item FROM grust_blueprints WHERE sid64 = %s", self:SteamID64()), function(data)
        if (!data or #data == 0) then return end

        for _, row in ipairs(data) do
            self.Blueprints[row.item] = true
        end

        net.Start("gRust.SyncBlueprints")
            net.WriteUInt(#data, gRust.ItemIndexBits)
            for _, row in ipairs(data) do
                local register = gRust.GetItemRegister(row.item)
                net.WriteUInt(register:GetIndex(), gRust.ItemIndexBits)
            end
        net.Send(self)
    end)
end

hook.Add("PlayerNetworkReady", "gRust.SyncBlueprints", function(pl)
    pl:SyncBlueprints()
end)