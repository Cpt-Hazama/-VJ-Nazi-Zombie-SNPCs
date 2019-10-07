AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/cpthazama/cod/blackops/hellhound.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 75
ENT.HullType = HULL_HUMAN
ENT.HasDeathRagdoll = false
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 90 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 110 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 23
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.DeathAnimationTime = 0.9 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_nz/nz/hellhound/close/close_00.wav","vj_nz/nz/hellhound/close/close_01.wav","vj_nz/nz/hellhound/close/close_02.wav","vj_nz/nz/hellhound/close/close_03.wav"}
ENT.SoundTbl_Alert = {"vj_nz/nz/hellhound/death2/death0.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_nz/nz/hellhound/attack/attack_00.wav","vj_nz/nz/hellhound/attack/attack_01.wav","vj_nz/nz/hellhound/attack/attack_02.wav","vj_nz/nz/hellhound/attack/attack_03.wav","vj_nz/nz/hellhound/attack/attack_04.wav","vj_nz/nz/hellhound/attack/attack_05.wav","vj_nz/nz/hellhound/attack/attack_06.wav"}
ENT.SoundTbl_Death = {"vj_nz/nz/hellhound/death2/death0.wav","vj_nz/nz/hellhound/death2/death1.wav","vj_nz/nz/hellhound/death2/death2.wav","vj_nz/nz/hellhound/death2/death3.wav","vj_nz/nz/hellhound/death2/death4.wav","vj_nz/nz/hellhound/death2/death5.wav","vj_nz/nz/hellhound/death2/death6.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetBodygroup(0,math.random(0,1))
	self:SetNoDraw(true)
	self:VJ_ACT_PLAYACTIVITY(ACT_JUMP,true,2,true)
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos() +Vector(0,0,-30))
	effectdata:SetScale(1000)
	util.Effect("lightning_prespawn",effectdata)
	self:EmitSound("vj_nz/nz/round/special_round_start.wav",511,100)
	self.GodMode = true
	timer.Simple(2,function()
		if self:IsValid() then
			self:EmitSound("vj_nz/nz/round/dog_start.wav",511,100)
		end
	end)
	self:EmitSound("vj_nz/hhound/prespawn.mp3",200,100)
	self.HasMeleeAttack = false
	timer.Simple(2,function()
		if self:IsValid() then
			self.GodMode = false
			self:SetNoDraw(false)
			self:EmitSound("vj_nz/lgtstrike.mp3",511,100)
			self:EmitSound("vj_nz/nz/hellhound/dist_vox_a/dist_vox_a_02.wav",511,100)
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetScale(1000)
			util.Effect("lightning_strike",effectdata)
			self.HasMeleeAttack = true
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.AnimTbl_Walk = {ACT_WALK_ANGRY}
	self.AnimTbl_Run = {ACT_RUN}
	self.AnimTbl_Death = {"nz_death1","nz_death2","nz_death3"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude","100")
	ent:Fire("explode")
	SafeRemoveEntity(self)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/