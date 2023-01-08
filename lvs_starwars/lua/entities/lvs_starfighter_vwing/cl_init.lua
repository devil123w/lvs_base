include("shared.lua")

ENT.EngineColor = Color( 255, 220, 150, 255)
ENT.EngineGlow = Material( "sprites/light_glow02_add" )
ENT.EngineCenter = Material( "vgui/circle" )
ENT.EnginePos = {
	[1] = Vector(-155,0,76.85),
	[2] = Vector(-155,0,41.82),
}

function ENT:CalcViewDriver( ply, pos, angles, fov, pod )
	pos = pos + self:GetForward() * 37 + self:GetUp() * 8
	if ply:lvsMouseAim() then
		return self:CalcViewMouseAim( ply, pos, angles, fov, pod )
	else
		return self:CalcViewDirectInput( ply, pos, angles, fov, pod )
	end
end

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-152,55,55), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-152,-55,55), 0, 20, 2, 1000, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for _, pos in pairs( self.EnginePos ) do
		local vOffset = self:LocalToWorld( pos )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "effects/muzzleflash2", vOffset )

		if not particle then continue end

		particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(15,25) )
		particle:SetEndSize( math.Rand(0,10) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
		particle:SetColor( 255, 200, 50 )
	end
end

function ENT:PostDraw()
	if not self:GetEngineActive() then return end

	cam.Start3D2D( self:LocalToWorld( Vector(-136,0,76.85) ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
	cam.End3D2D()
	
	cam.Start3D2D( self:LocalToWorld( Vector(-136,0,41.82) ), self:LocalToWorldAngles( Angle(-90,0,0) ), 1 )
		surface.SetDrawColor( self.EngineColor )
		surface.SetMaterial( self.EngineCenter )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( self.EngineGlow )
		surface.DrawTexturedRectRotated( 0, 0, 20, 20 , 0 )
	cam.End3D2D()
end

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 60 + self:GetThrottle() * 60 + self:GetBoost()

	render.SetMaterial( self.EngineGlow )

	for _, pos in pairs( self.EnginePos ) do
		render.DrawSprite(  self:LocalToWorld( pos ), Size, Size, self.EngineColor )
	end
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/vwing/boost.wav", 85 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 85 )
end