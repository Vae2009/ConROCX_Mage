local ConROC_Mage, ids = ...;

local lastFrame = 0;
local lastArmor = 0;
local lastFiller = 0;
local lastAoE = 0;
local lastOption = 0;


local plvl = UnitLevel('player');

local defaults = {
	["ConROC_SM_Role_Caster"] = true,

	["ConROC_Caster_Armor_Ice"] = true,
	["ConROC_Caster_Filler_Fireball"] = true,
	["ConROC_Caster_AoE_ArcaneExplosion"] = true,
	["ConROC_Caster_AoE_Flamestrike"] = true,
	["ConROC_Caster_AoE_Blizzard"] = true,
	["ConROC_Caster_Option_UseWand"] = true,
	["ConROC_Caster_Option_AoE"] = true,
}


ConROCMageSpells = ConROCMageSpells or defaults;

function ConROC:SpellmenuClass()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCSpellmenuClass", ConROCSpellmenuFrame2)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 30)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", "ConROCSpellmenuFrame_Title", "BOTTOM", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)
		
	--Caster
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Role_Caster", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontRedSmall");
			radio1:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -10);
			radio1:SetChecked(ConROCMageSpells.ConROC_SM_Role_Caster);
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Role_Caster:SetChecked(true);
					ConROC_SM_Role_PvP:SetChecked(false);
					ConROCMageSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
					ConROCMageSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
					ConROC:RoleProfile();
					ConROC:SpellMenuUpdate();
				end
			);
			radio1text:SetText("Caster");
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('Spellmenu_radio1_Texture', 'ARTWORK');
				r1t:SetTexture('Interface\\AddOns\\ConROC\\images\\magiccircle');
				r1t:SetBlendMode('BLEND');
				local color = ConROC.db.profile.purgeOverlayColor;
				r1t:SetVertexColor(color.r, color.g, color.b);				
				radio1.texture = r1t;
			end			
			r1t:SetScale(0.2);
			r1t:SetPoint("CENTER", radio1, "CENTER", 0, 0);
			radio1text:SetPoint("BOTTOM", radio1, "TOP", 0, 5);
		
	--PvP
		local radio4 = CreateFrame("CheckButton", "ConROC_SM_Role_PvP", frame, "UIRadioButtonTemplate");
		local radio4text = frame:CreateFontString(nil, "ARTWORK", "GameFontRedSmall");
			radio4:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -10);
			radio4:SetChecked(ConROCMageSpells.ConROC_SM_Role_PvP);
			radio4:SetScript("OnClick", 
			  function()
					ConROC_SM_Role_Caster:SetChecked(false);
					ConROC_SM_Role_PvP:SetChecked(true);
					ConROCMageSpells.ConROC_SM_Role_Caster = ConROC_SM_Role_Caster:GetChecked();
					ConROCMageSpells.ConROC_SM_Role_PvP = ConROC_SM_Role_PvP:GetChecked();
					ConROC:RoleProfile();
					ConROC:SpellMenuUpdate();
				end
			);
			radio4text:SetText("PvP");					
		local r4t = radio4.texture;

			if not r4t then
				r4t = radio4:CreateTexture('Spellmenu_radio4_Texture', 'ARTWORK');
				r4t:SetTexture('Interface\\AddOns\\ConROC\\images\\lightning-interrupt');
				r4t:SetBlendMode('BLEND');				
				radio4.texture = r4t;
			end			
			r4t:SetScale(0.2);
			r4t:SetPoint("CENTER", radio4, "CENTER", 0, 0);
			radio4text:SetPoint("BOTTOM", radio4, "TOP", 0, 5);
			

		frame:Hide()
		lastFrame = frame;
	
	ConROC:RadioHeader1();
	ConROC:RadioHeader2();
	ConROC:CheckHeader1();
	ConROC:CheckHeader2();
end

