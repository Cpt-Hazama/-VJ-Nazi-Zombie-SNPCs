AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
-- ENT.SoundTbl_Idle = {"vj_nz/annihilation.mp3"}
ENT.IdleSoundLevel = 511
ENT.IdleSoundPitch1 = 100
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 274
ENT.NextSoundTime_Idle2 = 274
local targetents = {
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombierun",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	"npc_vj_nz_zombiewalk",
	-- "npc_vj_nz_hound", // Kind of annoying sound wise
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound",
	-- "npc_vj_nz_hound"
}
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = targetents},
	{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = targetents},
	{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = targetents},

	{EntityName = "NPC5",SpawnPosition = {vForward=150,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC6",SpawnPosition = {vForward=0,vRight=150,vUp=5},Entities = targetents},
	{EntityName = "NPC7",SpawnPosition = {vForward=150,vRight=150,vUp=5},Entities = targetents},
	{EntityName = "NPC8",SpawnPosition = {vForward=150,vRight=-150,vUp=5},Entities = targetents},

	{EntityName = "NPC9",SpawnPosition = {vForward=200,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC10",SpawnPosition = {vForward=0,vRight=200,vUp=5},Entities = targetents},
	{EntityName = "NPC11",SpawnPosition = {vForward=200,vRight=200,vUp=5},Entities = targetents},
	{EntityName = "NPC12",SpawnPosition = {vForward=200,vRight=-200,vUp=5},Entities = targetents},

	{EntityName = "NPC13",SpawnPosition = {vForward=250,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC14",SpawnPosition = {vForward=0,vRight=250,vUp=5},Entities = targetents},
	{EntityName = "NPC15",SpawnPosition = {vForward=250,vRight=250,vUp=5},Entities = targetents},
	{EntityName = "NPC16",SpawnPosition = {vForward=250,vRight=-250,vUp=5},Entities = targetents},

	{EntityName = "NPC17",SpawnPosition = {vForward=300,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC18",SpawnPosition = {vForward=0,vRight=300,vUp=5},Entities = targetents},
	{EntityName = "NPC19",SpawnPosition = {vForward=300,vRight=300,vUp=5},Entities = targetents},
	{EntityName = "NPC20",SpawnPosition = {vForward=300,vRight=-300,vUp=5},Entities = targetents}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_AfterNPCSpawn()
	for _,v in ipairs(player.GetAll()) do
		v.VJ_NaziZSong = CreateSound(v,"vj_nz/annihilation.mp3")
		v.VJ_NaziZSong:SetSoundLevel(45)
		v.VJ_NaziZSongT = CurTime()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_BeforeAliveChecks()
	for _,v in ipairs(player.GetAll()) do
		if CurTime() > v.VJ_NaziZSongT then
			v.VJ_NaziZSong:Stop()
			v.VJ_NaziZSong:Play()
			v.VJ_NaziZSongT = CurTime() +273
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	for _,v in ipairs(player.GetAll()) do
		if v.VJ_NaziZSong then
			v.VJ_NaziZSong:FadeOut(10)
		end
	end
	if self.SingleSpawner == false && self.CurrentEntities != nil then
		for k,v in ipairs(self.CurrentEntities) do
			if IsValid(v.TheEntity) && v.TheEntity then v.TheEntity:Remove() end
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/