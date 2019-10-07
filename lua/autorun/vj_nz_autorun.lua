/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Nazi Zombie SNPCs"
local AddonName = "Nazi Zombie"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_nz_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Nazi Zombies"
	VJ.AddNPC("Nazi Zombie","npc_vj_nz_zombie",vCat)
	VJ.AddNPC("(Walking) Nazi Zombie","npc_vj_nz_zombiewalk",vCat)
	VJ.AddNPC("(Running) Nazi Zombie","npc_vj_nz_zombierun",vCat)
	-- VJ.AddNPC("(Crawling) Nazi Zombie","npc_vj_nz_zombiecrawl",vCat) // Crawler has no ragdoll
	-- VJ.AddNPC("Nova Crawler","npc_vj_nz_novacrawler",vCat)
	VJ.AddNPC("Hell Hound","npc_vj_nz_hound",vCat)
	VJ.AddNPC("Random Nazi Zombie","sent_vj_nz_randzombie",vCat)
	VJ.AddNPC("Nazi Zombie Spawner","sent_vj_nz_spawnzombie",vCat)
	VJ.AddNPC("Random Zombie Spawner","sent_vj_nz_randspawner",vCat)
	VJ.AddNPC("(Spawner) Zombie Onslaught","sent_vj_nz_onslaught",vCat)
	VJ.AddNPC("(Spawner) Zombie Waves","sent_vj_nz_wavespawn",vCat) -- Not ready yet
	VJ.AddNPC("Nazi Zombie Soldier","npc_vj_nz_newzombie",vCat)

	-- VJ.AddNPC("(HAMMER) Nazi Zombie","sent_vj_nz_mapspawn",vCat)
	-- VJ.AddNPC("(HAMMER) (Walking) Nazi Zombie","sent_vj_nz_mapspawn_walk",vCat)
	-- VJ.AddNPC("(HAMMER) (Running) Nazi Zombie","sent_vj_nz_mapspawn_run",vCat)
	
	local AddConvars = {}
	AddConvars["vj_nzeyecolor"] = 1
	AddConvars["vj_nzwavetype"] = 1
	for k, v in pairs(AddConvars) do
		if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
	end

	if CLIENT then
	local function VJ_NZMENU_MAIN(Panel)
		if !game.SinglePlayer() then
		if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
			Panel:AddControl( "Label", {Text = "You are not an admin!"})
			Panel:ControlHelp("Notice: Only admins can change this settings")
			return
			end
		end
		Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
		local vj_nzreset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
		vj_nzreset.Options["#vjbase.menugeneral.default"] = { 
		vj_nzeyecolor = "1",
		vj_nzwavetype = "1"
		}
		Panel:AddControl("ComboBox", vj_nzreset)
		local vj_nzeyecolortable = {Options = {}, CVars = {}, Label = "Zombie Eye Color:", MenuButton = "0"}
		vj_nzeyecolortable.Options["#Orange"] = {
			vj_nzeyecolor = "1"
		}
		vj_nzeyecolortable.Options["#Red"] = {
			vj_nzeyecolor = "2"
		}
		vj_nzeyecolortable.Options["#Blue"] = {
			vj_nzeyecolor = "3"
		}
		vj_nzeyecolortable.Options["#Green"] = {
			vj_nzeyecolor = "4"
		}
		Panel:AddControl("ComboBox", vj_nzeyecolortable)
		local vj_nzwavetable = {Options = {}, CVars = {}, Label = "Zombie Behavior:", MenuButton = "0"}
		vj_nzwavetable.Options["#Walk to Run"] = {
			vj_nzwavetype = "1"
		}
		vj_nzwavetable.Options["#Run to Sprint"] = {
			vj_nzwavetype = "2"
		}
		vj_nzwavetable.Options["#Always Sprint"] = {
			vj_nzwavetype = "3"
		}
		Panel:AddControl("ComboBox", vj_nzwavetable)
		Panel:ControlHelp("This if for Nazi Zombies only! Not the walk or run variations.")
	end
	function VJ_ADDTOMENU_NZ()
		spawnmenu.AddToolMenuOption( "DrVrej", "SNPC Configures", "Nazi Zombies", "Nazi Zombies", "", "", VJ_NZMENU_MAIN, {} )
	end
		hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_NZ", VJ_ADDTOMENU_NZ )
	end

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end