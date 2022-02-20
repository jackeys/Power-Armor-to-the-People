Scriptname PAttP:LegendaryPowerArmorManager extends Quest
{Tracks legendary effects that have been given to power armor to cycle through them}

LegendaryItemQuestScript Property LegendaryItemQuest Auto Const Mandatory
{AUTOFILL}

InstanceNamingRules Property DefaultPowerArmorNamingRules Auto Const Mandatory
{Autofill
The instance naming rules for new legendary effects}

CustomEvent MergeNamingRules

; Track mods that have been spawned to cycle through them
ObjectMod[] PreviouslySpawnedMods

Event OnInit()
    PreviouslySpawnedMods = new ObjectMod[0]
EndEvent

ObjectMod[] Function GetAllowedMods(ObjectReference item, FormList ListOfSpecificModsToChooseFrom = None, FormList ListOfSpecificModsToDisallow = None)
	ObjectMod[] AllowedMods = LegendaryItemQuest.GetAllowedMods(item, ListOfSpecificModsToChooseFrom, ListOfSpecificModsToDisallow)

	ObjectMod[] PreferredMods = new ObjectMod[0]

	; Add any of the mods we haven't used recently to our list of preferred mods
	int i = 0
	while (i < AllowedMods.length)
		if  PreviouslySpawnedMods.Find(AllowedMods[i]) < 0
			PreferredMods.add(AllowedMods[i])
		endif

		i += 1
	endwhile
	
	; If we don't have anything to pick from, reset the lists and choose anything
	; Note that because different parts of the power armor can have different mods, we may not cycle through everything on every part
	; This may end up working in our favour, though - if the list of mods for each part gets too long, it can be hard to get a higher level piece with an effect that was already gotten on a lower level piece
	if PreferredMods.length == 0
		debug.trace(self + " couldn't find any previously unspawned mods, clearing PreviouslySpawnedMods and using any allowable")
		PreviouslySpawnedMods.clear()
		PreferredMods = AllowedMods
	endif

	debug.trace(self + " providing this list of eligible mods: " + AllowedMods)

	return PreferredMods
EndFunction

Function SendMergeRulesEvent(InstanceNamingRules akRulesToMerge)
	Var[] args = new Var[1]
	args[0] = akRulesToMerge
    SendCustomEvent("MergeNamingRules", args)
EndFunction