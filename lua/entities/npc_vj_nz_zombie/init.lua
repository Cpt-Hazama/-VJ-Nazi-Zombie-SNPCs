AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2024 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/cod/blackops/nazizombie.mdl"}
ENT.StartHealth = 80

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.BloodColor = "Red"

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 85
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 20

ENT.FootStepTimeRun = 0.35
ENT.FootStepTimeWalk = 0.8
ENT.HasExtraMeleeAttackSounds = true

ENT.SoundTbl_FootStep = {"vj_nz/nz/steps_01.mp3","vj_nz/nz/steps_02.mp3"}
ENT.SoundTbl_Idle = {"vj_nz/nz/ambient_01.mp3","vj_nz/nz/ambient_02.mp3","vj_nz/nz/ambient_03.mp3","vj_nz/nz/ambient_04.mp3"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_nz/nz/att_01.mp3","vj_nz/nz/att_02.mp3","vj_nz/nz/att_03.mp3","vj_nz/nz/att_04.mp3","vj_nz/nz/att_05.mp3"}
ENT.SoundTbl_Death = {"vj_nz/nz/die_01.mp3","vj_nz/nz/die_02.mp3","vj_nz/nz/die_03.mp3","vj_nz/nz/die_04.mp3","vj_nz/nz/die_05.mp3"}
ENT.SoundTbl_Alert = {"vj_nz/nz/taunt_01.mp3","vj_nz/nz/taunt_02.mp3","vj_nz/nz/taunt_03.mp3"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_nz/nz/hit_01.mp3","vj_nz/nz/hit_02.mp3"}
ENT.SoundTbl_CombatIdle = {"vj_nz/nz/zombies/sprint2/sprint0.wav","vj_nz/nz/zombies/sprint2/sprint1.wav","vj_nz/nz/zombies/sprint2/sprint2.wav","vj_nz/nz/zombies/sprint2/sprint3.wav","vj_nz/nz/zombies/sprint2/sprint4.wav","vj_nz/nz/zombies/sprint2/sprint5.wav","vj_nz/nz/zombies/sprint2/sprint6.wav","vj_nz/nz/zombies/sprint2/sprint7.wav","vj_nz/nz/zombies/sprint2/sprint8.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimMovementType = 0 -- 0 = HP Based, 1 = Walk Only, 2 = Run Only, 3 = Sprint Only
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetSkin(math.random(0,11))
	self:SetBodygroup(0,math.random(0,3))
	self:SetBodygroup(1,math.random(0,1))
	if self:IsDirt(self:GetPos()) or self.SpawnedUsingMutator then
		self:SetNoDraw(true)
		-- self:SetState(VJ_STATE_ONLY_ANIMATION_NOATTACK)
		timer.Simple(0,function()
			if IsValid(self) then
				self:VJ_ACT_PLAYACTIVITY({"vjseq_nz_emerge1","vjseq_nz_emerge2","vjseq_nz_emerge3","vjseq_nz_emerge4","vjseq_nz_emerge5"},true,false,false,0,{OnFinish=function(anim,interrupted)
					-- if interrupted then return end
					-- self:SetState()
				end})
				timer.Simple(0.1,function()
					if IsValid(self) then
						self:SetNoDraw(false)
						self:EmitSound("vj_nz/dirtintro" .. math.random(1,2) .. ".mp3")
						ParticleEffect("bo3_zombie_spawn",self:GetPos(),self:GetAngles())
						self:AddEyes("lefteye")
						self:AddEyes("righteye")
					end
				end)
			end
		end)
	else
		self:AddEyes("lefteye")
		self:AddEyes("righteye")
	end

	self.LastAnimMovementType = 0
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AddEyes(attachment)
	local selectcolor
	local selectcolorstring
	local var = GetConVarNumber("vj_nz_eyecolor")
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
	local glow = ents.Create("env_sprite")
	glow:SetKeyValue("model","vj_base/sprites/vj_glow1.vmt")
	glow:SetKeyValue("scale","0.035")
	glow:SetKeyValue("rendermode","5")
	glow:SetKeyValue("rendercolor",selectcolorstring)
	glow:SetKeyValue("spawnflags","1") -- If animated
	glow:SetParent(self)
	glow:Fire("SetParentAttachment",attachment,0)
	glow:Spawn()
	glow:Activate()
	self:DeleteOnRemove(glow)
	self:DeleteOnRemove(util.SpriteTrail(self,self:LookupAttachment(attachment),selectcolor,true,6,0,0.1,1/(6+12)*0.5,"VJ_Base/sprites/vj_trial1.vmt"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
local MAT_GRASS = 85
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
	local moveType = self.AnimMovementType
	if moveType == 0 then
		local hpPer = self:Health() /self:GetMaxHealth()

		if hpPer > 0.8 && self.LastFreeMovement != 1 then
			self.AnimTbl_Run = {ACT_WALK}
			self.LastFreeMovement = 1
			self.FootStepTimeRun = 0.8
			self.FootStepTimeWalk = 0.8
		elseif hpPer > 0.5 && hpPer <= 0.8 && self.LastFreeMovement != 2 then
			self.AnimTbl_Run = {ACT_RUN}
			self.LastFreeMovement = 2
			self.FootStepTimeRun = 0.35
			self.FootStepTimeWalk = 0.35
		elseif hpPer <= 0.5 && self.LastFreeMovement != 3 then
			self.AnimTbl_Run = {ACT_SPRINT}
			self.LastFreeMovement = 3
			self.FootStepTimeRun = 0.25
			self.FootStepTimeWalk = 0.25
		end
	else
		if moveType != self.LastAnimMovementType then
			local time = moveType == 1 && 0.8 or moveType == 2 && 0.35 or moveType == 3 && 0.25
			self.AnimTbl_Run = {moveType == 1 && ACT_WALK or moveType == 2 && ACT_RUN or moveType == 3 && ACT_SPRINT or ACT_WALK}
			self.LastAnimMovementType = moveType
			self.FootStepTimeRun = time
			self.FootStepTimeWalk = time
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "event_mattack" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	if !IsValid(self:GetEnemy()) then
		if self:IsMoving() then
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2}
		else
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK_SWING}
		end
	elseif IsValid(self:GetEnemy()) then
		if self:GetEnemy():GetVelocity():Length() > 25 then
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2}
		else
			self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK_SWING}
		end
	end
end