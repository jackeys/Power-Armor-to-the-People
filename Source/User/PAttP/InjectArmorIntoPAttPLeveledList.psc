Scriptname PAttP:InjectArmorIntoPAttPLeveledList extends PAttP:InjectionQuest
{Injects one or more armor pieces into one or more leveled lists within Power Armor to the People with the specified count and level. This should ONLY be used for Power Armor to the People lists, as it registers the list it injects into for automatic reversion and re-injection.}

Struct InjectionInfo

Int count = 1
{How many of the item should be returned}

Int level = -1
{The level at which the item should start appearing. If this isn't set, the DefaultLevel will be used.}

LeveledItem injectInto
{The lists that the item should be injected into}

Armor itemToInject
{The item that should be injected into the other lists with the specified count and level}

EndStruct

Int Property DefaultLevel = 1 Auto Const
{Default value for any injection that doesn't override the level}

InjectionInfo[] Property injections Auto Const Mandatory

Function Inject()
	int iter = 0
	while(iter < injections.length)
		InjectionInfo currentInjection = injections[iter]
		
		; If the level is not specified for this injection, use the default
		int level = currentInjection.level

		if level < 0
			level = DefaultLevel
		endif

		InjectIntoList(currentInjection.injectInto, currentInjection.itemToInject, level, currentInjection.count)
		iter += 1
	endwhile
EndFunction