function ConROC:RadioHeader1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioHeader1", ConROCSpellmenuClass)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		local fontArmors = frame:CreateFontString("ConROC_Spellmenu_RadioHeader1", "ARTWORK", "GameFontGreenSmall");
			fontArmors:SetText("Armors");
			fontArmors:SetPoint('TOP', frame, 'TOP');
		
			local obutton = CreateFrame("Button", 'ConROC_RadioFrame1_OpenButton', frame)
				obutton:SetFrameStrata('MEDIUM')
				obutton:SetFrameLevel('6')
				obutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				obutton:SetSize(12, 12)
				obutton:Hide()
				obutton:SetAlpha(1)
				
				obutton:SetText("v")
				obutton:SetNormalFontObject("GameFontHighlightSmall")

			local ohtex = obutton:CreateTexture()
				ohtex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				ohtex:SetTexCoord(0, 0.625, 0, 0.6875)
				ohtex:SetAllPoints()
				obutton:SetHighlightTexture(ohtex)

				obutton:SetScript("OnMouseUp", function (self, obutton, up)
					self:Hide();
					ConROCRadioFrame1:Show();
					ConROC_RadioFrame1_CloseButton:Show();
					ConROC:SpellMenuUpdate();
				end)

			local tbutton = CreateFrame("Button", 'ConROC_RadioFrame1_CloseButton', frame)
				tbutton:SetFrameStrata('MEDIUM')
				tbutton:SetFrameLevel('6')
				tbutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				tbutton:SetSize(12, 12)
				tbutton:Show()
				tbutton:SetAlpha(1)
				
				tbutton:SetText("^")
				tbutton:SetNormalFontObject("GameFontHighlightSmall")

			local htex = tbutton:CreateTexture()
				htex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				htex:SetTexCoord(0, 0.625, 0, 0.6875)
				htex:SetAllPoints()
				tbutton:SetHighlightTexture(htex)
				
				tbutton:SetScript("OnMouseUp", function (self, tbutton, up)
					self:Hide();
					ConROCRadioFrame1:Hide();
					ConROC_RadioFrame1_OpenButton:Show();
					ConROC:SpellMenuUpdate();
				end)		
		
		frame:Show();
		lastFrame = frame;
		
	ConROC:RadioFrame1();
end

