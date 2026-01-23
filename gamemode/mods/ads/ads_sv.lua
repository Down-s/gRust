if not SERVER then return end
require("http")
util.AddNetworkString("gRust.SendChatConsole")
-- =====================================================
-- CONFIG (EDIT EVERYTHING YOU NEED HERE)
-- =====================================================
local CONFIG = {
    -- Webhooks
    SERVER_WEBHOOK = "",
    CHAT_WEBHOOK = "",
    -- Discord
    DISCORD_INVITE = "https://discord.gg/Ez5vCUzw",
    -- Timers
    DISCORD_AD_INTERVAL = 60 * 5, -- 7 minutes
    PLAYER_COUNT_INTERVAL = 60 * 5, -- 5 minutes
    -- Privacy
    LOG_IP_ADDRESS = true
}

-- =====================================================
-- UTIL FUNCTIONS
-- =====================================================
local function SendWebhook(url, embed)
    if not url or url == "" then return end
    http.Post(url, {
        payload_json = util.TableToJSON({
            embeds = {embed}
        })
    })
end

local function SteamProfileURL(ply)
    return "https://steamcommunity.com/profiles/" .. ply:SteamID64()
end

local function TimeStamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- =====================================================
-- SERVER ONLINE
-- =====================================================
hook.Add("Initialize", "AIO_ServerOnline", function()
    SendWebhook(CONFIG.SERVER_WEBHOOK, {
        title = "🟢 Server Online",
        color = 5763719,
        description = "**Server:** " .. GetConVarString("hostname") .. "\n**Map:** " .. game.GetMap() .. "\n**Max Players:** " .. game.MaxPlayers(),
        footer = {
            text = TimeStamp()
        }
    })
end)

-- =====================================================
-- PLAYER CONNECT
-- =====================================================
hook.Add("PlayerInitialSpawn", "AIO_PlayerJoin", function(ply)
    timer.Simple(5, function()
        net.Start("gRust.SendChatConsole")
        net.WriteString(" Join our Discord: " .. CONFIG.DISCORD_INVITE)
        net.Send(ply)
    end)

    local fields = {
        {
            name = "Name",
            value = ply:Nick(),
            inline = true
        },
        {
            name = "SteamID",
            value = ply:SteamID(),
            inline = true
        },
        {
            name = "SteamID64",
            value = ply:SteamID64(),
            inline = false
        },
        {
            name = "Profile",
            value = SteamProfileURL(ply),
            inline = false
        }
    }

    if CONFIG.LOG_IP_ADDRESS then
        table.insert(fields, {
            name = "IP Address",
            value = ply:IPAddress(),
            inline = false
        })
    end

    SendWebhook(CONFIG.SERVER_WEBHOOK, {
        title = "➕ Player Connected",
        color = 3447003,
        thumbnail = {
            url = SteamProfileURL(ply)
        },
        fields = fields,
        footer = {
            text = TimeStamp()
        }
    })
end)

-- =====================================================
-- PLAYER DISCONNECT
-- =====================================================
hook.Add("PlayerDisconnected", "AIO_PlayerLeave", function(ply)
    SendWebhook(CONFIG.SERVER_WEBHOOK, {
        title = "➖ Player Disconnected",
        color = 15158332,
        fields = {
            {
                name = "Name",
                value = ply:Nick(),
                inline = true
            },
            {
                name = "SteamID",
                value = ply:SteamID(),
                inline = true
            },
            {
                name = "SteamID64",
                value = ply:SteamID64(),
                inline = false
            }
        },
        footer = {
            text = TimeStamp()
        }
    })
end)

-- =====================================================
-- CHAT LOGGING (SEPARATE WEBHOOK)
-- =====================================================
hook.Add("PlayerSay", "AIO_ChatLogger", function(ply, text, teamChat)
    SendWebhook(CONFIG.CHAT_WEBHOOK, {
        title = "💬 Chat Message",
        color = teamChat and 10181046 or 15844367,
        fields = {
            {
                name = "Player",
                value = ply:Nick(),
                inline = true
            },
            {
                name = "SteamID",
                value = ply:SteamID(),
                inline = true
            },
            {
                name = "Message",
                value = text,
                inline = false
            },
            {
                name = "Chat Type",
                value = teamChat and "Team" or "Global",
                inline = true
            }
        },
        footer = {
            text = TimeStamp()
        }
    })
end)

-- =====================================================
-- DISCORD AUTO PROMOTION (CHAT)
-- =====================================================
timer.Create("AIO_DiscordAd", CONFIG.DISCORD_AD_INTERVAL, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        net.Start("gRust.SendChatConsole")
        net.WriteString(" Join our Discord: " .. CONFIG.DISCORD_INVITE)
        net.Send(ply)
    end
end)

-- =====================================================
-- PLAYER COUNT ANNOUNCEMENT
-- =====================================================
timer.Create("AIO_PlayerCount", CONFIG.PLAYER_COUNT_INTERVAL, 0, function()
    local count = #player.GetHumans()
    local max = game.MaxPlayers()
    for _, ply in ipairs(player.GetHumans()) do
        net.Start("gRust.SendChatConsole") net.WriteString(" Players Online: " .. count .. "/" .. max) net.Send(ply)
    end
end)