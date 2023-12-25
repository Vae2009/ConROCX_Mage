local printTalentsMode = false

-- Slash command for printing talent tree with talent names and ID numbers
SLASH_CONROCPRINTTALENTS1 = "/ConROCPT"
SlashCmdList["CONROCPRINTTALENTS"] = function()
    printTalentsMode = not printTalentsMode
    ConROC:PopulateTalentIDs()
end

ConROC.Mage = {};

local ConROC_Mage, ids = ...;
local optionMaxIds = ...;
local currentSpecName

function ConROC:EnableDefenseModule()
	self.NextDef = ConROC.Mage.Defense;
end

function ConROC:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
	
	ConROC:JustFrostbolted(spellID);
	ConROC:JustScorched(spellID);
	ConROC:JustFlamestriked(spellID);
end

function ConROC:PopulateTalentIDs()
    local numTabs = GetNumTalentTabs()
    
    for tabIndex = 1, numTabs do
        local tabName = GetTalentTabInfo(tabIndex) .. "_Talent"
        tabName = string.gsub(tabName, "%s", "") -- Remove spaces from tab name
        if printTalentsMode then
        	print(tabName..": ")
        else
        	ids[tabName] = {}
    	end
        
        local numTalents = GetNumTalents(tabIndex)

        for talentIndex = 1, numTalents do
            local name, _, _, _, _ = GetTalentInfo(tabIndex, talentIndex)

            if name then
                local talentID = string.gsub(name, "%s", "") -- Remove spaces from talent name
                if printTalentsMode then
                	print(talentID .." = ID no: ", talentIndex)
                else
                	ids[tabName][talentID] = talentIndex
                end
            end
        end
    end
    if printTalentsMode then printTalentsMode = false end
end
ConROC:PopulateTalentIDs()

local Racial, Spec, Caster, Arc_Ability, Arc_Talent, Fire_Ability, Fire_Talent, Frost_Ability, Frost_Talent, Player_Buff, Player_Debuff, Target_Debuff = ids.Racial, ids.Spec, ids.Caster, ids.Arc_Ability, ids.Arcane_Talent, ids.Fire_Ability, ids.Fire_Talent, ids.Frost_Ability, ids.Frost_Talent, ids.Player_Buff, ids.Player_Debuff, ids.Target_Debuff;
function ConROC:SpecUpdate()
	currentSpecName = ConROC:currentSpec()

	if currentSpecName then
	   ConROC:Print(self.Colors.Info .. "Current spec:", self.Colors.Success ..  currentSpecName)
	else
	   ConROC:Print(self.Colors.Error .. "You do not currently have a spec.")
	end
end
ConROC:SpecUpdate()
--Ranks
--Arcane
local _Evocation = Arc_Ability.Evocation;
local _PresenceofMind = Arc_Ability.PresenceofMind;
local _ArcanePower = Arc_Ability.ArcanePower;
local _AmplifyMagic = Arc_Ability.AmplifyMagicRank1;
local _ArcaneBlast = Arc_Ability.ArcaneBlastRank1;
local _ArcaneBrilliance = Arc_Ability.ArcaneBrillianceRank1;
local _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank1;
local _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank1;
local _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank1;
local _DampenMagic = Arc_Ability.DampenMagicRank1;
local _MageArmor = Arc_Ability.MageArmorRank1;
local _ManaShield = Arc_Ability.ManaShieldRank1;
local _MirrorImage = Arc_Ability.MirrorImage;
--Fire
local _BlastWave = Fire_Ability.BlastWaveRank1;
local _Combustion = Fire_Ability.Combustion;
local _DragonsBreath = Fire_Ability.DragonsBreathRank1;
local _FireBlast = Fire_Ability.FireBlastRank1;
local _FireWard = Fire_Ability.FireWardRank1;
local _Fireball = Fire_Ability.FireballRank1;
local _Flamestrike = Fire_Ability.FlamestrikeRank1;
local _FlamestrikeDR = Fire_Ability.FlamestrikeRank1;
local _FrostFireBolt = Fire_Ability.FrostFireBoltRank1;
local _LivingBomb = Fire_Ability.LivingBombRank1;
local _MoltenArmor = Fire_Ability.MoltenArmorRank1;
local _Pyroblast = Fire_Ability.PyroblastRank1;
local _Scorch = Fire_Ability.ScorchRank1;
--Frost	
local _Blizzard = Frost_Ability.BlizzardRank1;
local _ConeofCold = Frost_Ability.ConeofColdRank1;
local _DeepFreeze = Frost_Ability.DeepFreeze;
local _IceBarrier = Frost_Ability.IceBarrierRank1;
local _IceArmor = Frost_Ability.FrostArmorRank1;
local _IcyVeins = Frost_Ability.IcyVeins;
local _FrostNova = Frost_Ability.FrostNovaRank1;	
local _FrostWard = Frost_Ability.FrostWardRank1;
local _Frostbolt = Frost_Ability.FrostboltRank1;

local wChillEXP = 0;
local fVulEXP = 0;
local fStrikeEXP = 0;

function ConROC:UpdateSpellID()
--Ranks
if IsSpellKnown(Arc_Ability.AmplifyMagicRank6) then _AmplifyMagic = Arc_Ability.AmplifyMagicRank6;
elseif IsSpellKnown(Arc_Ability.AmplifyMagicRank5) then _AmplifyMagic = Arc_Ability.AmplifyMagicRank5;
elseif IsSpellKnown(Arc_Ability.AmplifyMagicRank4) then _AmplifyMagic = Arc_Ability.AmplifyMagicRank4;
elseif IsSpellKnown(Arc_Ability.AmplifyMagicRank3) then _AmplifyMagic = Arc_Ability.AmplifyMagicRank3;
elseif IsSpellKnown(Arc_Ability.AmplifyMagicRank2) then _AmplifyMagic = Arc_Ability.AmplifyMagicRank2; end

