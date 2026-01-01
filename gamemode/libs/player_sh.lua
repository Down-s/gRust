function gRust.FindPlayer(id)
    id = string.lower(id)

    for _, pl in player.Iterator() do
        if (string.find(string.lower(pl:Name()), id) or pl:SteamID64() == id) then
            return pl
        end
    end

    return nil
end