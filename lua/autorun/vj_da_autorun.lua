/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "[VJ] Dimensional Anomalies"
local AddonName = "[VJ] Dimensional Anomalies"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_da_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Dimensional Anomalies: Abyssians" 
	--VJ.AddNPC("template","npc_class",vCat)
	VJ.AddNPC("Abyssian Prowler","npc_vj_da_prowler",vCat)
	VJ.AddNPC("Abyssian Prowler Torso","npc_vj_da_prowler_torso",vCat)

	-- Precache Models --
	util.PrecacheModel("models/vj_da/fast1/prowler.mdl")
	util.PrecacheModel("models/vj_da/fast1/prowler_torso.mdl")
	util.PrecacheModel("models/vj_da/fast1/prowler_legs.mdl")


	-- ConVars --
	--VJ.AddConVar("template",30)
	--VJ.AddConVar("template", 1, {FCVAR_ARCHIVE})

	VJ.AddConVar("vj_da_difficulty", 3, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_da_spawneffect", 1, {FCVAR_ARCHIVE})
	VJ.AddConVar("vj_da_allallied", 0, {FCVAR_ARCHIVE})


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