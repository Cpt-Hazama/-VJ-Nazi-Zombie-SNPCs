AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.NZ_TotalDeaths = 0
ENT.NZ_TallyCheck = 0
ENT.NZ_Wave = 1
ENT.NZ_TimeBetweenWaves = 10
ENT.NZ_UISoundLevel = 42.5
ENT.NZ_SwitchingWaves = false
ENT.NZ_Zombies = {}
local NZ_WaveEntities = {
	"npc_vj_nz_zombiewalk"
}
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = NZ_WaveEntities},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = NZ_WaveEntities},
	{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = NZ_WaveEntities},
	{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = NZ_WaveEntities},
	{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-100,vUp=5},Entities = NZ_WaveEntities}
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize_BeforeNPCSpawn()
	self:NZ_PlayUISound("vj_nz/nz/round/round_start.mp3")
	self.NZ_AliveTable = {}
	for _,v in ipairs(player.GetAll()) do
		if v:IsValid() then
			v:ChatPrint("Wave " .. self.NZ_Wave .. " has begun.")
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_GetCalculatedFrags(nzwave)
	local nz_multiplieramount = 7
	local fixedwave = nz_multiplieramount *nzwave
	return fixedwave +1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_CalculateWaveTarget(nzwave)
	local target = self:NZ_GetCalculatedFrags(nzwave)
	if (self.NZ_TotalDeaths >= target) then
		return true
	else
		return false
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnAnEntity(keys,values,initspawn)
	if self.NZ_TotalDeaths +table.Count(self.NZ_AliveTable) > self:NZ_GetCalculatedFrags(self.NZ_Wave) then
		return
	end
	local k = keys
	local v = values
	local initspawn = initspawn or false
	local overridedisable = false
	local hasweps = false
	local wepslist = {}
	if initspawn == true then overridedisable = true end
	if self.VJBaseSpawnerDisabled == true && overridedisable == false then return end
	local getthename = v.EntityName
	local spawnpos = v.SpawnPosition
	local getthename = ents.Create(VJ_PICKRANDOMTABLE(v.Entities))
	getthename:SetPos(self:GetPos() +self:GetForward()*spawnpos.vForward +self:GetRight()*spawnpos.vRight +self:GetUp()*spawnpos.vUp)
	getthename:SetAngles(self:GetAngles())
	getthename:Spawn()
	getthename:Activate()
	getthename.VJ_NaziZombieS = true
	getthename.VJ_NaziZombieSpawner = self
	function getthename:CustomOnRemove()
		self.VJ_NaziZombieSpawner:NZ_OnZombieDeath(self)
		table.remove(self.VJ_NaziZombieSpawner.NZ_AliveTable,self.VJ_NaziZombieSpawner.NZ_AliveTable[self])
	end
	print(getthename)
	table.insert(self.NZ_AliveTable,getthename)
	if v.WeaponsList != nil && VJ_PICKRANDOMTABLE(v.WeaponsList) != false && VJ_PICKRANDOMTABLE(v.WeaponsList) != NULL && VJ_PICKRANDOMTABLE(v.WeaponsList) != "None" && VJ_PICKRANDOMTABLE(v.WeaponsList) != "none" then hasweps = true wepslist = v.WeaponsList end
	if hasweps == true then getthename:Give(VJ_PICKRANDOMTABLE(v.WeaponsList)) end
	if initspawn == false then table.remove(self.CurrentEntities,k) end
	table.insert(self.CurrentEntities,k,{EntityName=v.EntityName,SpawnPosition=v.SpawnPosition,Entities=v.Entities,TheEntity=getthename,WeaponsList=wepslist,Dead=false/*NextTimedSpawnT=CurTime()+self.TimedSpawn_Time*/})
	self:SpawnEntitySoundCode()
	if self.VJBaseSpawnerDisabled == true && overridedisable == true then getthename:Remove() return end
	self:CustomOnEntitySpawn(v.EntityName,v.SpawnPosition,v.Entities,TheEntity)
	timer.Simple(0.1,function() if IsValid(self) then if self.SingleSpawner == true then self:DoSingleSpawnerRemove() end end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_CustomOnThink()
	-- print("disabled = " .. self.VJBaseSpawnerDisabled)
	if self.NZ_Wave <= 3 then
		NZ_WaveEntities = {
			"npc_vj_nz_zombiewalk"
		}
		self.EntitiesToSpawn = {
			{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-100,vUp=5},Entities = NZ_WaveEntities}
		}
	elseif self.NZ_Wave >= 4 && self.NZ_Wave <= 12 then
		NZ_WaveEntities = {
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombiewalk",
			"npc_vj_nz_zombiewalk",
			"npc_vj_nz_zombiewalk"
		}
		self.EntitiesToSpawn = {
			{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC6",SpawnPosition = {vForward=0,vRight=-40,vUp=5},Entities = NZ_WaveEntities}
		}
	elseif self.NZ_Wave >= 13 then
		NZ_WaveEntities = {
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
			"npc_vj_nz_zombie",
			"npc_vj_nz_zombie"
		}
		self.EntitiesToSpawn = {
			{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-40,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC6",SpawnPosition = {vForward=0,vRight=40,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC7",SpawnPosition = {vForward=30,vRight=0,vUp=5},Entities = NZ_WaveEntities},
			{EntityName = "NPC8",SpawnPosition = {vForward=-30,vRight=0,vUp=5},Entities = NZ_WaveEntities}
		}
	end
	if self:NZ_CalculateWaveTarget(self.NZ_Wave) && self.NZ_SwitchingWaves == false then
		self:NZ_SwitchWaves("End")
		timer.Simple(self.NZ_TimeBetweenWaves,function()
			if self:IsValid() then
				self:NZ_SwitchWaves("Begin")
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_SwitchWaves(wavetype)
	if wavetype == "End" then
		self.VJBaseSpawnerDisabled = true
		self.NZ_SwitchingWaves = true
		for _,v in ipairs(player.GetAll()) do
			if v:IsValid() then
				v:ChatPrint("Wave " .. self.NZ_Wave .. " is over.")
			end
		end
		self:NZ_PlayUISound("vj_nz/nz/round/round_end.mp3")
	elseif wavetype == "Begin" then
		self.NZ_Wave = self.NZ_Wave +1
		self.NZ_TotalDeaths = self.NZ_TotalDeaths -self.NZ_TotalDeaths
		self.VJBaseSpawnerDisabled = false
		self.NZ_SwitchingWaves = false
		for _,v in ipairs(player.GetAll()) do
			if v:IsValid() then
				v:ChatPrint("Wave " .. self.NZ_Wave .. " has begun.")
			end
		end
		self:NZ_PlayUISound("vj_nz/nz/round/round_start.mp3")
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_PlayUISound(dir)
	for _,v in ipairs(player.GetAll()) do
		if v:IsValid() then
			_PlayedSound = CreateSound(v,dir)
			_PlayedSound:SetSoundLevel(self.NZ_UISoundLevel)
			_PlayedSound:Play()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()
	self:GetAllPlayers():ChatPrint("Deaths: " .. tostring(self.NZ_TotalDeaths))
	self:GetAllPlayers():ChatPrint("Alive: " .. tostring(#self.NZ_AliveTable))
	self:GetAllPlayers():ChatPrint("Required Frags: " .. tostring(self:NZ_GetCalculatedFrags(self.NZ_Wave)))
	if self.Dead == true then VJ_STOPSOUND(self.CurrentIdleSound) return end
	self:NZ_CustomOnThink()
	if self.VJBaseSpawnerDisabled == true then self.AlreadyDoneVJBaseSpawnerDisabled = false end
	//PrintTable(self.CurrentEntities)
	//print("-----------------------------------------------------------")
	self:CustomOnThink_BeforeAliveChecks()
	self:IdleSoundCode()
	if self.VJBaseSpawnerDisabled == false && self.SingleSpawner == false then
		for k,v in ipairs(self.CurrentEntities) do
			if !IsValid(v.TheEntity) && v.Dead == false /*&& v.NextTimedSpawnT < CurTime()*/ then
				v.Dead = true
				timer.Simple(self.TimedSpawn_Time,function() if IsValid(self) then /*table.remove(self.CurrentEntities,k)*/ self:SpawnAnEntity(k,v,false) end end)
			end
		end
	end
	self:CustomOnThink_AfterAliveChecks()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_OnZombieDeath(v)
	self.NZ_TotalDeaths = self.NZ_TotalDeaths +1
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:NZ_AllDead()
	for k,v in ipairs(self.CurrentEntities) do
		if !IsValid(v.TheEntity) then
			return true
		else
			return false
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnRemove()
	self.Dead = true
	VJ_STOPSOUND(self.CurrentIdleSound)
	self:NZ_PlayUISound(VJ_PICKRANDOMTABLE({"vj_nz/nz/round/game_over_4.mp3","vj_nz/nz/round/game_over_5.mp3"}))
	for _,v in ipairs(player.GetAll()) do
		if v:IsValid() then
			v:ChatPrint("GAME OVER.")
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