AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_da/fast1/prowler_torso.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_TINY

ENT.VJ_NPC_Class = {"CLASS_ABYSSIAN"} -- NPCs with the same class with be allied to each other

ENT.DisableFootStepSoundTimer = true

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"ACT_MELEE_ATTACK1"}
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use any attack again? | Counted in Seconds

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages

	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_da/foot1.wav","vj_da/foot2.wav","vj_da/foot3.wav","vj_da/foot4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_da/claw_strike1.wav","vj_da/claw_strike2.wav","vj_da/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_da/claw_miss1.wav","vj_da/claw_miss2.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:Difficulty()
	if GetConVar("vj_da_allallied"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_DA"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Difficulty()

	if GetConVar("vj_da_difficulty"):GetInt() == 1 then
	
		self.StartHealth = 25
		self.MeleeAttackDamage = math.Rand(2,4)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 2 then
	
		self.StartHealth = 50
		self.MeleeAttackDamage = math.Rand(3,6)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 3 then
	
		self.StartHealth = 100
		self.MeleeAttackDamage = math.Rand(4,8)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 4 then
	
		self.StartHealth = 250
		self.MeleeAttackDamage = math.Rand(8,13)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 5 then
	
		self.StartHealth = 400
		self.MeleeAttackDamage = math.Rand(13,18)
		
	end
			
        self:SetHealth(self.StartHealth)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "step" then
		self:FootStepSoundCode()
	end
	if key == "slide" then
		VJ_EmitSound(self, "vj_da/slide1.wav", 65, math.random(80,100))
	end
	if key == "attack" then
		self:MeleeAttackCode()		
    end		
	if key == "death" then
		VJ_EmitSound(self, "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav", 75, 100)
    end	
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/