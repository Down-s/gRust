function string.Cap(str, max)
    if (#str > (max + 3)) then
        return string.Trim(string.sub(str, 1, max)) .. "..."
    end

    return str
end

function string.IsNullOrEmpty(str)
    return str == nil or str == "" or string.Trim(str) == ""
end