--
-- Local database
--

function gRust.LocalQuery(query, callback)
    local result = sql.Query(query)
    if (result == false) then
        gRust.LogError("gRust Local query failed: " .. sql.LastError())
        return
    end

    if (callback) then
        callback(result)
    end
end