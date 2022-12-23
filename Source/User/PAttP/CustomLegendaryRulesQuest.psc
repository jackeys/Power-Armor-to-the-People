Scriptname PAttP:CustomLegendaryRulesQuest extends Quest
{Manages which custom legendary effects are present in the pool of possible legendaries that the main game has}

LegendaryItemQuestScript Property LegendaryItemQuest const auto mandatory
{Autofill}

Message Property RemoveNukaWorldRulesMessage Auto Const Mandatory
Message Property ArrayExpansionMessage Auto Const Mandatory

bool Property AllowArrayExpansion = false Auto
{Whether or not LL_FourPlay can be used to expand the array size for all arrays in the game, if it is available}

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

bool Property OverpoweringEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property OverpoweringModRule Const Auto Mandatory

bool Property ReflectingEnabled = true Auto
LegendaryItemQuestScript:LegendaryModRule Property ReflectingModRule Const Auto Mandatory

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

; Unique power armor effects - off by default

bool Property UniqueEffectsEnabled = false Auto

bool Property OverseersEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property OverseersModRule Const Auto Mandatory

bool Property PeoplesEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property PeoplesModRule Const Auto Mandatory

bool Property TerrifyingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property TerrifyingModRule Const Auto Mandatory

bool Property PiezonucleicEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property PiezonucleicModRule Const Auto Mandatory

bool Property RocketeerEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property RocketeerModRule Const Auto Mandatory

bool Property DirectorsEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property DirectorsModRule Const Auto Mandatory

bool Property RecyclingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property RecyclingModRule Const Auto Mandatory

bool Property CondensingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property CondensingModRule Const Auto Mandatory

bool Property DeflectingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property DeflectingModRule Const Auto Mandatory

bool Property RammingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property RammingModRule Const Auto Mandatory

bool Property PenetratingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property PenetratingModRule Const Auto Mandatory

bool Property AdaptingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property AdaptingModRule Const Auto Mandatory

bool Property ChargingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property ChargingModRule Const Auto Mandatory

bool Property HeavyLiftingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property HeavyLiftingModRule Const Auto Mandatory

bool Property RadAbsorbingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property RadAbsorbingModRule Const Auto Mandatory

bool Property FleetingEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property FleetingModRule Const Auto Mandatory

bool Property BonusVsAbominationEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property BonusVsAbominationModRule Const Auto Mandatory

bool Property AshursEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property AshursModRule Const Auto Mandatory

bool Property LeakyEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property LeakyModRule Const Auto Mandatory

bool Property PersistentEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property PersistentModRule Const Auto Mandatory

bool Property HeroicEnabled = false Auto
LegendaryItemQuestScript:LegendaryModRule Property HeroicModRule Const Auto Mandatory

Event OnQuestInit()
	UpdateLegendaryModRules()
EndEvent