if IsSpellKnown(Arc_Ability.ArcaneBlastRank4) then _ArcaneBlast = Arc_Ability.ArcaneBlastRank4;
elseif IsSpellKnown(Arc_Ability.ArcaneBlastRank3) then _ArcaneBlast = Arc_Ability.ArcaneBlastRank3;
elseif IsSpellKnown(Arc_Ability.ArcaneBlastRank2) then _ArcaneBlast = Arc_Ability.ArcaneBlastRank2; end

if IsSpellKnown(Arc_Ability.ArcaneBrillianceRank2) then _ArcaneBrilliance = Arc_Ability.ArcaneBrillianceRank2; end

if IsSpellKnown(Arc_Ability.ArcaneExplosionRank8) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank8;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank7) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank7;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank6) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank6;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank5) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank5;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank4) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank4;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank3) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank3;
elseif IsSpellKnown(Arc_Ability.ArcaneExplosionRank2) then _ArcaneExplosion = Arc_Ability.ArcaneExplosionRank2; end

if IsSpellKnown(Arc_Ability.ArcaneIntellectRank6) then _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank6;
elseif IsSpellKnown(Arc_Ability.ArcaneIntellectRank5) then _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank5;
elseif IsSpellKnown(Arc_Ability.ArcaneIntellectRank4) then _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank4;
elseif IsSpellKnown(Arc_Ability.ArcaneIntellectRank3) then _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank3;
elseif IsSpellKnown(Arc_Ability.ArcaneIntellectRank2) then _ArcaneIntellect = Arc_Ability.ArcaneIntellectRank2; end

if IsSpellKnown(Arc_Ability.ArcaneMissilesRank13) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank13;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank12) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank12;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank11) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank11;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank10) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank10;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank9) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank9;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank8) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank8;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank7) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank7;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank6) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank6;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank5) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank5;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank4) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank4;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank3) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank3;
elseif IsSpellKnown(Arc_Ability.ArcaneMissilesRank2) then _ArcaneMissiles = Arc_Ability.ArcaneMissilesRank2; end

if IsSpellKnown(Arc_Ability.DampenMagicRank6) then _DampenMagic = Arc_Ability.DampenMagicRank6;
elseif IsSpellKnown(Arc_Ability.DampenMagicRank5) then _DampenMagic = Arc_Ability.DampenMagicRank5;
elseif IsSpellKnown(Arc_Ability.DampenMagicRank4) then _DampenMagic = Arc_Ability.DampenMagicRank4;
elseif IsSpellKnown(Arc_Ability.DampenMagicRank3) then _DampenMagic = Arc_Ability.DampenMagicRank3;
elseif IsSpellKnown(Arc_Ability.DampenMagicRank2) then _DampenMagic = Arc_Ability.DampenMagicRank2; end	

if IsSpellKnown(Fire_Ability.BlastWaveRank7) then _BlastWave = Fire_Ability.BlastWaveRank7;
elseif IsSpellKnown(Fire_Ability.BlastWaveRank6) then _BlastWave = Fire_Ability.BlastWaveRank6;
elseif IsSpellKnown(Fire_Ability.BlastWaveRank5) then _BlastWave = Fire_Ability.BlastWaveRank5;
elseif IsSpellKnown(Fire_Ability.BlastWaveRank4) then _BlastWave = Fire_Ability.BlastWaveRank4;
elseif IsSpellKnown(Fire_Ability.BlastWaveRank3) then _BlastWave = Fire_Ability.BlastWaveRank3;
elseif IsSpellKnown(Fire_Ability.BlastWaveRank2) then _BlastWave = Fire_Ability.BlastWaveRank2; end

if IsSpellKnown(Fire_Ability.DragonsBreathRank6) then _DragonsBreath = Fire_Ability.DragonsBreathRank6;
elseif IsSpellKnown(Fire_Ability.DragonsBreathRank5) then _DragonsBreath = Fire_Ability.DragonsBreathRank5;
elseif IsSpellKnown(Fire_Ability.DragonsBreathRank4) then _DragonsBreath = Fire_Ability.DragonsBreathRank4;
elseif IsSpellKnown(Fire_Ability.DragonsBreathRank3) then _DragonsBreath = Fire_Ability.DragonsBreathRank3;
elseif IsSpellKnown(Fire_Ability.DragonsBreathRank2) then _DragonsBreath = Fire_Ability.DragonsBreathRank2; end

if IsSpellKnown(Fire_Ability.FireBlastRank11) then _FireBlast = Fire_Ability.FireBlastRank11;
elseif IsSpellKnown(Fire_Ability.FireBlastRank10) then _FireBlast = Fire_Ability.FireBlastRank10;
elseif IsSpellKnown(Fire_Ability.FireBlastRank9) then _FireBlast = Fire_Ability.FireBlastRank9;
elseif IsSpellKnown(Fire_Ability.FireBlastRank8) then _FireBlast = Fire_Ability.FireBlastRank8;
elseif IsSpellKnown(Fire_Ability.FireBlastRank7) then _FireBlast = Fire_Ability.FireBlastRank7;
elseif IsSpellKnown(Fire_Ability.FireBlastRank6) then _FireBlast = Fire_Ability.FireBlastRank6;
elseif IsSpellKnown(Fire_Ability.FireBlastRank5) then _FireBlast = Fire_Ability.FireBlastRank5;
elseif IsSpellKnown(Fire_Ability.FireBlastRank4) then _FireBlast = Fire_Ability.FireBlastRank4;
elseif IsSpellKnown(Fire_Ability.FireBlastRank3) then _FireBlast = Fire_Ability.FireBlastRank3;
elseif IsSpellKnown(Fire_Ability.FireBlastRank2) then _FireBlast = Fire_Ability.FireBlastRank2; end

