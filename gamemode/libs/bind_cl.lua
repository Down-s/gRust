local Binds = {}

function gRust.AddBind(bind, callback)
    Binds[bind] = callback
end

function GM:PlayerBindPress(pl, bind, pressed)
    if (Binds[bind] and pressed) then
        Binds[bind](pl)
        return true
    end
end