-- ================================
-- Block Family Shared Accounts
-- ================================
hook.Add("PlayerAuthed", "BlockFamilySharing", function(ply)
    -- Check if the player's account is a family share
    if ply:OwnerSteamID64() ~= ply:SteamID64() then
        -- Kick the player
        ply:Kick("Family Shared accounts are not allowed on this server.")
        -- Optional: print to server console
        print("[ANTI-FAMILYSHARE] Kicked " .. ply:Nick() .. " (" .. ply:SteamID64() .. ") for using Family Sharing.")
    end
end)