if IsSpellKnown(Fire_Ability.FireWardRank7) then _FireWard = Fire_Ability.FireWardRank7;
elseif IsSpellKnown(Fire_Ability.FireWardRank6) then _FireWard = Fire_Ability.FireWardRank6;
elseif IsSpellKnown(Fire_Ability.FireWardRank5) then _FireWard = Fire_Ability.FireWardRank5;
elseif IsSpellKnown(Fire_Ability.FireWardRank4) then _FireWard = Fire_Ability.FireWardRank4;
elseif IsSpellKnown(Fire_Ability.FireWardRank3) then _FireWard = Fire_Ability.FireWardRank3;
elseif IsSpellKnown(Fire_Ability.FireWardRank2) then _FireWard = Fire_Ability.FireWardRank2; end

if IsSpellKnown(Fire_Ability.FireballRank16) then _Fireball = Fire_Ability.FireballRank16;
elseif IsSpellKnown(Fire_Ability.FireballRank15) then _Fireball = Fire_Ability.FireballRank15;
elseif IsSpellKnown(Fire_Ability.FireballRank14) then _Fireball = Fire_Ability.FireballRank14;
elseif IsSpellKnown(Fire_Ability.FireballRank13) then _Fireball = Fire_Ability.FireballRank13;
elseif IsSpellKnown(Fire_Ability.FireballRank12) then _Fireball = Fire_Ability.FireballRank12;
elseif IsSpellKnown(Fire_Ability.FireballRank11) then _Fireball = Fire_Ability.FireballRank11;
elseif IsSpellKnown(Fire_Ability.FireballRank10) then _Fireball = Fire_Ability.FireballRank10;
elseif IsSpellKnown(Fire_Ability.FireballRank9) then _Fireball = Fire_Ability.FireballRank8;
elseif IsSpellKnown(Fire_Ability.FireballRank8) then _Fireball = Fire_Ability.FireballRank9;
elseif IsSpellKnown(Fire_Ability.FireballRank7) then _Fireball = Fire_Ability.FireballRank7;	
elseif IsSpellKnown(Fire_Ability.FireballRank6) then _Fireball = Fire_Ability.FireballRank6;
elseif IsSpellKnown(Fire_Ability.FireballRank5) then _Fireball = Fire_Ability.FireballRank5;
elseif IsSpellKnown(Fire_Ability.FireballRank4) then _Fireball = Fire_Ability.FireballRank4;
elseif IsSpellKnown(Fire_Ability.FireballRank3) then _Fireball = Fire_Ability.FireballRank3;
elseif IsSpellKnown(Fire_Ability.FireballRank2) then _Fireball = Fire_Ability.FireballRank2; end

if IsSpellKnown(Fire_Ability.FlamestrikeRank9) then _Flamestrike = Fire_Ability.FlamestrikeRank9;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank8) then _Flamestrike = Fire_Ability.FlamestrikeRank8;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank7) then _Flamestrike = Fire_Ability.FlamestrikeRank7;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank6) then _Flamestrike = Fire_Ability.FlamestrikeRank6;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank5) then _Flamestrike = Fire_Ability.FlamestrikeRank5;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank4) then _Flamestrike = Fire_Ability.FlamestrikeRank4;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank3) then _Flamestrike = Fire_Ability.FlamestrikeRank3;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank2) then _Flamestrike = Fire_Ability.FlamestrikeRank2; end

--down ranked Flamestrike
if IsSpellKnown(Fire_Ability.FlamestrikeRank9) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank8;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank8) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank7;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank7) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank6;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank6) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank5;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank5) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank4;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank4) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank3;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank3) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank2;
elseif IsSpellKnown(Fire_Ability.FlamestrikeRank2) then _FlamestrikeDR = Fire_Ability.FlamestrikeRank1; end


if IsSpellKnown(Fire_Ability.FrostFireBoltRank2) then _FrostFireBolt = Fire_Ability.FrostFireBoltRank2; end

if IsSpellKnown(Fire_Ability.LivingBombRank3) then _LivingBomb = Fire_Ability.LivingBombRank3;
elseif IsSpellKnown(Fire_Ability.LivingBombRank2) then _LivingBomb = Fire_Ability.LivingBombRank2; end

if IsSpellKnown(Fire_Ability.MoltenArmorRank3) then _MoltenArmor = Fire_Ability.MoltenArmorRank3;
elseif IsSpellKnown(Fire_Ability.MoltenArmorRank2) then _MoltenArmor = Fire_Ability.MoltenArmorRank2; end

