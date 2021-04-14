Scriptname PAttP:InjectItemIntoLeveledList extends Quest
{Injects an item into one or more leveled lists with the specified count and level}

Int Property count = 1 Auto Const
{How many of the item should be returned}

Int Property level = 1 Auto Const
{The level at which the item should start appearing}

LeveledItem[] Property injectInto Auto Const
{The lists that the item should be injected into}

LeveledItem Property itemToInject Auto Const
{The item that should be injected into the other lists with the specified count and level}

GlobalVariable Property ShouldInject Auto Const
{If the value held by this variable is greater than 0, the provided injections will all take place - otherwise, they will be skipped}

PAttP:InjectionManager Property injectionManager Auto Const

Event OnInit()
    RegisterCustomEvents()
    Inject()
EndEvent

Function Inject()
	if (ShouldInject.GetValueInt() > 0)
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
        debug.trace("Skipping injection of " + itemToInject + " into " + injectInto)
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