function ConROC:RadioFrame1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioFrame1", ConROCRadioHeader1)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 5)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", "ConROCRadioHeader1", "BOTTOM", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		lastArmor = frame;
		lastFrame = frame;
		
	--Ice
		local r1tspellName, _, r1tspell = GetSpellInfo(ids.Frost_Ability.IceArmorRank1);	
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Armor_Ice", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio1:SetPoint("TOP", ConROCRadioFrame1, "BOTTOM", -75, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio1:SetChecked(ConROCMageSpells.ConROC_Caster_Armor_Ice);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio1:SetChecked(ConROCMageSpells.ConROC_PvP_Armor_Ice);	
			end
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Armor_Ice:SetChecked(true);
					ConROC_SM_Armor_Mage:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Armor_Ice = ConROC_SM_Armor_Ice:GetChecked();
						ConROCMageSpells.ConROC_Caster_Armor_Mage = ConROC_SM_Armor_Mage:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Armor_Ice = ConROC_SM_Armor_Ice:GetChecked();
						ConROCMageSpells.ConROC_PvP_Armor_Mage = ConROC_SM_Armor_Mage:GetChecked();
					end
				end
			);
			radio1text:SetText(r1tspellName);
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('RadioFrame1_radio1_Texture', 'ARTWORK');
				r1t:SetTexture(r1tspell);
				r1t:SetBlendMode('BLEND');
				radio1.texture = r1t;
			end			
			r1t:SetScale(0.2);
			r1t:SetPoint("LEFT", radio1, "RIGHT", 8, 0);
			radio1text:SetPoint('LEFT', r1t, 'RIGHT', 5, 0);
		
		lastArmor = radio1;
		lastFrame = radio1;
		
	--Mage
		local r2tspellName, _, r2tspell = GetSpellInfo(ids.Arc_Ability.MageArmorRank1);	
		local radio2 = CreateFrame("CheckButton", "ConROC_SM_Armor_Mage", frame, "UIRadioButtonTemplate");
		local radio2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio2:SetPoint("TOP", lastArmor, "BOTTOM", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio2:SetChecked(ConROCMageSpells.ConROC_Caster_Armor_Mage);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio2:SetChecked(ConROCMageSpells.ConROC_PvP_Armor_Mage);
			end
			radio2:SetScript("OnClick", 
				function()
					ConROC_SM_Armor_Ice:SetChecked(false);
					ConROC_SM_Armor_Mage:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Armor_Ice = ConROC_SM_Armor_Ice:GetChecked();
						ConROCMageSpells.ConROC_Caster_Armor_Mage = ConROC_SM_Armor_Mage:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Armor_Ice = ConROC_SM_Armor_Ice:GetChecked();
						ConROCMageSpells.ConROC_PvP_Armor_Mage = ConROC_SM_Armor_Mage:GetChecked();
					end
				end
			);
			radio2text:SetText(r2tspellName);					
		local r2t = radio2.texture; 
			if not r2t then
				r2t = radio2:CreateTexture('RadioFrame1_radio2_Texture', 'ARTWORK');
				r2t:SetTexture(r2tspell);
				r2t:SetBlendMode('BLEND');
				radio2.texture = r2t;
			end			
			r2t:SetScale(0.2);
			r2t:SetPoint("LEFT", radio2, "RIGHT", 8, 0);
			radio2text:SetPoint('LEFT', r2t, 'RIGHT', 5, 0);

		lastArmor = radio2;
		lastFrame = radio2;
		
		frame:Show()
end

function ConROC:RadioHeader2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioHeader2", ConROCSpellmenuClass)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		local fontFillers = frame:CreateFontString("ConROC_Spellmenu_RadioHeader2", "ARTWORK", "GameFontGreenSmall");
			fontFillers:SetText("Filler");
			fontFillers:SetPoint('TOP', frame, 'TOP');
		
			local obutton = CreateFrame("Button", 'ConROC_RadioFrame2_OpenButton', frame)
				obutton:SetFrameStrata('MEDIUM')
				obutton:SetFrameLevel('6')
				obutton:SetPoint("LEFT", fontFillers, "RIGHT", 0, 0)
				obutton:SetSize(12, 12)
				obutton:Hide()
				obutton:SetAlpha(1)
				
				obutton:SetText("v")
				obutton:SetNormalFontObject("GameFontHighlightSmall")

			local ohtex = obutton:CreateTexture()
				ohtex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				ohtex:SetTexCoord(0, 0.625, 0, 0.6875)
				ohtex:SetAllPoints()
				obutton:SetHighlightTexture(ohtex)

				obutton:SetScript("OnMouseUp", function (self, obutton, up)
					self:Hide();
					ConROCRadioFrame2:Show();
					ConROC_RadioFrame2_CloseButton:Show();
					ConROC:SpellMenuUpdate();
				end)

			local tbutton = CreateFrame("Button", 'ConROC_RadioFrame2_CloseButton', frame)
				tbutton:SetFrameStrata('MEDIUM')
				tbutton:SetFrameLevel('6')
				tbutton:SetPoint("LEFT", fontFillers, "RIGHT", 0, 0)
				tbutton:SetSize(12, 12)
				tbutton:Show()
				tbutton:SetAlpha(1)
				
				tbutton:SetText("^")
				tbutton:SetNormalFontObject("GameFontHighlightSmall")

			local htex = tbutton:CreateTexture()
				htex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				htex:SetTexCoord(0, 0.625, 0, 0.6875)
				htex:SetAllPoints()
				tbutton:SetHighlightTexture(htex)
				
				tbutton:SetScript("OnMouseUp", function (self, tbutton, up)
					self:Hide();
					ConROCRadioFrame2:Hide();
					ConROC_RadioFrame2_OpenButton:Show();
					ConROC:SpellMenuUpdate();
				end)		
		
		frame:Show();
		lastFrame = frame;
		
	ConROC:RadioFrame2();
end

function ConROC:RadioFrame2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCRadioFrame2", ConROCRadioHeader2)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 5)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", "ConROCRadioHeader2", "BOTTOM", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		lastFiller = frame;
		lastFrame = frame;
		
	--Fireball
		local r0tspellName, _, r0tspell = GetSpellInfo(ids.Fire_Ability.FireballRank1);
		local radio0 = CreateFrame("CheckButton", "ConROC_SM_Filler_Fireball", frame, "UIRadioButtonTemplate");
		local radio0text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio0:SetPoint("TOP", ConROCRadioFrame2, "BOTTOM", -75, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio0:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_Fireball);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio0:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_Fireball);	
			end
			radio0:SetScript("OnClick",
				function()
					ConROC_SM_Filler_Fireball:SetChecked(true);
					ConROC_SM_Filler_Frostbolt:SetChecked(false);
					ConROC_SM_Filler_ArcaneMissiles:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					end
				end
			);
			radio0text:SetText(r0tspellName);				
		local r0t = radio0.texture;
			if not r0t then
				r0t = radio0:CreateTexture('RadioFrame2_radio0_Texture', 'ARTWORK');
				r0t:SetTexture(r0tspell);
				r0t:SetBlendMode('BLEND');
				radio0.texture = r0t;
			end			
			r0t:SetScale(0.2);
			r0t:SetPoint("LEFT", radio0, "RIGHT", 8, 0);
			radio0text:SetPoint('LEFT', r0t, 'RIGHT', 5, 0);
		
		lastFiller = radio0;
		lastFrame = radio0;
		
	--Frostbolt
		local r1tspellName, _, r1tspell = GetSpellInfo(ids.Frost_Ability.FrostboltRank1);
		local radio1 = CreateFrame("CheckButton", "ConROC_SM_Filler_Frostbolt", frame, "UIRadioButtonTemplate");
		local radio1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio1:SetPoint("TOP", lastFiller, "BOTTOM", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio1:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_Frostbolt);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio1:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_Frostbolt);	
			end
			radio1:SetScript("OnClick",
				function()
					ConROC_SM_Filler_Fireball:SetChecked(false);
					ConROC_SM_Filler_Frostbolt:SetChecked(true);
					ConROC_SM_Filler_ArcaneMissiles:SetChecked(false);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					end
				end
			);
			radio1text:SetText(r1tspellName);				
		local r1t = radio1.texture;
			if not r1t then
				r1t = radio1:CreateTexture('RadioFrame2_radio1_Texture', 'ARTWORK');
				r1t:SetTexture(r1tspell);
				r1t:SetBlendMode('BLEND');
				radio1.texture = r1t;
			end			
			r1t:SetScale(0.2);
			r1t:SetPoint("LEFT", radio1, "RIGHT", 8, 0);
			radio1text:SetPoint('LEFT', r1t, 'RIGHT', 5, 0);
		
		lastFiller = radio1;
		lastFrame = radio1;
		
	--Arcane Missiles
		local r2tspellName, _, r2tspell = GetSpellInfo(ids.Arc_Ability.ArcaneMissilesRank1);
		local radio2 = CreateFrame("CheckButton", "ConROC_SM_Filler_ArcaneMissiles", frame, "UIRadioButtonTemplate");
		local radio2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
			radio2:SetPoint("TOP", lastFiller, "BOTTOM", 0, 0);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				radio2:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_ArcaneMissiles);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				radio2:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_ArcaneMissiles);
			end
			radio2:SetScript("OnClick", 
				function()
					ConROC_SM_Filler_Fireball:SetChecked(false);
					ConROC_SM_Filler_Frostbolt:SetChecked(false);
					ConROC_SM_Filler_ArcaneMissiles:SetChecked(true);
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_Caster_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Filler_Fireball = ConROC_SM_Filler_Fireball:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_Frostbolt = ConROC_SM_Filler_Frostbolt:GetChecked();
						ConROCMageSpells.ConROC_PvP_Filler_ArcaneMissiles = ConROC_SM_Filler_ArcaneMissiles:GetChecked();
					end
				end
			);
			radio2text:SetText(r2tspellName);					
		local r2t = radio2.texture; 
			if not r2t then
				r2t = radio2:CreateTexture('RadioFrame2_radio2_Texture', 'ARTWORK');
				r2t:SetTexture(r2tspell);
				r2t:SetBlendMode('BLEND');
				radio2.texture = r2t;
			end			
			r2t:SetScale(0.2);
			r2t:SetPoint("LEFT", radio2, "RIGHT", 8, 0);
			radio2text:SetPoint('LEFT', r2t, 'RIGHT', 5, 0);

		lastFiller = radio2;
		lastFrame = radio2;
		
		frame:Show()
