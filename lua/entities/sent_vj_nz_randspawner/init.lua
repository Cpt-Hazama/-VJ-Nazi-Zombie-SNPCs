AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
local targetents = {
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
	"npc_vj_nz_zombie",
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
	"npc_vj_nz_hound",
	"npc_vj_nz_hound",
	"npc_vj_nz_hound"
}
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=5},Entities = targetents},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=5},Entities = targetents},
	{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=5},Entities = targetents},
	{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=5},Entities = targetents},
	{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-100,vUp=5},Entities = targetents}
}


/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/