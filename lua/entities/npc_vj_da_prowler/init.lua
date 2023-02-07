AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_da/fast1/prowler.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN

ENT.SplitSpawned = false
ENT.NextStrafeT = 0
ENT.NextRunT = 0

ENT.VJ_NPC_Class = {"CLASS_ABYSSIAN"} -- NPCs with the same class with be allied to each other

ENT.DisableFootStepSoundTimer = true 

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something

ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {"leapstrike"} -- Melee Attack Animations
ENT.LeapDistance = 600 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = false -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 0.2 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 500 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 200 -- How much upward force should it apply?
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 10 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"vjseq_flinch_heavy_f"} -- If it uses normal based animation, use this

	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_da/foot1.wav","vj_da/foot2.wav","vj_da/foot3.wav","vj_da/foot4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_da/claw_strike1.wav","vj_da/claw_strike2.wav","vj_da/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_da/claw_miss1.wav","vj_da/claw_miss2.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13,13,50), Vector(-13,-13,0))
	self:Difficulty()
	if GetConVar("vj_da_allallied"):GetInt() == 1 then
		self.VJ_NPC_Class = {"CLASS_DA"}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Difficulty()

	if GetConVar("vj_da_difficulty"):GetInt() == 1 then
	
		self.StartHealth = 50
		self.MeleeAttackDamage = math.Rand(2,4)
		self.LeapAttackDamage = math.Rand(4,6)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 2 then
	
		self.StartHealth = 100
		self.MeleeAttackDamage = math.Rand(3,6)
		self.LeapAttackDamage = math.Rand(6,8)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 3 then
	
		self.StartHealth = 200
		self.MeleeAttackDamage = math.Rand(4,8)
		self.LeapAttackDamage = math.Rand(8,13)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 4 then
	
		self.StartHealth = 350
		self.MeleeAttackDamage = math.Rand(8,13)
		self.LeapAttackDamage = math.Rand(13,18)
		
	elseif GetConVar("vj_da_difficulty"):GetInt() == 5 then
	
		self.StartHealth = 500
		self.MeleeAttackDamage = math.Rand(13,18)
		self.LeapAttackDamage = math.Rand(18,23)
		
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(argent)
    local alert = math.random(1,3)
	if self:GetSequence() == self:LookupSequence("emerge1") then return false end
	if alert == 1 then
		local tbl = VJ_PICK({"vjseq_Idle_Angry"})
		self:VJ_ACT_PLAYACTIVITY(tbl,true,VJ_GetSequenceDuration(self,tbl),false)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer(seed)

    if self:IsMoving()then
	
		self.MeleeAttackAnimationAllowOtherTasks = true
	
		self.AnimTbl_MeleeAttack = {
			"vjges_br2_attack_moving",
		}

	else
	
		self.MeleeAttackAnimationAllowOtherTasks = false
			
		self.AnimTbl_MeleeAttack = {
			"vjseq_melee",
		}
	
		if math.random(1,4) == 1 then
		
			self.AnimTbl_MeleeAttack = {
				"vjseq_br2_attack",
			}
			
		end

	end
	
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/