end

function ConROC:CheckHeader1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader1", ConROCSpellmenuClass)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		local fontArmors = frame:CreateFontString("ConROC_Spellmenu_CheckHeader1", "ARTWORK", "GameFontGreenSmall");
			fontArmors:SetText("AoEs");
			fontArmors:SetPoint('TOP', frame, 'TOP');
		
			local obutton = CreateFrame("Button", 'ConROC_CheckFrame1_OpenButton', frame)
				obutton:SetFrameStrata('MEDIUM')
				obutton:SetFrameLevel('6')
				obutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				obutton:SetSize(12, 12)
				obutton:Hide()
				obutton:SetAlpha(1)
				
				obutton:SetText("v")
				obutton:SetNormalFontObject("GameFontHighlightSmall")

			local ohtex = obutton:CreateTexture()
				ohtex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				ohtex:SetTexCoord(0, 0.625, 0, 0.6875)
				ohtex:SetAllPoints()
				obutton:SetHighlightTexture(ohtex)

				obutton:SetScript("OnMouseUp", function (self, obutton, up)
					self:Hide();
					ConROCCheckFrame1:Show();
					ConROC_CheckFrame1_CloseButton:Show();
					ConROC:SpellMenuUpdate();
				end)

			local tbutton = CreateFrame("Button", 'ConROC_CheckFrame1_CloseButton', frame)
				tbutton:SetFrameStrata('MEDIUM')
				tbutton:SetFrameLevel('6')
				tbutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				tbutton:SetSize(12, 12)
				tbutton:Show()
				tbutton:SetAlpha(1)
				
				tbutton:SetText("^")
				tbutton:SetNormalFontObject("GameFontHighlightSmall")

			local htex = tbutton:CreateTexture()
				htex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				htex:SetTexCoord(0, 0.625, 0, 0.6875)
				htex:SetAllPoints()
				tbutton:SetHighlightTexture(htex)
				
				tbutton:SetScript("OnMouseUp", function (self, tbutton, up)
					self:Hide();
					ConROCCheckFrame1:Hide();
					ConROC_CheckFrame1_OpenButton:Show();
					ConROC:SpellMenuUpdate();
				end)		
		
		frame:Show();
		lastFrame = frame;
		
	ConROC:CheckFrame1();
end