if IsSpellKnown(Fire_Ability.PyroblastRank12) then _Pyroblast = Fire_Ability.PyroblastRank12;
elseif IsSpellKnown(Fire_Ability.PyroblastRank11) then _Pyroblast = Fire_Ability.PyroblastRank11;
elseif IsSpellKnown(Fire_Ability.PyroblastRank10) then _Pyroblast = Fire_Ability.PyroblastRank10;
elseif IsSpellKnown(Fire_Ability.PyroblastRank9) then _Pyroblast = Fire_Ability.PyroblastRank9;
elseif IsSpellKnown(Fire_Ability.PyroblastRank8) then _Pyroblast = Fire_Ability.PyroblastRank8;
elseif IsSpellKnown(Fire_Ability.PyroblastRank7) then _Pyroblast = Fire_Ability.PyroblastRank7;
elseif IsSpellKnown(Fire_Ability.PyroblastRank6) then _Pyroblast = Fire_Ability.PyroblastRank6;
elseif IsSpellKnown(Fire_Ability.PyroblastRank5) then _Pyroblast = Fire_Ability.PyroblastRank5;
elseif IsSpellKnown(Fire_Ability.PyroblastRank4) then _Pyroblast = Fire_Ability.PyroblastRank4;
elseif IsSpellKnown(Fire_Ability.PyroblastRank3) then _Pyroblast = Fire_Ability.PyroblastRank3;
elseif IsSpellKnown(Fire_Ability.PyroblastRank2) then _Pyroblast = Fire_Ability.PyroblastRank2; end

if IsSpellKnown(Fire_Ability.ScorchRank11) then _Scorch = Fire_Ability.ScorchRank11;
elseif IsSpellKnown(Fire_Ability.ScorchRank10) then _Scorch = Fire_Ability.ScorchRank10;
elseif IsSpellKnown(Fire_Ability.ScorchRank9) then _Scorch = Fire_Ability.ScorchRank9;
elseif IsSpellKnown(Fire_Ability.ScorchRank8) then _Scorch = Fire_Ability.ScorchRank8;
elseif IsSpellKnown(Fire_Ability.ScorchRank7) then _Scorch = Fire_Ability.ScorchRank7;
elseif IsSpellKnown(Fire_Ability.ScorchRank6) then _Scorch = Fire_Ability.ScorchRank6;
elseif IsSpellKnown(Fire_Ability.ScorchRank5) then _Scorch = Fire_Ability.ScorchRank5;
elseif IsSpellKnown(Fire_Ability.ScorchRank4) then _Scorch = Fire_Ability.ScorchRank4;
elseif IsSpellKnown(Fire_Ability.ScorchRank3) then _Scorch = Fire_Ability.ScorchRank3;
elseif IsSpellKnown(Fire_Ability.ScorchRank2) then _Scorch = Fire_Ability.ScorchRank2; end

if IsSpellKnown(Frost_Ability.BlizzardRank9) then _Blizzard = Frost_Ability.BlizzardRank9;
elseif IsSpellKnown(Frost_Ability.BlizzardRank8) then _Blizzard = Frost_Ability.BlizzardRank8;
elseif IsSpellKnown(Frost_Ability.BlizzardRank7) then _Blizzard = Frost_Ability.BlizzardRank7;
elseif IsSpellKnown(Frost_Ability.BlizzardRank6) then _Blizzard = Frost_Ability.BlizzardRank6;
elseif IsSpellKnown(Frost_Ability.BlizzardRank5) then _Blizzard = Frost_Ability.BlizzardRank5;
elseif IsSpellKnown(Frost_Ability.BlizzardRank4) then _Blizzard = Frost_Ability.BlizzardRank4;
elseif IsSpellKnown(Frost_Ability.BlizzardRank3) then _Blizzard = Frost_Ability.BlizzardRank3;
elseif IsSpellKnown(Frost_Ability.BlizzardRank2) then _Blizzard = Frost_Ability.BlizzardRank2; end

if IsSpellKnown(Frost_Ability.ConeofColdRank8) then _ConeofCold = Frost_Ability.ConeofColdRank8;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank7) then _ConeofCold = Frost_Ability.ConeofColdRank7;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank6) then _ConeofCold = Frost_Ability.ConeofColdRank6;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank5) then _ConeofCold = Frost_Ability.ConeofColdRank5;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank4) then _ConeofCold = Frost_Ability.ConeofColdRank4;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank3) then _ConeofCold = Frost_Ability.ConeofColdRank3;
elseif IsSpellKnown(Frost_Ability.ConeofColdRank2) then _ConeofCold = Frost_Ability.ConeofColdRank2; end

if IsSpellKnown(Frost_Ability.FrostWardRank7) then _FrostWard = Frost_Ability.FrostWardRank7;
elseif IsSpellKnown(Frost_Ability.FrostWardRank6) then _FrostWard = Frost_Ability.FrostWardRank6;
elseif IsSpellKnown(Frost_Ability.FrostWardRank5) then _FrostWard = Frost_Ability.FrostWardRank5;
elseif IsSpellKnown(Frost_Ability.FrostWardRank4) then _FrostWard = Frost_Ability.FrostWardRank4;
elseif IsSpellKnown(Frost_Ability.FrostWardRank3) then _FrostWard = Frost_Ability.FrostWardRank3;
elseif IsSpellKnown(Frost_Ability.FrostWardRank2) then _FrostWard = Frost_Ability.FrostWardRank2; end

