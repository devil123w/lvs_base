
ENT.Base = "lvs_base_fighterplane"

ENT.PrintName = "template script"
ENT.Author = "*your name*"
ENT.Information = ""
ENT.Category = "[LVS] *your category*"

ENT.Spawnable			= false -- set to "true" to make it spawnable
ENT.AdminSpawnable		= false

ENT.MDL = "models/props_wasteland/laundry_cart001.mdl" -- model forward direction must be facing to X+
--[[
ENT.GibModels = {
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_phx/misc/propeller3x_small.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
}
]]

ENT.AITEAM = 1
--[[
TEAMS:
	0 = FRIENDLY TO EVERYONE
	1 = FRIENDLY TO TEAM 1 and 0
	2 = FRIENDLY TO TEAM 2 and 0
	3 = HOSTILE TO EVERYONE
]]

ENT.MaxVelocity = 2500 -- max theoretical velocity at 0 degree climb
ENT.MaxPerfVelocity = 1800 -- speed in which the plane will have its maximum turning potential
ENT.MaxThrust = 1250 -- max push power

ENT.ThrottleRateUp = 0.6 -- how fast throttle goes up
ENT.ThrottleRateDown = 0.3 -- how fast throttle goes down

ENT.TurnRatePitch = 1 -- max turn rate in pitch (up / down)
ENT.TurnRateYaw = 1 -- max turn rate in yaw (left / right)
ENT.TurnRateRoll = 1 -- max turn rate in roll

ENT.ForceLinearMultiplier = 1 -- multiplier for linear force in X / Y / Z direction

ENT.ForceAngleMultiplier = 1 -- multiplier for angular forces in pitch / yaw / roll direction
ENT.ForceAngleDampingMultiplier = 1 -- how much angular motion is dampened (smaller value = wobble more)

ENT.MaxSlipAnglePitch = 20 -- how many degrees the plane is allowed to slip from forward-motion direction vs forward-facing direction
ENT.MaxSlipAngleYaw = 10 -- same for yaw

ENT.MaxHealth = 1000

function ENT:OnSetupDataTables() -- use this to add networkvariables instead of ENT:SetupDataTables().
	--self:AddDT(  string_type, string_name, table_extended ) -- please use self:AddDT() function instead of self:NetworkVar(). It automatically handles slot indexes internally.

	-- example:
	--self:AddDT( "Float", "MyValue", { KeyName = "myvalue", Edit = { type = "Float", order = 3,min = 0, max = 10, category = "Misc"}  )
end

--[[
function ENT:CalcMainActivity( ply ) -- edit player anims here, works just like CalcMainActivity Hook.
end
]]


function ENT:InitWeapons()
	-- add a weapon:

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local bullet = {}
		bullet.Src 	= ent:LocalToWorld( Vector(25,0,30) )
		bullet.Dir 	= ent:GetForward()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.TracerName = "lvs_tracer_orange"
		bullet.Force	= 10
		bullet.HullSize 	= 15
		bullet.Damage	= 10
		bullet.Velocity = 30000
		bullet.SplashDamage = 100
		bullet.SplashDamageRadius = 25
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end

		ent:LVSFireBullet( bullet )

		ent:EmitSound("npc/sniper/echo1.wav", 95, math.random(95,105), 1, CHAN_WEAPON )
	end
	weapon.StartAttack = function( ent ) end
	weapon.FinishAttack = function( ent ) end
	weapon.OnSelect = function( ent ) end
	weapon.OnDeselect = function( ent ) end
	weapon.OnThink = function( ent, active ) end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.OnRemove = function( ent ) end
	self:AddWeapon( weapon )

--[[
	-- or use presets:
	self.PosLMG = Vector(25,0,30)
	self.DirLMG = 0
	self:AddWeapon( LVS:GetWeaponPreset( "LMG" ) )
]]
end


-- sounds
ENT.FlyByAdvance = 0.5 -- how many second the flyby sound is advanced
ENT.FlyBySound = "lvs/vehicles/bf109/flyby.wav" -- which sound to play on fly by
ENT.DeathSound = "lvs/vehicles/generic/crash.wav" -- which sound to play on death (only in flight)

-- Engine Sounds only work in combination with self:AddEngine in init.lua
-- this is just where it reads the sound data so it doesnt have to be networked
ENT.EngineSounds = {
	{
		sound = "ambient/machines/spin_loop.wav", -- exterior sound
		--sound_int = "vehicles/airboat/fan_motor_fullthrottle_loop1.wav", -- interior sound
		Pitch = 80, -- pitch start value
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		FadeIn = 0, -- fade in at 0 Throttle
		FadeOut = 1, -- fade out at 1 Throttle
		FadeSpeed = 1.5, -- how fast to fade
		UseDoppler = true, -- set false to not use doppler
		--VolumeMin = 0,
		--VolumeMax = 1,
		--SoundLevel = 110,
	},
}