function ConROC:CheckFrame1()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame1", ConROCCheckHeader1)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 5)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", "ConROCCheckHeader1", "BOTTOM", 0, 0)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		lastAoE = frame;
		lastFrame = frame;
		
	--Arcane Explosion
		local c1tspellName, _, c1tspell = GetSpellInfo(ids.Arc_Ability.ArcaneExplosionRank1); 
		local check1 = CreateFrame("CheckButton", "ConROC_SM_AoE_ArcaneExplosion", frame, "UICheckButtonTemplate");
		local check1text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOP", ConROCCheckFrame1, "BOTTOM", -150, 0);
			check1:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_ArcaneExplosion);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_ArcaneExplosion);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_AoE_ArcaneExplosion = ConROC_SM_AoE_ArcaneExplosion:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_AoE_ArcaneExplosion = ConROC_SM_AoE_ArcaneExplosion:GetChecked();
					end
				end);
			check1text:SetText(c1tspellName);				
		local c1t = check1.texture;
			if not c1t then
				c1t = check1:CreateTexture('CheckFrame1_check1_Texture', 'ARTWORK');
				c1t:SetTexture(c1tspell);
				c1t:SetBlendMode('BLEND');
				check1.texture = c1t;
			end			
			c1t:SetScale(0.4);
			c1t:SetPoint("LEFT", check1, "RIGHT", 8, 0);
			check1text:SetPoint('LEFT', c1t, 'RIGHT', 5, 0);
			
		lastAoE = check1;
		lastFrame = check1;

	--Flamestrike
		local c2tspellName, _, c2tspell = GetSpellInfo(ids.Fire_Ability.FlamestrikeRank1); 
		local check2 = CreateFrame("CheckButton", "ConROC_SM_AoE_Flamestrike", frame, "UICheckButtonTemplate");
		local check2text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check2:SetPoint("TOP", lastAoE, "BOTTOM", 0, 0);
			check2:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check2:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_Flamestrike);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check2:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_Flamestrike);
			end
			check2:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_AoE_Flamestrike = ConROC_SM_AoE_Flamestrike:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_AoE_Flamestrike = ConROC_SM_AoE_Flamestrike:GetChecked();
					end
				end);
			check2text:SetText(c2tspellName);
		local c2t = check2.texture;
			if not c2t then
				c2t = check2:CreateTexture('CheckFrame1_check2_Texture', 'ARTWORK');
				c2t:SetTexture(c2tspell);
				c2t:SetBlendMode('BLEND');
				check2.texture = c2t;
			end
			c2t:SetScale(0.4);
			c2t:SetPoint("LEFT", check2, "RIGHT", 8, 0);
			check2text:SetPoint('LEFT', c2t, 'RIGHT', 5, 0);

		lastAoE = check2;
		lastFrame = check2;

	--Blizzard
		local c3tspellName, _, c3tspell = GetSpellInfo(ids.Frost_Ability.BlizzardRank1); 
		local check3 = CreateFrame("CheckButton", "ConROC_SM_AoE_Blizzard", frame, "UICheckButtonTemplate");
		local check3text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check3:SetPoint("TOP", lastAoE, "BOTTOM", 0, 0);
			check3:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check3:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_Blizzard);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check3:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_Blizzard);
			end
			check3:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_AoE_Blizzard = ConROC_SM_AoE_Blizzard:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_AoE_Blizzard = ConROC_SM_AoE_Blizzard:GetChecked();
					end
				end);
			check3text:SetText(c3tspellName);				
		local c3t = check3.texture;
			if not c3t then
				c3t = check3:CreateTexture('CheckFrame1_check3_Texture', 'ARTWORK');
				c3t:SetTexture(c3tspell);
				c3t:SetBlendMode('BLEND');
				check3.texture = c3t;
			end			
			c3t:SetScale(0.4);
			c3t:SetPoint("LEFT", check3, "RIGHT", 8, 0);
			check3text:SetPoint('LEFT', c3t, 'RIGHT', 5, 0);
			
		lastAoE = check3;
		lastFrame = check3;
		
		frame:Show()
end

function ConROC:CheckHeader2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckHeader2", ConROCSpellmenuClass)
		
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5')
		frame:SetSize(180, 10)
		frame:SetAlpha(1)
		
		frame:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5)
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetClampedToScreen(true)

		local fontArmors = frame:CreateFontString("ConROC_Spellmenu_CheckHeader2", "ARTWORK", "GameFontGreenSmall");
			fontArmors:SetText("Options");
			fontArmors:SetPoint('TOP', frame, 'TOP');
		
			local obutton = CreateFrame("Button", 'ConROC_CheckFrame2_OpenButton', frame)
				obutton:SetFrameStrata('MEDIUM')
				obutton:SetFrameLevel('6')
				obutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				obutton:SetSize(12, 12)
				obutton:Hide()
				obutton:SetAlpha(1)
				
				obutton:SetText("v")
				obutton:SetNormalFontObject("GameFontHighlightSmall")

			local ohtex = obutton:CreateTexture()
				ohtex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				ohtex:SetTexCoord(0, 0.625, 0, 0.6875)
				ohtex:SetAllPoints()
				obutton:SetHighlightTexture(ohtex)

				obutton:SetScript("OnMouseUp", function (self, obutton, up)
					self:Hide();
					ConROCCheckFrame2:Show();
					ConROC_CheckFrame2_CloseButton:Show();
					ConROC:SpellMenuUpdate();
				end)

			local tbutton = CreateFrame("Button", 'ConROC_CheckFrame2_CloseButton', frame)
				tbutton:SetFrameStrata('MEDIUM')
				tbutton:SetFrameLevel('6')
				tbutton:SetPoint("LEFT", fontArmors, "RIGHT", 0, 0)
				tbutton:SetSize(12, 12)
				tbutton:Show()
				tbutton:SetAlpha(1)
				
				tbutton:SetText("^")
				tbutton:SetNormalFontObject("GameFontHighlightSmall")

			local htex = tbutton:CreateTexture()
				htex:SetTexture("Interface\\AddOns\\ConROC\\images\\buttonHighlight")
				htex:SetTexCoord(0, 0.625, 0, 0.6875)
				htex:SetAllPoints()
				tbutton:SetHighlightTexture(htex)
				
				tbutton:SetScript("OnMouseUp", function (self, tbutton, up)
					self:Hide();
					ConROCCheckFrame2:Hide();
					ConROC_CheckFrame2_OpenButton:Show();
					ConROC:SpellMenuUpdate();
				end)		
		
		frame:Show();
		lastFrame = frame;
		
	ConROC:CheckFrame2();
