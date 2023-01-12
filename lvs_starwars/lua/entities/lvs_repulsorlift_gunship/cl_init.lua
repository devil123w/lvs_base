include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetDriverSeat() then

		if pod:GetThirdPersonMode() then
			pos = pos + self:GetUp() * 200, angles, fov
		end

		return pos, angles, fov
	end

	if pod == self:GetGunnerSeat() or pod == self:GetBTPodL() or pod == self:GetBTPodR() then return pos, angles, fov end

	if pod:GetThirdPersonMode() then
		pos = ply:GetShootPos() + pod:GetUp() * 40
	else
		pos = pos + pod:GetUp() * 40
	end

	return pos, angles, fov
end

function ENT:OnSpawn()
end

function ENT:OnFrame()
end

function ENT:OnStartBoost()
	self:EmitSound( "^lvs/vehicles/laat/boost_"..math.random(1,2)..".wav", 85 )
end

function ENT:OnStopBoost()
end