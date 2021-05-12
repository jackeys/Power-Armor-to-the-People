Scriptname PAttP:InjectLegendaryPowerArmor extends PAttP:InjectionQuest
{Injects an item into the list of potential legendary power armor sets. The correct leveled list to inject into is determined automatically based on the level the power armor should be available. This should only be used for Power Armor to the People, as it registers the list it injects into for automatic reversion and re-injection.}

Int Property level Auto Const Mandatory
{The level at which the item should start appearing}

LeveledItem Property itemToInject Auto Const Mandatory
{The item list to inject as a possible legendary power armor set - this should include any appropriate lists to ensure the correct linings are used at appropriate levels, and only 1 item should be returned}

LeveledItem Property PATTP_PossibleLegendaryItemBaseLists_PowerArmor_Top Auto Const Mandatory
{Autofill
A list that holds all power armor pieces at their appropriate levels, which can be used as a fallback if nothing is available at an available tier}

FormList Property PATTP_LegendaryTierLists_Sorted Auto Const Mandatory
{Autofill
A form list containing all of the tiered item lists in order from lowest tier to highest tier}

int LEVELS_BETWEEN_TIERS = 7 Const

Function Inject()
	InjectIntoList(PATTP_PossibleLegendaryItemBaseLists_PowerArmor_Top, itemToInject, level)

	LeveledItem legendaryTierList = LegendaryTierListForLevel(level)

	if (!legendaryTierList)
		debug.trace("Unable to find a legendary tiered list for " + Self + " at level " + level)
		return
	endif

	InjectIntoList(legendaryTierList, itemToInject, level)
EndFunction

LeveledItem Function LegendaryTierListForLevel(int level)
	int index = (level / LEVELS_BETWEEN_TIERS)

	; Ensure we are in bounds
	index = Math.Min(index, PATTP_LegendaryTierLists_Sorted.GetSize()) as int
	index = Math.Max(index, 0) as int

	debug.trace(Self + " should insert into tiered legendary list at index " + index + " because it is level " + level)

	return PATTP_LegendaryTierLists_Sorted.GetAt(index) as LeveledItem
EndFunction
