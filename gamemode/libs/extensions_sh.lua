--
-- Accessor
--

function gRust.AccessorFunc(tbl, key, name)
    name = name or key
    tbl["Get" .. name] = function(self)
        return self[key]
    end

    tbl["Set" .. name] = function(self, val)
        self[key] = val
        return self
    end
end