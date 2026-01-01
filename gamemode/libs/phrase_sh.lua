gRust.Languages = gRust.Languages or {}
gRust.Language = "English"

function gRust.GetPhrase(phrase)
    if (gRust.Language == "English") then return phrase end
    return gRust.Languages[gRust.Language] and gRust.Languages[gRust.Language][phrase] or phrase
end