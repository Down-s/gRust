util.AddNetworkString("gRust_Teleport_Map")
net.Receive("gRust_Teleport_Map", function(len, pl)
	if not pl:IsAdmin() then return end
	local mappos = net.ReadVector()
	local mapvec = game.GetWorld():GetInternalVariable("m_WorldMins")
	local startHeight = 5000 -- Start well above the map
	-- Trace downward to find the ground
	local traceData = {
		start = Vector(mappos.x, mappos.y, startHeight),
		endpos = Vector(mappos.x, mappos.y, mapvec.z),
		filter = pl
	}

	local trace = util.TraceLine(traceData)
	if trace.Hit then
		local dropHeight = 500
		-- Position player above the ground surface
		pl:SetPos(trace.HitPos + Vector(0, 0, dropHeight))
		pl:SetVelocity(Vector(0, 0, -200))
		-- Optional: Remove fall damage
		hook.Add("GetFallDamage", "SoftLanding_" .. pl:UserID(), function(ply, speed)
			if ply == pl then
				hook.Remove("GetFallDamage", "SoftLanding_" .. pl:UserID())
				return 0
			end
		end)
	else
		-- Fallback if no ground found
		pl:SetPos(Vector(mappos.x, mappos.y, 0))
	end
end)