Scriptname PAttP:InjectItemIntoPAttPLeveledList extends Quest
{Injects an item into one or more leveled lists within Power Armor to the People with the specified count and level. This should ONLY be used for Power Armor to the People lists, as it registers the list it injects into for automatic reversion and re-injection.}

Int Property count = 1 Auto Const
{How many of the item should be returned}

Int Property level = 1 Auto Const
{The level at which the item should start appearing}

LeveledItem[] Property injectInto Auto Const Mandatory
{The lists that the item should be injected into}

LeveledItem Property itemToInject Auto Const Mandatory
{The item that should be injected into the other lists with the specified count and level}

GlobalVariable Property ShouldInject Auto Const
{If provided, the value held by this variable is greater than 0, the provided injections will all take place - otherwise, they will be skipped}

PAttP:InjectionManager Property injectionManager Auto Const Mandatory
{Autofill}

Event OnInit()
    RegisterCustomEvents()
    Inject()
EndEvent

Function Inject()
	if (!ShouldInject || ShouldInject.GetValueInt() > 0)
		debug.trace("Beginning injection " + Self)

		int iter = 0
		while(iter < injectInto.length)
			LeveledItem currentInjectInto = injectInto[iter]

			; Register here so that if we inject into new lists in an update they are captured
			injectionManager.RegisterInjection(currentInjectInto)

			debug.trace("Injecting " + itemToInject + " into " + currentInjectInto + " at level " + level)
			currentInjectInto.AddForm(itemToInject, level, count)
			iter += 1
		endwhile
	else
        debug.trace("Skipping injection " + Self + " of " + itemToInject + " into " + injectInto)
	endif
EndFunction

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People injection refreshes")
    RegisterForCustomEvent(injectionManager, "RefreshInjection")
EndFunction

Event PAttP:InjectionManager.RefreshInjection(PAttP:InjectionManager akSender, Var[] akArgs)
	if akSender == injectionManager
		Inject()
	else
		debug.trace("Ignoring injection refresh from unknown injection manager " + akSender)
	endif
EndEvent

