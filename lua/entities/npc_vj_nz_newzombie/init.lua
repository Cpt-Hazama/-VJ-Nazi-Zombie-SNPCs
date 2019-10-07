AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- ENT.Model = {"models/cpthazama/cod/blackops/nazizombie_soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.Model = {"models/boz/soldierzombie_evts.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 1 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 20

ENT.FootStepTimeRun = 0.35 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_nz/nz/steps_01.mp3","vj_nz/nz/steps_02.mp3"}
ENT.SoundTbl_Idle = {"vj_nz/nz/ambient_01.mp3","vj_nz/nz/ambient_02.mp3","vj_nz/nz/ambient_03.mp3","vj_nz/nz/ambient_04.mp3"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_nz/nz/att_01.mp3","vj_nz/nz/att_02.mp3","vj_nz/nz/att_03.mp3","vj_nz/nz/att_04.mp3","vj_nz/nz/att_05.mp3"}
ENT.SoundTbl_Death = {"vj_nz/nz/die_01.mp3","vj_nz/nz/die_02.mp3","vj_nz/nz/die_03.mp3","vj_nz/nz/die_04.mp3","vj_nz/nz/die_05.mp3"}
ENT.SoundTbl_Alert = {"vj_nz/nz/taunt_01.mp3","vj_nz/nz/taunt_02.mp3","vj_nz/nz/taunt_03.mp3"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_nz/nz/hit_01.mp3","vj_nz/nz/hit_02.mp3"}
ENT.SoundTbl_CombatIdle = {"vj_nz/nz/zombies/sprint2/sprint0.wav","vj_nz/nz/zombies/sprint2/sprint1.wav","vj_nz/nz/zombies/sprint2/sprint2.wav","vj_nz/nz/zombies/sprint2/sprint3.wav","vj_nz/nz/zombies/sprint2/sprint4.wav","vj_nz/nz/zombies/sprint2/sprint5.wav","vj_nz/nz/zombies/sprint2/sprint6.wav","vj_nz/nz/zombies/sprint2/sprint7.wav","vj_nz/nz/zombies/sprint2/sprint8.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.UseMovementOverride = false
ENT.UseWalk = false
ENT.UseRun = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	-- self:SetSkin(math.random(0,11))
	-- self:SetBodygroup(0,math.random(0,3))
	-- self:SetBodygroup(1,math.random(0,1))
	if self:IsDirt(self:GetPos()) then
		self:SetNoDraw(true)
		local anim = VJ_PICKRANDOMTABLE({"spawn1","spawn2","spawn3"})
		self:VJ_ACT_PLAYACTIVITY(anim,true,VJ_GetSequenceDuration(self,anim) -0.2,true)
		self.HasMeleeAttack = false
		timer.Simple(1,function()
			if self:IsValid() then
				self:SetNoDraw(false)
				self:EmitSound("vj_nz/dirtintro" .. math.random(1,2) .. ".mp3")
				ParticleEffect("advisor_plat_break",self:GetPos(),self:GetAngles(),self)
				ParticleEffect("strider_impale_ground",self:GetPos(),self:GetAngles(),self)
				self.HasMeleeAttack = true
				-- self:AddEyes("lefteye")
				-- self:AddEyes("righteye")
			end
		end)
	else
		-- self:AddEyes("lefteye")
		-- self:AddEyes("righteye")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert()
	if math.random(1,5) == 1 then
		self:VJ_ACT_PLAYACTIVITY(ACT_ARM,true,VJ_GetSequenceDuration(self,ACT_ARM),false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddEyes(attachment)
	local selectcolor
	local selectcolorstring
	local selectcolorextra
	local selectcolorstringextra
	local var = GetConVarNumber("vj_nzeyecolor")
	if var == 1 then // orange
		selectcolor = Color(255,90,0,255)
		selectcolorstring = "255 90 0 255"
	elseif var == 2 then // red
		selectcolor = Color(255,0,0,255)
		selectcolorstring = "255 0 0 255"
	elseif var == 3 then // blue
		selectcolor = Color(0,63,255,255)
		selectcolorstring = "0 63 255 255"
	elseif var == 4 then // green
		selectcolor = Color(0,127,31,255)
		selectcolorstring = "0 127 31 255"
	end
	_EyeGlow = ents.Create("env_sprite")
	_EyeGlow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	_EyeGlow:SetKeyValue("scale","0.043")
	_EyeGlow:SetKeyValue("rendermode","5")
	_EyeGlow:SetKeyValue("rendercolor",selectcolorstring)
	_EyeGlow:SetKeyValue("spawnflags","1") -- If animated
	_EyeGlow:SetParent(self)
	_EyeGlow:Fire("SetParentAttachment",attachment,0)
	_EyeGlow:Spawn()
	_EyeGlow:Activate()
	self:DeleteOnRemove(_EyeGlow)
	if attachment == "lefteye" then util.SpriteTrail(self,1,selectcolor,true,2,2,0.1,1/(6+12)*0.5,"VJ_Base/sprites/vj_trial1.vmt") end
	if attachment == "righteye" then util.SpriteTrail(self,2,selectcolor,true,2,2,0.1,1/(6+12)*0.5,"VJ_Base/sprites/vj_trial1.vmt") end
end
---------------------------------------------------------------------------------------------------------------------------------------------
MAT_GRASS = 85
function ENT:IsDirt(pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos -Vector(0,0,40),
		filter = self,
		mask = MASK_NPCWORLDSTATIC
	})
	local mat = tr.MatType
	return tr.HitWorld && (mat == MAT_SAND || mat == MAT_DIRT || mat == MAT_FOLIAGE || mat == MAT_SLOSH || mat == MAT_GRASS)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:Health() < 40 then
		self.AnimTbl_Walk = {ACT_RUN}
		self.AnimTbl_Run = {ACT_RUN}
	else
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,2)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {"vjseq_melee1"}
		self.TimeUntilMeleeAttackDamage = 1.1
		self.MeleeAttackDamageDistance = 110
		self.MeleeAttackExtraTimers = {1.53}
	else
		self.AnimTbl_MeleeAttack = {"vjseq_melee2"}
		self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackDamageDistance = 90
		self.MeleeAttackExtraTimers = {}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/