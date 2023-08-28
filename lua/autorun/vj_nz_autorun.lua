/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2017 by Cpt. Hazama, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "CoD Zombie SNPCs"
local AddonName = "CoD Zombies"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_nz_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "CoD Zombies"
	VJ.AddNPC("Zombie","npc_vj_nz_zombie",vCat)
	VJ.AddNPC("(Walking) Zombie","npc_vj_nz_zombiewalk",vCat)
	VJ.AddNPC("(Running) Zombie","npc_vj_nz_zombierun",vCat)
	-- VJ.AddNPC("Nova Crawler","npc_vj_nz_novacrawler",vCat)
	VJ.AddNPC("Hell Hound","npc_vj_nz_hound",vCat)
	VJ.AddNPC("Random Zombie","sent_vj_nz_randzombie",vCat)
	VJ.AddNPC("Zombie Spawner","sent_vj_nz_spawnzombie",vCat)
	VJ.AddNPC("Random Zombie Spawner","sent_vj_nz_randspawner",vCat)
	VJ.AddNPC("(Auto-Spawner) Onslaught","sent_vj_nz_mutator",vCat)

	VJ_nz_NodegraphExists = VJ_NZ_NodegraphExists or false
	hook.Add("Initialize","VJ_NZ_Initialize",function()
		timer.Simple(3,function()
			local graph = VJ_Nodegraph
			if graph then
				VJ_NZ_NodegraphExists = true
			end
		end)
	end)

	hook.Add("ShouldCollide","VJ_NZCollision",function(ent1,ent2)
		if ent1.VJ_NZ_Zombie and ent2.VJ_NZ_Zombie then return false end
	end)

	if SERVER then
		util.AddNetworkString("NZ_CSound")

		function NZ_CSound(ent,snd)
			net.Start("NZ_CSound")
				net.WriteString(snd)
				net.WriteEntity(ent)
			net.Send(ent)
		end
	else
		net.Receive("NZ_CSound",function(len,pl)
			local sound = net.ReadString()
			local ent = net.ReadEntity()

			ent:EmitSound(sound,0)
			print("Playing sound " .. sound .. " on " .. ent:Nick())
		end)
	end

	VJ.AddConVar("vj_nz_mutator_sndtrk",0,{FCVAR_ARCHIVE},"Play the soundtrack when the mutator is active.")
	VJ.AddConVar("vj_nz_mutator_allowbots",0,{FCVAR_ARCHIVE},"Spawns bots with the mutator.")
	VJ.AddConVar("vj_nz_mutator_maxbots",0,{FCVAR_ARCHIVE},"Max bots to spawn with the mutator. (0 = Auto-Balance)")
	
	local AddConvars = {}
	AddConvars["vj_nz_eyecolor"] = 1
	for k, v in pairs(AddConvars) do
		if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
	end

	if CLIENT then
	local function VJ_NZMENU_MAIN(Panel)
		if !game.SinglePlayer() then
		if !LocalPlayer():IsAdmin() or !LocalPlayer():IsSuperAdmin() then
			Panel:AddControl( "Label", {Text = "You are not an admin!"})
			Panel:ControlHelp("Notice: Only admins can change this settings")
			local vj_nzreset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
			vj_nzreset.Options["#vjbase.menugeneral.default"] = { 
				vj_nz_mutator_sndtrk = "0",
			}
			Panel:AddControl("Checkbox", {Label = "[Auto-Spawner] Enabled Background Music", Command = "vj_nz_mutator_sndtrk"})
			return
			end
		end
		Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
		local vj_nzreset = {Options = {}, CVars = {}, Label = "Reset Everything:", MenuButton = "0"}
		vj_nzreset.Options["#vjbase.menugeneral.default"] = { 
			vj_nz_eyecolor = "1",
			vj_nz_mutator_sndtrk = "0",
			vj_nz_mutator_allowbots = "0",
			vj_nz_mutator_maxbots = "0",
		}
		Panel:AddControl("ComboBox", vj_nzreset)
		local vj_nz_eyecolortable = {Options = {}, CVars = {}, Label = "Zombie Eye Color:", MenuButton = "0"}
		vj_nz_eyecolortable.Options["#Orange"] = {
			vj_nz_eyecolor = "1"
		}
		vj_nz_eyecolortable.Options["#Red"] = {
			vj_nz_eyecolor = "2"
		}
		vj_nz_eyecolortable.Options["#Blue"] = {
			vj_nz_eyecolor = "3"
		}
		vj_nz_eyecolortable.Options["#Green"] = {
			vj_nz_eyecolor = "4"
		}
		Panel:AddControl("ComboBox", vj_nz_eyecolortable)
		Panel:AddControl("Checkbox", {Label = "[Auto-Spawner] Enable Background Music", Command = "vj_nz_mutator_sndtrk"})
		Panel:AddControl("Checkbox", {Label = "[Auto-Spawner] Enable Player Bots", Command = "vj_nz_mutator_allowbots"})
		Panel:AddControl("Slider", {Label = "[Auto-Spawner] Max Player Bots", min = 0, max = 16, Command = "vj_nz_mutator_maxbots"})
	end
	function VJ_ADDTOMENU_NZ()
		spawnmenu.AddToolMenuOption( "DrVrej", "SNPC Configures", "Zombies", "Zombies", "", "", VJ_NZMENU_MAIN, {} )
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