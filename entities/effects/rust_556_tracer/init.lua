EFFECT.Length = 500
EFFECT.WhizDistance = 500

local TracerMaterial = Material("effects/rust_tracer")

function EFFECT:GetTracerOrigin(data)
	return data:GetStart()
end

function EFFECT:Init(data)
	local startPos = self:GetTracerOrigin(data)
	local endPos = data:GetOrigin()

	self.Entity:SetRenderBoundsWS(startPos, endPos)

	local diff = endPos - startPos
	self.Normal = diff:GetNormal()
	self.StartPos = startPos
	self.Speed = (diff:Length() + self.Length) / (data:GetMagnitude() / 100)
	self.StartTime = 0
	self.LifeTime = (diff:Length() + self.Length) / self.Speed
end

function EFFECT:Think()
	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()

	return self.LifeTime > 0
end

function EFFECT:Render()
	local endDistance = self.Speed * self.StartTime
	local startDistance = endDistance - self.Length

	startDistance = math.max(0, startDistance)
	endDistance = math.max(0, endDistance)

	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance

	render.SetMaterial(TracerMaterial)
	render.DrawBeam(startPos, endPos, 10, 0, 1, color_white)
end