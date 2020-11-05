local function GetPetSpellBookSlot(spellNameOrID)
	spellNameOrID = GetSpellInfo(spellNameOrID);
	if (spellNameOrID) then
		local i = 1;
		while (true) do
			local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_PET);
			if (not spellName) then
				break;
			elseif (spellName == spellNameOrID) then
				return i;
			end
			i = i + 1
		end
	end
	return nil;
end

local function ActionButton_UpdateFlash(self)
    local actionType, id = GetActionInfo(self.action);
	if (actionType == "macro") then
        local autoCastable, autoCastState;
		local petSpellSlot = GetPetSpellBookSlot(GetMacroSpell(id));
		if (petSpellSlot) then
			autoCastable, autoCastState = GetSpellAutocast(petSpellSlot, BOOKTYPE_PET);
		end

        if (self.AutoCastable) then
            self.AutoCastable:SetShown(autoCastable);
        	if (autoCastState) then
                self.AutoCastShine:Show();
        		AutoCastShine_AutoCastStart(self.AutoCastShine);
        	else
                self.AutoCastShine:Hide();
        		AutoCastShine_AutoCastStop(self.AutoCastShine);
        	end
        end
	end
end

do
    local _, _, _, tocVersion = GetBuildInfo();
    if (tocVersion >= 90001) then
        hooksecurefunc(ActionBarActionButtonMixin, "UpdateFlash", ActionButton_UpdateFlash);
    else
        hooksecurefunc("ActionButton_UpdateFlash", ActionButton_UpdateFlash);
    end
end