end

function ConROC:CheckFrame2()
	local _, Class, classId = UnitClass("player")
	local Color = RAID_CLASS_COLORS[Class]
	local frame = CreateFrame("Frame", "ConROCCheckFrame2", ConROCCheckHeader2)
		
	frame:SetFrameStrata('MEDIUM');
	frame:SetFrameLevel('5')
	frame:SetSize(180, 5)
	frame:SetAlpha(1)
	
	frame:SetPoint("TOP", "ConROCCheckHeader2", "BOTTOM", 0, 0)
	frame:SetMovable(false)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)

	lastOption = frame;
	lastFrame = frame;

	--Use Wand
		local check1 = CreateFrame("CheckButton", "ConROC_SM_Option_UseWand", frame, "UICheckButtonTemplate");
		local check1text = check1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check1:SetPoint("TOP", lastOption, "BOTTOM", -150, 0);
			check1:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check1:SetChecked(ConROCMageSpells.ConROC_Caster_Option_UseWand);
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check1:SetChecked(ConROCMageSpells.ConROC_PvP_Option_UseWand);
			end
			check1:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Option_UseWand = ConROC_SM_Option_UseWand:GetChecked();
					end
				end);
			check1text:SetText("Use Wand");
			check1text:SetScale(2);
			check1text:SetPoint("LEFT", check1, "RIGHT", 20, 0);
			
		lastOption = check1;
		lastFrame = check1;

	--AoE Toggle Button
		local check2 = CreateFrame("CheckButton", "ConROC_SM_Option_AoE", frame, "UICheckButtonTemplate");
		local check2text = check2:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");		
			check2:SetPoint("TOP", lastOption, "BOTTOM", 0, 0);
			check2:SetScale(.50);
			if ConROC:CheckBox(ConROC_SM_Role_Caster) then
				check2:SetChecked(ConROCMageSpells.ConROC_Caster_Option_AoE);
				if ConROC:CheckBox(ConROC_SM_Option_AoE) then
					ConROCButtonFrame:Show();
					if ConROC.db.profile.unlockWindow then
						ConROCToggleMover:Show();					
					else
						ConROCToggleMover:Hide();					
					end
				else
					ConROCButtonFrame:Hide();
					ConROCToggleMover:Hide();
				end
			elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
				check2:SetChecked(ConROCMageSpells.ConROC_PvP_Option_AoE);
				if ConROC:CheckBox(ConROC_SM_Option_AoE) then
					ConROCButtonFrame:Show();
					if ConROC.db.profile.unlockWindow then
						ConROCToggleMover:Show();					
					else
						ConROCToggleMover:Hide();					
					end					
				else
					ConROCButtonFrame:Hide();
					ConROCToggleMover:Hide();
				end
			end
			check2:SetScript("OnClick", 
				function()
					if ConROC:CheckBox(ConROC_SM_Role_Caster) then
						ConROCMageSpells.ConROC_Caster_Option_AoE = ConROC_SM_Option_AoE:GetChecked();
					elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
						ConROCMageSpells.ConROC_PvP_Option_AoE = ConROC_SM_Option_AoE:GetChecked();
					end
					if ConROC:CheckBox(ConROC_SM_Option_AoE) then
						ConROCButtonFrame:Show();
						ConROCCheckHeader1:Show();
						ConROCCheckFrame1:Show();
						if ConROC.db.profile.unlockWindow then
							ConROCToggleMover:Show();					
						else
							ConROCToggleMover:Hide();					
						end					
					else
						ConROCButtonFrame:Hide();
						ConROCToggleMover:Hide();
						ConROCCheckHeader1:Hide();
						ConROCCheckFrame1:Hide();
					end
					ConROC:SpellMenuUpdate();
				end);
			check2text:SetText("AoE Toggle Button");
			check2text:SetScale(2);			
			check2text:SetPoint("LEFT", check2, "RIGHT", 20, 0);
			
		lastOption = check2;
		lastFrame = check2;
		
		frame:Show()
