local GRUST_COLOR = Color(17, 148, 240)
local MESSAGE_COLOR = Color(255, 255, 255)
local SUCCESS_COLOR = Color(0, 255, 0)
local WARNING_COLOR = Color(255, 255, 0)
local ERROR_COLOR = Color(255, 0, 0)

function gRust.Log(msg)
    MsgC(GRUST_COLOR, "[gRust] ", MESSAGE_COLOR, msg .. "\n")
end

function gRust.LogSuccess(msg)
    MsgC(SUCCESS_COLOR, "[gRust] ", MESSAGE_COLOR, msg .. "\n")
end

function gRust.LogWarning(msg)
    MsgC(WARNING_COLOR, "[gRust] ", MESSAGE_COLOR, msg .. "\n")
end

function gRust.LogError(msg)
    MsgC(ERROR_COLOR, "[gRust] ", MESSAGE_COLOR, msg .. "\n")
end