if IsSpellKnown(Frost_Ability.FrostboltRank16) then _Frostbolt = Frost_Ability.FrostboltRank16;
elseif IsSpellKnown(Frost_Ability.FrostboltRank15) then _Frostbolt = Frost_Ability.FrostboltRank15;
elseif IsSpellKnown(Frost_Ability.FrostboltRank14) then _Frostbolt = Frost_Ability.FrostboltRank14;
elseif IsSpellKnown(Frost_Ability.FrostboltRank13) then _Frostbolt = Frost_Ability.FrostboltRank13;
elseif IsSpellKnown(Frost_Ability.FrostboltRank12) then _Frostbolt = Frost_Ability.FrostboltRank12;
elseif IsSpellKnown(Frost_Ability.FrostboltRank11) then _Frostbolt = Frost_Ability.FrostboltRank11;
elseif IsSpellKnown(Frost_Ability.FrostboltRank10) then _Frostbolt = Frost_Ability.FrostboltRank10;
elseif IsSpellKnown(Frost_Ability.FrostboltRank9) then _Frostbolt = Frost_Ability.FrostboltRank9;
elseif IsSpellKnown(Frost_Ability.FrostboltRank8) then _Frostbolt = Frost_Ability.FrostboltRank8;
elseif IsSpellKnown(Frost_Ability.FrostboltRank7) then _Frostbolt = Frost_Ability.FrostboltRank7;	
elseif IsSpellKnown(Frost_Ability.FrostboltRank6) then _Frostbolt = Frost_Ability.FrostboltRank6;
elseif IsSpellKnown(Frost_Ability.FrostboltRank5) then _Frostbolt = Frost_Ability.FrostboltRank5;
elseif IsSpellKnown(Frost_Ability.FrostboltRank4) then _Frostbolt = Frost_Ability.FrostboltRank4;
elseif IsSpellKnown(Frost_Ability.FrostboltRank3) then _Frostbolt = Frost_Ability.FrostboltRank3;
elseif IsSpellKnown(Frost_Ability.FrostboltRank2) then _Frostbolt = Frost_Ability.FrostboltRank2; end

--Ranks Defensive
if IsSpellKnown(Arc_Ability.MageArmorRank4) then _MageArmor = Arc_Ability.MageArmorRank4;
elseif IsSpellKnown(Arc_Ability.MageArmorRank3) then _MageArmor = Arc_Ability.MageArmorRank3;
elseif IsSpellKnown(Arc_Ability.MageArmorRank2) then _MageArmor = Arc_Ability.MageArmorRank2; end

if IsSpellKnown(Arc_Ability.ManaShieldRank7) then _ManaShield = Arc_Ability.ManaShieldRank7;
elseif IsSpellKnown(Arc_Ability.ManaShieldRank6) then _ManaShield = Arc_Ability.ManaShieldRank6;
elseif IsSpellKnown(Arc_Ability.ManaShieldRank5) then _ManaShield = Arc_Ability.ManaShieldRank5;
elseif IsSpellKnown(Arc_Ability.ManaShieldRank4) then _ManaShield = Arc_Ability.ManaShieldRank4;
elseif IsSpellKnown(Arc_Ability.ManaShieldRank3) then _ManaShield = Arc_Ability.ManaShieldRank3;
elseif IsSpellKnown(Arc_Ability.ManaShieldRank2) then _ManaShield = Arc_Ability.ManaShieldRank2; end

if IsSpellKnown(Fire_Ability.MoltenArmorRank1) then _MoltenArmor = Fire_Ability.MoltenArmorRank1; end

if IsSpellKnown(Frost_Ability.IceBarrierRank8) then _IceBarrier = Frost_Ability.IceBarrierRank8;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank7) then _IceBarrier = Frost_Ability.IceBarrierRank7;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank6) then _IceBarrier = Frost_Ability.IceBarrierRank6;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank5) then _IceBarrier = Frost_Ability.IceBarrierRank5;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank4) then _IceBarrier = Frost_Ability.IceBarrierRank4;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank3) then _IceBarrier = Frost_Ability.IceBarrierRank3;
elseif IsSpellKnown(Frost_Ability.IceBarrierRank2) then _IceBarrier = Frost_Ability.IceBarrierRank2; end

if IsSpellKnown(Frost_Ability.IceArmorRank5) then _IceArmor = Frost_Ability.IceArmorRank5;
elseif IsSpellKnown(Frost_Ability.IceArmorRank4) then _IceArmor = Frost_Ability.IceArmorRank4;
elseif IsSpellKnown(Frost_Ability.IceArmorRank3) then _IceArmor = Frost_Ability.IceArmorRank3;
elseif IsSpellKnown(Frost_Ability.IceArmorRank2) then _IceArmor = Frost_Ability.IceArmorRank2;
elseif IsSpellKnown(Frost_Ability.IceArmorRank1) then _IceArmor = Frost_Ability.IceArmorRank1;	
elseif IsSpellKnown(Frost_Ability.FrostArmorRank3) then _IceArmor = Frost_Ability.FrostArmorRank3;
elseif IsSpellKnown(Frost_Ability.FrostArmorRank2) then _IceArmor = Frost_Ability.FrostArmorRank2; end

if IsSpellKnown(Frost_Ability.FrostNovaRank5) then _FrostNova = Frost_Ability.FrostNovaRank5;
elseif IsSpellKnown(Frost_Ability.FrostNovaRank4) then _FrostNova = Frost_Ability.FrostNovaRank4;
elseif IsSpellKnown(Frost_Ability.FrostNovaRank3) then _FrostNova = Frost_Ability.FrostNovaRank3;
elseif IsSpellKnown(Frost_Ability.FrostNovaRank2) then _FrostNova = Frost_Ability.FrostNovaRank2; end

