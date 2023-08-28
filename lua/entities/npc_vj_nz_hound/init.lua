AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2024 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/cod/blackops/hellhound.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 50

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}

ENT.BloodColor = "Red"
ENT.HasDeathAnimation = true
ENT.HasDeathRagdoll = false

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 90
ENT.MeleeAttackDamageDistance = 110
ENT.TimeUntilMeleeAttackDamage = 0.6
ENT.MeleeAttackDamage = 20

ENT.SoundTbl_Idle = {"vj_nz/nz/hellhound/close/close_00.wav","vj_nz/nz/hellhound/close/close_01.wav","vj_nz/nz/hellhound/close/close_02.wav","vj_nz/nz/hellhound/close/close_03.wav"}
ENT.SoundTbl_Alert = {"vj_nz/nz/hellhound/death2/death0.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_nz/nz/hellhound/attack/attack_00.wav","vj_nz/nz/hellhound/attack/attack_01.wav","vj_nz/nz/hellhound/attack/attack_02.wav","vj_nz/nz/hellhound/attack/attack_03.wav","vj_nz/nz/hellhound/attack/attack_04.wav","vj_nz/nz/hellhound/attack/attack_05.wav","vj_nz/nz/hellhound/attack/attack_06.wav"}
ENT.SoundTbl_Death = {"vj_nz/nz/hellhound/death2/death0.wav","vj_nz/nz/hellhound/death2/death1.wav","vj_nz/nz/hellhound/death2/death2.wav","vj_nz/nz/hellhound/death2/death3.wav","vj_nz/nz/hellhound/death2/death4.wav","vj_nz/nz/hellhound/death2/death5.wav","vj_nz/nz/hellhound/death2/death6.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetBodygroup(0,math.random(0,1))
	self:SetNoDraw(true)
	ParticleEffect("hound_summon",self:GetPos(),Angle())
	timer.Simple(0,function()
		self.GodMode = true
		self:EmitSound("vj_nz/hhound/prespawn.mp3",200,100)
		self.HasMeleeAttack = false
		timer.Simple(0.25,function()
			if IsValid(self) then
				self:VJ_ACT_PLAYACTIVITY(ACT_JUMP,true,false,false)
			end
		end)
		timer.Simple(0.8,function()
			if IsValid(self) then
				ParticleEffectAttach("bo3_hellhound_aura",PATTACH_POINT_FOLLOW,self,0)
				self.GodMode = false
				self:SetNoDraw(false)
				self:EmitSound("vj_nz/lgtstrike.mp3",511,100)
				self:EmitSound("vj_nz/nz/hellhound/dist_vox_a/dist_vox_a_02.wav",511,100)
				self.HasMeleeAttack = true
			end
		end)
	end)

	self.AnimTbl_Walk = {ACT_WALK_ANGRY}
	self.AnimTbl_Run = {ACT_RUN}
	self.AnimTbl_Death = {"nz_death1","nz_death2","nz_death3"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	ParticleEffect("hound_explosion",self:GetPos(),Angle())
	VJ.ApplyRadiusDamage(self, self, self:GetPos(), 250, 40, bit.bor(DMG_BLAST,DMG_BURN), true, true, {Force=80})
	SafeRemoveEntity(self)
end