Function UpdateLegendaryModRules()
	UpdateFormList(VanillaArmorEnabled, LegendaryModRule_AllowedKeywords_ObjectTypeArmor, ArmorTypePower)
	UpdateFormList(VanillaChestOnlyEnabled, LegendaryModRule_AllowedKeywords_ArmorBodyPartChest, PowerArmorChestKeyword)

	UpdateModRule("Durable", AlmostUnbreakableEnabled, AlmostUnbreakableModRule)
	UpdateModRule("Efficient", EfficientEnabled, EfficientModRule)
	UpdateModRule("Aerodynamic", AerodynamicEnabled, AerodynamicModRule)
	UpdateModRule("Custom", CustomEnabled, CustomModRule)
	UpdateModRule("Heavy Gunner's", HeavyGunnersEnabled, HeavyGunnersModRule)
	UpdateModRule("Amphibious", AmphibiousEnabled, AmphibiousModRule)
	UpdateModRule("Drop Trooper", DropTrooperEnabled, DropTrooperModRule)
	UpdateModRule("Sprinter's", SprintersEnabled, SprintersModRule)
	UpdateModRule("Overpowering", OverpoweringEnabled, OverpoweringModRule)
	UpdateModRule("Reflecting", ReflectingEnabled, ReflectingModRule)
	
	int i = 0
	while i < HardeningModRules.Length
	UpdateModRule("Hardening " + i, HardeningEnabled, HardeningModRules[i])
	i += 1
	EndWhile

	; Unique effects
	UpdateUniqueModRule("Overseer's", OverseersEnabled, OverseersModRule)
	UpdateUniqueModRule("People's", PeoplesEnabled, PeoplesModRule)
	UpdateUniqueModRule("Director's", DirectorsEnabled, DirectorsModRule)
	UpdateUniqueModRule("Ashur's", AshursEnabled, AshursModRule)
	UpdateUniqueModRule("Terrifying", TerrifyingEnabled, TerrifyingModRule)
	UpdateUniqueModRule("Piezonucleic", PiezonucleicEnabled, PiezonucleicModRule)
	UpdateUniqueModRule("Rocketeer", RocketeerEnabled, RocketeerModRule)
	UpdateUniqueModRule("Recycling", RecyclingEnabled, RecyclingModRule)
	UpdateUniqueModRule("Condensing", CondensingEnabled, CondensingModRule)
	UpdateUniqueModRule("Deflecting", DeflectingEnabled, DeflectingModRule)
	UpdateUniqueModRule("Ramming", RammingEnabled, RammingModRule)
	UpdateUniqueModRule("Penetrating", PenetratingEnabled, PenetratingModRule)
	UpdateUniqueModRule("Adapting", AdaptingEnabled, AdaptingModRule)
	UpdateUniqueModRule("Charging", ChargingEnabled, ChargingModRule)
	UpdateUniqueModRule("Heavy Lifting", HeavyLiftingEnabled, HeavyLiftingModRule)
	UpdateUniqueModRule("Rad-Absorbing", RadAbsorbingEnabled, RadAbsorbingModRule)
	UpdateUniqueModRule("Fleeting", FleetingEnabled, FleetingModRule)
	UpdateUniqueModRule("Leaky", LeakyEnabled, LeakyModRule)
	UpdateUniqueModRule("Persistent", PersistentEnabled, PersistentModRule)
	UpdateUniqueModRule("Heroic", HeroicEnabled, HeroicModRule)
	UpdateUniqueModRule("True American", BonusVsAbominationEnabled, BonusVsAbominationModRule)
EndFunction

Function UpdateUniqueModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	UpdateModRule(asName, abEnabled && UniqueEffectsEnabled, akRule)
EndFunction

Function UpdateModRule(string asName, bool abEnabled, LegendaryItemQuestScript:LegendaryModRule akRule)
	int index = FindLegendaryRule(akRule)
	if abEnabled
		if index >= 0
			debug.trace(self + " No action needed - found enabled rule " + asName + " at index " + index)
		else
			debug.trace(self + " Adding enabled legendary " + asName + " | Rule: " + akRule)
			LegendaryItemQuest.LegendaryModRules.add(akRule)
			
			; If the array is full, our insertion may not have worked
			while FindLegendaryRule(akRule) < 0 && MakeRoomInLegendaryArray()
				debug.trace(self + " Could not find enabled legendary " + asName + " after insertion - trying again | Rule: " + akRule)
				LegendaryItemQuest.LegendaryModRules.add(akRule)
			endWhile
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
	
	while index > -1 && (LegendaryItemQuest.LegendaryModRules[index].AllowedKeywords != akRule.AllowedKeywords || LegendaryItemQuest.LegendaryModRules[index].DisallowedKeywords != akRule.DisallowedKeywords)
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

int BUTTON_ALLOW_ACTION = 0 const
int BUTTON_DISALLOW_ACTION = 1 const