ids.optionMaxIds = {
--Arcane
Evocation = _Evocation,
PresenceofMind = _PresenceofMind,
ArcanePower = _ArcanePower,
AmplifyMagic = _AmplifyMagic,
ArcaneBlast = _ArcaneBlast,
ArcaneBrilliance = _ArcaneBrilliance,
ArcaneExplosion = _ArcaneExplosion,
ArcaneIntellect = _ArcaneIntellect,
ArcaneMissiles = _ArcaneMissiles,
DampenMagic = _DampenMagic,
MirrorImage = _MirrorImage,
MageArmor = _MageArmor,
--Fire
BlastWave = _BlastWave,
Combustion = _Combustion,
DragonsBreath = _DragonsBreath, 
FireBlast =_FireBlast,
FireWard =_FireWard,
Fireball = _Fireball,
Flamestrike = _Flamestrike,
FlamestrikeDR = _FlamestrikeDR,
FrostFireBolt =_FrostFireBolt,
LivingBomb = _LivingBomb,
MoltenArmor = _MoltenArmor,
Pyroblast =_Pyroblast,
Scorch =_Scorch,
--Frost
Blizzard = _Blizzard,
ConeofCold = _ConeofCold,
DeepFreeze = _DeepFreeze,
Frostbolt = _Frostbolt,
FrostFireBolt = _FrostFireBolt,
IceBarrier = _IceBarrier,
IceArmor = _IceArmor,
IcyVeins = _IcyVeins,
FrostNova = _FrostNova,
FrostWard = _FrostWard
}
end
ConROC:UpdateSpellID()

function ConROC:EnableRotationModule()
	self.Description = "Mage";
	self.NextSpell = ConROC.Mage.Damage;

	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self:RegisterEvent("PLAYER_TALENT_UPDATE");
	self.lastSpellId = 0;
	
	ConROC:SpellmenuClass();	
end
function ConROC:PLAYER_TALENT_UPDATE()
	ConROC:SpecUpdate();
    ConROC:closeSpellmenu();
end

function ConROC.Mage.Damage(_, timeShift, currentSpell, gcd)
ConROC:UpdateSpellID()
--Character
	local plvl	= UnitLevel('player');
--Racials

--Resources
	local mana = UnitPower('player', Enum.PowerType.Mana);
	local manaMax = UnitPowerMax('player', Enum.PowerType.Mana);
	local manaPercent = math.max(0, mana) / math.max(1, manaMax) * 100;


--Abilties	
	local ampMagRDY	= ConROC:AbilityReady(_AmplifyMagic, timeShift);
		local ampMagBUFF = ConROC:Buff(_AmplifyMagic, timeShift);
	local aBlastRDY = ConROC:AbilityReady(_ArcaneBlast, timeShift);
		local aBlastDEBUFF, aBlastCount = ConROC:TargetDebuff(Target_Debuff.ArcaneBlast);
	local aExpRDY = ConROC:AbilityReady(_ArcaneExplosion, timeShift);
	local aIntRDY = ConROC:AbilityReady(_ArcaneIntellect, timeShift);
		local aIntBUFF = ConROC:Buff(_ArcaneIntellect, timeShift);
		local aBriBUFF = ConROC:Buff(_ArcaneBrilliance, timeShift);
	local aMissRDY = ConROC:AbilityReady(_ArcaneMissiles, timeShift);
		local aMissBUFF = ConROC:Buff(Player_Buff.MissileBarrage, timeShift);
	local aPowerRDY = ConROC:AbilityReady(_ArcanePower, timeShift);
	local blinkRDY = ConROC:AbilityReady(Arc_Ability.Blink, timeShift);
	local conAgateRDY = ConROC:AbilityReady(Arc_Ability.ConjureManaAgate, timeShift);
	local conJadeRDY = ConROC:AbilityReady(Arc_Ability.ConjureManaJade, timeShift);
	local conCitRDY = ConROC:AbilityReady(Arc_Ability.ConjureManaCitrine, timeShift);
	local conRubyRDY = ConROC:AbilityReady(Arc_Ability.ConjureManaRuby, timeShift);
	local cSpellRDY = ConROC:AbilityReady(Arc_Ability.Counterspell, timeShift);
	local dampenMagRDY = ConROC:AbilityReady(_DampenMagic, timeShift);
		local dampenMagBUFF = ConROC:Buff(_DampenMagic, timeShift);
	local evoRDY = ConROC:AbilityReady(_Evocation, timeShift);
	local mirrRDY = ConROC:AbilityReady(_MirrorImage, timeShift);
	local pomRDY = ConROC:AbilityReady(_PresenceofMind, timeShift);
		local pomBUFF = ConROC:Buff(_PresenceofMind, timeShift);
	local bWaveRDY = ConROC:AbilityReady(_BlastWave, timeShift);
	local combRDY = ConROC:AbilityReady(_Combustion, timeShift);
	local dBreathRDY = ConROC:AbilityReady(_DragonsBreath, timeShift);
	local fBlastRDY = ConROC:AbilityReady(_FireBlast, timeShift);
	local fBallRDY = ConROC:AbilityReady(_Fireball, timeShift);
		local fBallDEBUFF = ConROC:TargetDebuff(_Fireball, timeShift);
	local lBombRDY = ConROC:AbilityReady(_LivingBomb, timeShift);
		local lBombDEBUFF = ConROC:TargetDebuff(_LivingBomb, timeShift);
	local fStrikeRDY = ConROC:AbilityReady(_Flamestrike, timeShift);
		local fStrikeDUR = fStrikeEXP - GetTime();
	local pBlastRDY = ConROC:AbilityReady(_Pyroblast, timeShift);
	local scorRDY = ConROC:AbilityReady(_Scorch, timeShift);
	local blizRDY = ConROC:AbilityReady(_Blizzard, timeShift);
	local dFreezeRDY = ConROC:AbilityReady(_DeepFreeze, timeShift);
	local cSnapRDY = ConROC:AbilityReady(Frost_Ability.ColdSnap, timeShift);
	local cofcRDY = ConROC:AbilityReady(_ConeofCold, timeShift);
	local frBoltRDY = ConROC:AbilityReady(_Frostbolt, timeShift);
		local frBoltDEBUFF = ConROC:TargetDebuff(_Frostbolt, timeShift);
	local ffBoltRDY = ConROC:AbilityReady(_FrostFireBolt, timeShift);
	local icyVeinsRDY = ConROC:AbilityReady(_IcyVeins, timeShift);
		local icyVeinsBUFF = ConROC:Buff(_IcyVeins, timeShift);
	
	local chillDEBUFF = ConROC:TargetDebuff(Target_Debuff.Chilled, timeShift);
	local wChillDEBUFF, wChillCount = ConROC:TargetDebuff(Target_Debuff.WintersChill);
	local wChillDUR = wChillEXP - GetTime();
	local fVulDEBUFF, fVulCount = ConROC:TargetDebuff(Target_Debuff.FireVulnerability);
	local fVulDUR = fVulEXP - GetTime();
	local frNovaDEBUFF = ConROC:TargetDebuff(_FrostNova);
	local foFrostBUFF = ConROC:Buff(Player_Buff.FingersofFrost);
	local fireballBUFF = ConROC:Buff(Player_Buff.Fireball);
	local FirestarterBUFF = ConROC:Buff(Player_Buff.Firestarter);
	local HStreakBUFF = ConROC:Buff(Player_Buff.HotStreak);
		
	--local _, impArcPoints = ConROC:TalentChosen(Spec.Arcane, Arc_Talent.ImprovedArcaneMissiles)
	
