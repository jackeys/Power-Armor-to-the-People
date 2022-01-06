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

bool Property HardeningEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule[] Property HardeningModRules Const Auto Mandatory

Event OnQuestInit()
	UpdateLegendaryModRules()
EndEvent

Function UpdateLegendaryModRules()
	UpdateModRule("Almost Unbreakable", AlmostUnbreakableEnabled, AlmostUnbreakableModRule)
	UpdateModRule("Efficient", EfficientEnabled, EfficientModRule)
	UpdateModRule("Aerodynamic", AerodynamicEnabled, AerodynamicModRule)
	UpdateModRule("Custom", CustomEnabled, CustomModRule)
	UpdateModRule("Heavy Gunner's", HeavyGunnersEnabled, HeavyGunnersModRule)
	UpdateModRule("Amphibious", AmphibiousEnabled, AmphibiousModRule)
	UpdateModRule("Drop Trooper", DropTrooperEnabled, DropTrooperModRule)
	
	int i = 0
	while i < HardeningModRules.Length
		UpdateModRule("Hardening " + i, HardeningEnabled, HardeningModRules[i])
		i += 1
	EndWhile
EndFunction

Function UpdateModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	int index = LegendaryItemQuest.LegendaryModRules.FindStruct("LegendaryObjectMod", akRule.LegendaryObjectMod)
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