bool NukaWorldRemovalMessageShown = false
bool ArrayExpansionMessageShown = false

int MaxArraySize = 128
int ARRAY_SIZE_LIMIT = 256 const

bool Function MakeRoomInLegendaryArray()
	bool madeRoom = false

	; We can make room by deleting Nuka-World's unused legendary rules, if they are present
	if NukaWorldLegendaryRulesPresent() && !NukaWorldRemovalMessageShown
		NukaWorldRemovalMessageShown = true
		if RemoveNukaWorldRulesMessage.Show() == BUTTON_ALLOW_ACTION
			debug.trace(self + " removing Nuka-World legendary rules")
			RemoveNukaWorldLegendaryRulesByFormID()
			madeRoom = true
		endIf
	endIf
	
	if !madeRoom && ArrayExpansionAvailable()
		if !ArrayExpansionMessageShown
			ArrayExpansionMessageShown = true
			AllowArrayExpansion = ArrayExpansionMessage.Show() == BUTTON_ALLOW_ACTION
		endIf

		if AllowArrayExpansion && MaxArraySize < ARRAY_SIZE_LIMIT
			MaxArraySize += 8
			debug.trace(self + " increasing the maximum array size to " + MaxArraySize)
			LL_FourPlay.SetMinimalMaxArraySize(MaxArraySize)
			madeRoom = true
		endIf
	endIf

	return madeRoom
EndFunction

bool Function ArrayExpansionAvailable()
	; This will be None (treated as a 0 with an error in the logs) if LL_FourPlay is not installed
	return (LL_FourPlay.GetLLFPPluginVersion() >= 34.0)
EndFunction

bool Function NukaWorldLegendaryRulesPresent()
	; Arbitrary rule from the list - if one is present, all of them should be
	FormList allowedKeywords = Game.GetFormFromFile(0x06048FC4, "DLCNukaWorld.esm") as FormList
    ObjectMod legendaryMod = Game.GetFormFromFile(0x060346FB, "DLCNukaWorld.esm") as ObjectMod

	if legendaryMod
        LegendaryItemQuestScript:LegendaryModRule legendaryRule = new LegendaryItemQuestScript:LegendaryModRule
        legendaryRule.AllowedKeywords = allowedKeywords
        legendaryRule.AllowGrenades = true
        legendaryRule.LegendaryObjectMod = legendaryMod

        return (FindLegendaryRule(legendaryRule) > -1)
    endIf

	return false
EndFunction

Function RemoveNukaWorldLegendaryRulesByFormID()
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x060346FB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBC)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBD)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBE)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FBF)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC0)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC1)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC2)
    RemoveNukaWorldRuleByFormIDs(0x06048FC4, 0x06048FC3)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06033906)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCC)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCD)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCE)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FCF)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD0)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD1)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD2)
    RemoveNukaWorldRuleByFormIDs(0x06048FC7, 0x06048FD3)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FC9)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD4)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD5)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD6)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD7)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD8)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FD9)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDA)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDB)
    RemoveNukaWorldRuleByFormIDs(0x06048FC8, 0x06048FDC)
EndFunction

Function RemoveNukaWorldRuleByFormIDs(int aiAllowedKeywords, int aiLegendaryMod)
    FormList allowedKeywords = Game.GetFormFromFile(aiAllowedKeywords, "DLCNukaWorld.esm") as FormList
    ObjectMod legendaryMod = Game.GetFormFromFile(aiLegendaryMod, "DLCNukaWorld.esm") as ObjectMod

    if legendaryMod
        LegendaryItemQuestScript:LegendaryModRule legendaryRule = new LegendaryItemQuestScript:LegendaryModRule
        legendaryRule.AllowedKeywords = allowedKeywords
        legendaryRule.AllowGrenades = true
        legendaryRule.LegendaryObjectMod = legendaryMod

        UpdateModRule("Nuka-World Rule", false, legendaryRule)
    endIf
EndFunction