--Conditions
	local inMelee = CheckInteractDistance("target", 3);		
	local targetPh = ConROC:PercentHealth('target');		
	local hasWand = HasWandEquipped();
	local incombat = UnitAffectingCombat('player');
    local resting = IsResting();
    local mounted = IsMounted();
    local onVehicle = UnitHasVehicleUI("player");
    local moving = ConROC:PlayerSpeed();
	
    if onVehicle then
        return nil
    end
--Indicators	
	ConROC:AbilityBurst(_Evocation, evoRDY and manaPercent <= 25);
	ConROC:AbilityBurst(_PresenceofMind, pomRDY and incombat);
	ConROC:AbilityBurst(_ArcanePower, aPowerRDY and incombat and (not ConROC:TalentChosen(Spec.Frost, Frost_Talent.WintersChill) or (ConROC:TalentChosen(Spec.Frost, Frost_Talent.WintersChill) and wChillCount == 5))) ;	
	ConROC:AbilityBurst(_Combustion, combRDY and incombat and (not ConROC:TalentChosen(Spec.Fire, Fire_Talent.ImprovedScorch) or (ConROC:TalentChosen(Spec.Fire, Fire_Talent.ImprovedScorch) and fVuCount == 5)));

	ConROC:AbilityRaidBuffs(_ArcaneIntellect, aIntRDY and not (aIntBUFF or aBriBUFF));
	
--Warnings
    
--Pre pull
	if ConROC:CheckBox(ConROC_SM_Option_PrePull) and ConROC:CheckBox(ConROC_SM_CD_MirrprImage) and mirrRDY then
		return _MirrorImage
	end
