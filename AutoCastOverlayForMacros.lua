local function GetPetSpellBookSlot(spellNameOrID)
	spellNameOrID = GetSpellInfo(spellNameOrID)
	if spellNameOrID then
		local i = 1
		while true do
			local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_PET)

			if not spellName then
				break
			elseif spellName == spellNameOrID then
				return i
			end

			i = i + 1
		end
	end

	return nil
end

local function ShowMacroAutoCastOverlay(button)
	if not button.MacroAutoCastable then
		local macroAutoCastable = button:CreateTexture(nil, "OVERLAY")
		macroAutoCastable:SetTexture(button.AutoCastable:GetTexture())
		macroAutoCastable:SetSize(button.AutoCastable:GetSize())
		macroAutoCastable:SetPoint(button.AutoCastable:GetPoint())
		button.MacroAutoCastable = macroAutoCastable
	end
	button.MacroAutoCastable:Show()
end
local function HideMacroAutoCastOverlay(button)
	if button.MacroAutoCastable then
		button.MacroAutoCastable:Hide()
	end
end
local function MacroAutoCastStart(button)
	if not button.MacroShine then
		local macroShine = CreateFrame("Frame", button:GetName().."MacroShine", button, "AutoCastShineTemplate")
		AutoCastShine_OnLoad(macroShine)
		button.MacroShine = macroShine
	end
	AutoCastShine_AutoCastStart(button.MacroShine)
end
local function MacroAutoCastStop(button)
	if button.MacroShine then
		AutoCastShine_AutoCastStop(button.MacroShine)
	end
end

hooksecurefunc("ActionButton_UpdateState", function(button)
	local autoCastable, autoCastState

	local actionType, id = GetActionInfo(button.action)
	if actionType == "macro" then
		local petSpellSlot = GetPetSpellBookSlot(GetMacroSpell(id))
		if petSpellSlot then
			autoCastable, autoCastState = GetSpellAutocast(petSpellSlot, BOOKTYPE_PET)
		end
	end

	if autoCastable == true then
		ShowMacroAutoCastOverlay(button)
	else
		HideMacroAutoCastOverlay(button)
	end
	if autoCastState == true then
		MacroAutoCastStart(button)
	else
		MacroAutoCastStop(button)
	end
end)