end

function ConROC:SpellMenuUpdate()
	lastFrame = ConROCSpellmenuClass;

	if ConROCRadioHeader1 ~= nil then
		lastArmor = ConROCRadioFrame1;
		
	--Armors
		if plvl >= 1 and IsSpellKnown(ids.Frost_Ability.FrostArmorRank1) then
			ConROC_SM_Armor_Ice:Show();
			lastArmor = ConROC_SM_Armor_Ice;
		else
			ConROC_SM_Armor_Ice:Hide();
		end

		if plvl >= 34 and IsSpellKnown(ids.Arc_Ability.MageArmorRank1) then
			ConROC_SM_Armor_Mage:Show(); 
			ConROC_SM_Armor_Mage:SetPoint("TOP", lastArmor, "BOTTOM", 0, 0);
			lastArmor = ConROC_SM_Armor_Mage;
		else
			ConROC_SM_Armor_Mage:Hide();
		end

		if lastArmor == ConROCRadioFrame1 then
			ConROCRadioHeader1:Hide();
			ConROCRadioFrame1:Hide();
		end
		
		if ConROCRadioFrame1:IsVisible() then
			lastFrame = lastArmor;
		else
			lastFrame = ConROCRadioHeader1;
		end
	end

	if ConROCRadioHeader2 ~= nil then
		if lastFrame == lastArmor then
			ConROCRadioHeader2:SetPoint("TOP", lastFrame, "BOTTOM", 75, -5);
		else 
			ConROCRadioHeader2:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5);
		end	

		lastFiller = ConROCRadioFrame2;
		
	--Fillers
		if plvl >= 1 and IsSpellKnown(ids.Fire_Ability.FireballRank1) then 
			ConROC_SM_Filler_Fireball:Show();
			lastFiller = ConROC_SM_Filler_Fireball;
		else
			ConROC_SM_Filler_Fireball:Hide();
		end

		if plvl >= 4 and IsSpellKnown(ids.Frost_Ability.FrostboltRank1) then 
			ConROC_SM_Filler_Frostbolt:Show(); 
			ConROC_SM_Filler_Frostbolt:SetPoint("TOP", lastFiller, "BOTTOM", 0, 0);
			lastFiller = ConROC_SM_Filler_Frostbolt;
		else
			ConROC_SM_Filler_Frostbolt:Hide();
		end
		
		if plvl >= 8 and IsSpellKnown(ids.Arc_Ability.ArcaneMissilesRank1) then 
			ConROC_SM_Filler_ArcaneMissiles:Show(); 
			ConROC_SM_Filler_ArcaneMissiles:SetPoint("TOP", lastFiller, "BOTTOM", 0, 0);
			lastFiller = ConROC_SM_Filler_ArcaneMissiles;
		else
			ConROC_SM_Filler_ArcaneMissiles:Hide();
		end

		if lastFiller == ConROCRadioFrame2 then
			ConROCRadioHeader2:Hide();
			ConROCRadioFrame2:Hide();
		end
		
		if ConROCRadioFrame2:IsVisible() then
			lastFrame = lastFiller;
		else
			lastFrame = ConROCRadioHeader2;
		end
	end
	
	if ConROCCheckFrame1 ~= nil then
		if lastFrame == lastArmor or lastFrame == lastFiller then
			ConROCCheckHeader1:SetPoint("TOP", lastFrame, "BOTTOM", 75, -5);
		else 
			ConROCCheckHeader1:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5);
		end	

		lastAoE = ConROCCheckFrame1;
		
	--AoE
		if plvl >= 14 and IsSpellKnown(ids.Arc_Ability.ArcaneExplosionRank1) then 
			ConROC_SM_AoE_ArcaneExplosion:Show();
			lastAoE = ConROC_SM_AoE_ArcaneExplosion;
		else
			ConROC_SM_AoE_ArcaneExplosion:Hide();
		end
		
		if plvl >= 16 and IsSpellKnown(ids.Fire_Ability.FlamestrikeRank1) then 
			ConROC_SM_AoE_Flamestrike:Show();
			ConROC_SM_AoE_Flamestrike:SetPoint("TOP", lastAoE, "BOTTOM", 0, 0);			
			lastAoE = ConROC_SM_AoE_Flamestrike;
		else
			ConROC_SM_AoE_Flamestrike:Hide();
		end

		if plvl >= 20 and IsSpellKnown(ids.Frost_Ability.BlizzardRank1) then 
			ConROC_SM_AoE_Blizzard:Show(); 
			ConROC_SM_AoE_Blizzard:SetPoint("TOP", lastAoE, "BOTTOM", 0, 0);
			lastAoE = ConROC_SM_AoE_Blizzard;
		else
			ConROC_SM_AoE_Blizzard:Hide();
		end

		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCCheckHeader1:Show();
			ConROCCheckFrame1:Show();
		else
			ConROCCheckHeader1:Hide();
			ConROCCheckFrame1:Hide();		
		end
		
		if lastAoE == ConROCCheckFrame1 then
			ConROCCheckHeader1:Hide();
			ConROCCheckFrame1:Hide();
		end
		
		ConROC:CheckBox(ConROC_SM_Option_AoE)
		
		if ConROCCheckFrame1:IsVisible() then
			lastFrame = lastAoE;
		else
			lastFrame = ConROCCheckHeader1;
		end		
	end

	if ConROCCheckFrame2 ~= nil then
		if lastFrame == lastArmor or lastFrame == lastFiller or lastFrame == lastAoE then
			ConROCCheckHeader2:SetPoint("TOP", lastFrame, "BOTTOM", 75, -5);
		else 
			ConROCCheckHeader2:SetPoint("TOP", lastFrame, "BOTTOM", 0, -5);
		end	

		lastOption = ConROCCheckFrame2;
		
	--Options
		if plvl >= 1 and HasWandEquipped() then
			ConROC_SM_Option_UseWand:Show();
			lastOption = ConROC_SM_Option_UseWand;
		else
			ConROC_SM_Option_UseWand:Hide();
		end	
		
		if plvl >= 14 and IsSpellKnown(ids.Arc_Ability.ArcaneExplosionRank1) then 
			ConROC_SM_Option_AoE:Show(); 
			ConROC_SM_Option_AoE:SetPoint("TOP", lastOption, "BOTTOM", 0, 0);
			lastOption = ConROC_SM_Option_AoE;
		else
			ConROC_SM_Option_AoE:Hide();
		end

		if lastOption == ConROCCheckFrame2 then
			ConROCCheckHeader2:Hide();
			ConROCCheckFrame2:Hide();
		end
		
		if ConROCCheckFrame2:IsVisible() then
			lastFrame = lastOption;
		else
			lastFrame = ConROCCheckHeader2;
		end		
	end