--Rotations
	--[[
	if evoRDY and manaPercent < 25 then
		return _Evocation;
	end
	]]
    if plvl < 10 then
        if fBlastRDY then
            return _FireBlast;
        end
        if ConROC:CheckBox(ConROC_SM_Filler_Fireball) and fBallRDY then
            return _Fireball;
        end
        if ConROC:CheckBox(ConROC_SM_Filler_Frostbolt) and frBoltRDY then
            return _Frostbolt;
        end
        if ConROC:CheckBox(ConROC_SM_Filler_ArcaneMissiles) and aMissRDY then
            return _ArcaneMissiles
        end
        if ConROC:CheckBox(ConROC_SM_Option_UseWand) and hasWand and ((manaPercent <= 25 and not evoRDY) or targetPh <= 5) then
            return Caster.Shoot;
        end
	elseif (currentSpecName == "Arcane") then

		if ConROC_AoEButton:IsVisible() then
			if aExpRDY then
				return _ArcaneExplosion;
			end
		end

		if ConROC:CheckBox(ConROC_SM_CD_IcyVeins) and icyVeinsRDY and not icyVeinsBUFF then
			return _IcyVeins
		end
		if aBlastRDY and aBlastCount < 4 then
			return _ArcaneBlast
		end
		if aMissRDY and aMissBUFF then
			return _ArcaneMissiles
		end
		if evoRDY and manaPercent <= 25 then
			return _Evocation
		end
		if aBlastRDY and manaPercent > 25 then
			return _ArcaneBlast
		end
		if aMissRDY then
			return _ArcaneMissiles
		end
		if ConROC:CheckBox(ConROC_SM_Option_UseWand) and hasWand and ((manaPercent <= 25 and not evoRDY) or targetPh <= 5) then
			return Caster.Shoot;
		end
	
	elseif (currentSpecName == "Fire") then
		if ConROC_AoEButton:IsVisible() then
			if FirestarterBUFF and lastSpellId ~= _Flamestrike then
				return _Flamestrike
			end
			if FirestarterBUFF and lastSpellId ~= _FlamestrikeDR and _Flamestrike ~= _FlamestrikeDR then
				return _FlamestrikeDR
			end
			if (lastSpellId == _Flamestrike or lastSpellId == _FlamestrikeDR) and dBreathRDY then
				return _DragonsBreath
			end
			if bWaveRDY then
				return _BlastWave;
			end
		end

		if ConROC:CheckBox(ConROC_SM_CD_Combustion) and combRDY and incombat and ConROC:TalentChosen(Spec.Fire, Fire_Talent.Combustion) then
			return _Combustion
		end

		if scorRDY and not fVulDEBUFF or fVulDUR <= 4 then
			return _Scorch;
		end

		if HotStreak and pBlastRDY and lBombDEBUFF then
			return _Pyroblast
		end

		if lBombRDY and not lBombDEBUFF then
			return _LivingBomb;
		end

		if fBlastRDY then
			return _FireBlast;
		end

		if scorRDY and not fVulDEBUFF then
			return _Scorch;
		end

		if fBallRDY then
			return _Fireball;
		end
		if ConROC:CheckBox(ConROC_SM_Option_UseWand) and hasWand and ((manaPercent <= 25 and not evoRDY) or targetPh <= 5) then
			return Caster.Shoot;
		end

	elseif (currentSpecName == "Frost") then

		if ConROC_AoEButton:IsVisible() then
			if blizRDY then
				return _Blizzard;
			end
			if frNovaRDY and inMelee then
				return _FrostNova
			end
		end

		if ConROC:CheckBox(ConROC_SM_CD_IcyVeins) and icyVeinsRDY and not icyVeinsBUFF then
			return _IcyVeins
		end
		if foFrostBUFF and dFreezeRDY then
			return _DeepFreeze;
		end
		
		if fireballBUFF and ffBoltRDY then
			return _FrostFireBolt;
		end

		if wChillCount >= 1 and wChillDUR <= 4 and frBoltRDY and (manaPercent >= 25) then
			return _Frostbolt;
		end

		if frBoltRDY and (manaPercent >= 25) then
			return _Frostbolt;
		end
		if evoRDY and manaPercent <= 25 then
			return _Evocation
		end
		if ConROC:CheckBox(ConROC_SM_Option_UseWand) and hasWand and ((manaPercent <= 25 and not evoRDY) or targetPh <= 5) then
			return Caster.Shoot;
		end		
	else
		if fBallRDY then
			return _Fireball;
		end
		if ConROC:CheckBox(ConROC_SM_Option_UseWand) and hasWand and ((manaPercent <= 25 and not evoRDY) or targetPh <= 5) then
			return Caster.Shoot;
		end
	end	
	return nil;		
end

function ConROC.Mage.Defense(_, timeShift, currentSpell, gcd)
--Character
	local plvl	= UnitLevel('player');

--Racials

--Resources
	local mana			= UnitPower('player', Enum.PowerType.Mana);
	local manaMax		= UnitPowerMax('player', Enum.PowerType.Mana);
	local manaPercent	= math.max(0, mana) / math.max(1, manaMax) * 100;
	
--Abilties
	local mageArmorRDY = ConROC:AbilityReady(_MageArmor, timeShift);
		local mageArmorBUFF = ConROC:Buff(_MageArmor, timeShift);
	local manaShieldRDY = ConROC:AbilityReady(_ManaShield, timeShift);
		local manaShieldBUFF = ConROC:Buff(_ManaShield, timeShift);	
	local iBarRDY = ConROC:AbilityReady(_IceBarrier, timeShift);
		local iBarBUFF = ConROC:Buff(_IceBarrier, timeShift);	
	local iArmorRDY = ConROC:AbilityReady(_IceArmor, timeShift);
		local iArmorBUFF = ConROC:Buff(_IceArmor, timeShift);	
	local frNovaRDY = ConROC:AbilityReady(_FrostNova, timeShift);
	local moltenArmorRDY = ConROC:AbilityReady(_MoltenArmor, timeShift);
		local moltenArmorBUFF = ConROC:Buff(_MoltenArmor, timeShift);

--Conditions
	local inMelee = CheckInteractDistance("target", 3);	
	local targetPh = ConROC:PercentHealth('target');
    local mounted = IsMounted();
    local onVehicle = UnitHasVehicleUI("player");
    local moving = ConROC:PlayerSpeed();	
	
--Indicators

	
--Rotations
    if onVehicle then
        return nil
    end
	if ConROC:CheckBox(ConROC_SM_Armor_Ice) and iArmorRDY and not iArmorBUFF then
		return _IceArmor;
	end
	
	if ConROC:CheckBox(ConROC_SM_Armor_Mage) and mageArmorRDY and not mageArmorBUFF then
		return _MageArmor;
	end
	
	if ConROC:CheckBox(ConROC_SM_Armor_Molten) and moltenArmorRDY and not moltenArmorBUFF then
		return _MoltenArmor;
	end
	
	if frNovaRDY and inMelee and targetPh >= 20 then
		return _FrostNova;
	end	

	if iBarRDY and not iBarBUFF then
		return _IceBarrier;
	end
	
	return nil;
end

function ConROC:JustFrostbolted(spellID)
	if spellID == _Frostbolt then
		local expTime = GetTime() + 15;
		wChillEXP = expTime;
	end
end

function ConROC:JustFlamestriked(spellID)
	if spellID == _Flamestrike then
		local expTime = GetTime() + 8;
		fStrikeEXP = expTime;
	end
end

function ConROC:JustScorched(spellID)
	if spellID == _Scorch then
		local expTime = GetTime() + 30;
		fVulEXP = expTime;
	end
end