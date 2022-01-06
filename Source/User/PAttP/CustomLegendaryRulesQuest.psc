Scriptname PAttP:CustomLegendaryRulesQuest extends Quest
{Manages which custom legendary effects are present in the pool of possible legendaries that the main game has}

LegendaryItemQuestScript Property LegendaryItemQuest const auto mandatory
{Autofill}

bool Property AlmostUnbreakableEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AlmostUnbreakableModRule Const Auto Mandatory

bool Property EfficientEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property EfficientModRule Const Auto Mandatory

bool Property AerodynamicEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AerodynamicModRule Const Auto Mandatory

bool Property CustomEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property CustomModRule Const Auto Mandatory

bool Property HeavyGunnersEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property HeavyGunnersModRule Const Auto Mandatory

bool Property AmphibiousEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property AmphibiousModRule Const Auto Mandatory

bool Property DropTrooperEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property DropTrooperModRule Const Auto Mandatory

bool Property SprintersEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property SprintersModRule Const Auto Mandatory

bool Property HardeningEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule[] Property HardeningModRules Const Auto Mandatory

bool Property VanillaArmorEnabled = true Auto
Keyword Property ArmorTypePower Const Auto Mandatory
{AUTOFILL}
FormList Property LegendaryModRule_AllowedKeywords_ObjectTypeArmor Const Auto Mandatory
{AUTOFILL}

bool Property VanillaChestOnlyEnabled = true Auto
Keyword Property PowerArmorChestKeyword Const Auto Mandatory
FormList Property LegendaryModRule_AllowedKeywords_ArmorBodyPartChest Const Auto Mandatory
{AUTOFILL}


Event OnQuestInit()
	UpdateLegendaryModRules()
EndEvent

Function UpdateLegendaryModRules()
	UpdateFormList(VanillaArmorEnabled, LegendaryModRule_AllowedKeywords_ObjectTypeArmor, ArmorTypePower)
	UpdateFormList(VanillaChestOnlyEnabled, LegendaryModRule_AllowedKeywords_ArmorBodyPartChest, PowerArmorChestKeyword)

	UpdateModRule("Almost Unbreakable", AlmostUnbreakableEnabled, AlmostUnbreakableModRule)
	UpdateModRule("Efficient", EfficientEnabled, EfficientModRule)
	UpdateModRule("Aerodynamic", AerodynamicEnabled, AerodynamicModRule)
	UpdateModRule("Custom", CustomEnabled, CustomModRule)
	UpdateModRule("Heavy Gunner's", HeavyGunnersEnabled, HeavyGunnersModRule)
	UpdateModRule("Amphibious", AmphibiousEnabled, AmphibiousModRule)
	UpdateModRule("Drop Trooper", DropTrooperEnabled, DropTrooperModRule)
	UpdateModRule("Sprinter's", SprintersEnabled, SprintersModRule)
	
	int i = 0
	while i < HardeningModRules.Length
		UpdateModRule("Hardening " + i, HardeningEnabled, HardeningModRules[i])
		i += 1
	EndWhile
EndFunction

Function UpdateModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	int index = FindLegendaryRule(akRule)
	if abEnabled
		if index >= 0
			debug.trace(self + " No action needed - found enabled rule " + asName + " at index " + index)
		else
			debug.trace(self + " Adding enabled legendary " + asName + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.add(akRule)
		endIf
	else
		if index < 0
			debug.trace(self + " No action needed - disabled rule " + asName + " not found")
		else
			debug.trace(self + " Removing disabled rule " + asName + " from index " + index + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.remove(index)
		endIf
	EndIf
EndFunction

int Function FindLegendaryRule(LegendaryItemQuestScript:LegendaryModRule akRule)
	; Look for the rule using the object mod, then double-check the other fields to make sure it actually matches
	int index = LegendaryItemQuest.LegendaryModRules.RFindStruct("LegendaryObjectMod", akRule.LegendaryObjectMod)
	
	while index > -1 && LegendaryItemQuest.LegendaryModRules[index] != akRule
		if index > 0
			index = LegendaryItemQuest.LegendaryModRules.RFindStruct("LegendaryObjectMod", akRule.LegendaryObjectMod, index - 1)
		else
			; We just checked the last element of the array - it's not here
			index = -1
		EndIf
	EndWhile

	return index
EndFunction

Function UpdateFormList(bool abEnabled, FormList akList, Form akKeyword)
	int index = akList.Find(akKeyword)
	if abEnabled
		if index >= 0
			debug.trace(self + " No action needed - found enabled keyword " + akKeyword + " in form list " + akList + " at index " + index)
		else
			debug.trace(self + " Adding enabled keyword " + akKeyword + " to form list " + akList)
			akList.AddForm(akKeyword)
		endIf
	else
		if index < 0
			debug.trace(self + " No action needed - disabled keyword " + akKeyword + " not found")
		else
			debug.trace(self + " Removing disabled keyword " + akKeyword + " from form list " + akList)
			akList.RemoveAddedForm(akKeyword)
		endIf
	EndIf
EndFunction