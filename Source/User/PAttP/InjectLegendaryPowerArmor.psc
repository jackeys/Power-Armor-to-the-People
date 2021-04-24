Scriptname PAttP:InjectLegendaryPowerArmor extends Quest
{Injects an item into the list of potential legendary power armor sets. The correct leveled list to inject into is determined automatically based on the level the power armor should be available. This should only be used for Power Armor to the People, as it registers the list it injects into for automatic reversion and re-injection.}

Int Property level Auto Const Mandatory
{The level at which the item should start appearing}

LeveledItem Property itemToInject Auto Const Mandatory
{The item list to inject as a possible legendary power armor set - this should include any appropriate lists to ensure the correct linings are used at appropriate levels, and only 1 item should be returned}

GlobalVariable Property ShouldInject Auto Const
{If provided, the value held by this variable is greater than 0, the provided injections will all take place - otherwise, they will be skipped}

LeveledItem Property PATTP_PossibleLegendaryItemBaseLists_PowerArmor_Top Auto Const Mandatory
{Autofill
A list that holds all power armor pieces at their appropriate levels, which can be used as a fallback if nothing is available at an available tier}

FormList Property PATTP_LegendaryTierLists_Sorted Auto Const Mandatory
{Autofill
A form list containing all of the tiered item lists in order from lowest tier to highest tier}

PAttP:InjectionManager Property injectionManager Auto Const Mandatory
{Autofill}

Event OnQuestInit()
    RegisterCustomEvents()
    Inject()
EndEvent

Function Inject()
	if (!ShouldInject || ShouldInject.GetValueInt() > 0)
		debug.trace("Beginning injection " + Self + " of " + itemToInject + " into legendary lists")

		; Register here so that if we inject into new lists in an update they are captured
		RegisterAndInjectInto(PATTP_PossibleLegendaryItemBaseLists_PowerArmor_Top)

		LeveledItem legendaryTierList = LegendaryTierListForLevel(level)

		if (!legendaryTierList)
			debug.trace("Unable to find a legendary tiered list for " + Self + " at level " + level)
			return
		endif

		RegisterAndInjectInto(legendaryTierList)
	else
        debug.trace("Skipping injection " + Self + " of " + itemToInject + " into legendary lists")
	endif
EndFunction

Function RegisterAndInjectInto(LeveledItem injectInto)
	injectionManager.RegisterInjection(injectInto)

	debug.trace(Self + " Injecting " + itemToInject + " into " + injectInto + " at level " + level)
	injectInto.AddForm(itemToInject, level, 1)
EndFunction

LeveledItem Function LegendaryTierListForLevel(int level)
	; Every 10 levels is a new tier, with the first starting at level 10
	int index = (level / 10) - 1

	; Ensure we are in bounds
	index = Math.Min(index, PATTP_LegendaryTierLists_Sorted.GetSize()) as int
	index = Math.Max(index, 0) as int

	debug.trace(Self + " should insert into tiered legendary list at index " + index + " because it is level " + level)

	return PATTP_LegendaryTierLists_Sorted.GetAt(index) as LeveledItem
EndFunction

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People injection refreshes")
    RegisterForCustomEvent(injectionManager, "RefreshInjection")
EndFunction

Event PAttP:InjectionManager.RefreshInjection(PAttP:InjectionManager akSender, Var[] akArgs)
	if akSender == injectionManager
		Inject()
	else
		debug.trace(Self + " is ignoring injection refresh from unknown injection manager " + akSender)
	endif
EndEvent