end

function ConROC:RoleProfile()
	if ConROC:CheckBox(ConROC_SM_Role_Caster) then
		ConROC_SM_Armor_Ice:SetChecked(ConROCMageSpells.ConROC_Caster_Armor_Ice);
		ConROC_SM_Armor_Mage:SetChecked(ConROCMageSpells.ConROC_Caster_Armor_Mage);
		
		ConROC_SM_Filler_Fireball:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_Fireball);
		ConROC_SM_Filler_Frostbolt:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_Frostbolt);
		ConROC_SM_Filler_ArcaneMissiles:SetChecked(ConROCMageSpells.ConROC_Caster_Filler_ArcaneMissiles);	
		
		ConROC_SM_AoE_ArcaneExplosion:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_ArcaneExplosion);
		ConROC_SM_AoE_Flamestrike:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_Flamestrike);
		ConROC_SM_AoE_Blizzard:SetChecked(ConROCMageSpells.ConROC_Caster_AoE_Blizzard);

		ConROC_SM_Option_UseWand:SetChecked(ConROCMageSpells.ConROC_Caster_Option_UseWand);
		ConROC_SM_Option_AoE:SetChecked(ConROCMageSpells.ConROC_Caster_Option_AoE);

		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCButtonFrame:Show();
			if ConROC.db.profile.unlockWindow then
				ConROCToggleMover:Show();
			else
				ConROCToggleMover:Hide();
			end					
		else
			ConROCButtonFrame:Hide();
			ConROCToggleMover:Hide();
		end
		
	elseif ConROC:CheckBox(ConROC_SM_Role_PvP) then
		ConROC_SM_Armor_Ice:SetChecked(ConROCMageSpells.ConROC_PvP_Armor_Ice);
		ConROC_SM_Armor_Mage:SetChecked(ConROCMageSpells.ConROC_PvP_Armor_Mage);

		ConROC_SM_Filler_Fireball:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_Fireball);
		ConROC_SM_Filler_Frostbolt:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_Frostbolt);
		ConROC_SM_Filler_ArcaneMissiles:SetChecked(ConROCMageSpells.ConROC_PvP_Filler_ArcaneMissiles);

		ConROC_SM_AoE_ArcaneExplosion:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_ArcaneExplosion);
		ConROC_SM_AoE_Flamestrike:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_Flamestrike);
		ConROC_SM_AoE_Blizzard:SetChecked(ConROCMageSpells.ConROC_PvP_AoE_Blizzard);
		
		ConROC_SM_Option_UseWand:SetChecked(ConROCMageSpells.ConROC_PvP_Option_UseWand);
		ConROC_SM_Option_AoE:SetChecked(ConROCMageSpells.ConROC_PvP_Option_AoE);	
		
		if ConROC:CheckBox(ConROC_SM_Option_AoE) then
			ConROCButtonFrame:Show();
			if ConROC.db.profile.unlockWindow then
				ConROCToggleMover:Show();
			else
				ConROCToggleMover:Hide();
			end					
		else
			ConROCButtonFrame:Hide();
			ConROCToggleMover:Hide();
		end
	end
end