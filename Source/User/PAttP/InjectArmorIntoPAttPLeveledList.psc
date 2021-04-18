Scriptname PAttP:InjectArmorIntoPAttPLeveledList extends Quest
{Injects one or more armor pieces into one or more leveled lists within Power Armor to the People with the specified count and level. This should ONLY be used for Power Armor to the People lists, as it registers the list it injects into for automatic reversion and re-injection.}

Struct InjectionInfo

Int count = 1
{How many of the item should be returned}

Int level = 1
{The level at which the item should start appearing}

LeveledItem injectInto
{The lists that the item should be injected into}

Armor itemToInject
{The item that should be injected into the other lists with the specified count and level}

EndStruct

InjectionInfo[] Property injections Auto Const Mandatory
PAttP:InjectionManager Property injectionManager Auto Const Mandatory
{Autofill}
GlobalVariable Property ShouldInject Auto Const
{If provided, the value held by this variable is greater than 0, the provided injections will all take place - otherwise, they will be skipped}

Event OnInit()
    RegisterCustomEvents()
    Inject()
EndEvent

Function Inject()
    if (!ShouldInject || ShouldInject.GetValueInt() > 0)
		debug.trace("Beginning injection " + Self)

		int iter = 0
		while(iter < injections.length)
			InjectionInfo currentInjection = injections[iter]

			; Register here so that if we inject into new lists in an update they are captured
			injectionManager.RegisterInjection(currentInjection.injectInto)

			debug.trace("Injecting " + currentInjection.itemToInject + " into " + currentInjection.injectInto + " at level " + currentInjection.level)
			currentInjection.injectInto.AddForm(currentInjection.itemToInject, currentInjection.level, currentInjection.count)
			iter += 1
		endwhile
    else
        debug.trace("Skipping injection " + Self + " of " + injections)
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

