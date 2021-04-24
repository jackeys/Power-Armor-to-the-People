Scriptname PAttP:InjectItemIntoPAttPLeveledList extends PAttP:InjectionQuest
{Injects an item into one or more leveled lists within Power Armor to the People with the specified count and level. This should ONLY be used for Power Armor to the People lists, as it registers the list it injects into for automatic reversion and re-injection.}

Int Property count = 1 Auto Const
{How many of the item should be returned}

Int Property level = 1 Auto Const
{The level at which the item should start appearing}

LeveledItem[] Property injectInto Auto Const Mandatory
{The lists that the item should be injected into}

LeveledItem Property itemToInject Auto Const Mandatory
{The item that should be injected into the other lists with the specified count and level}

Function Inject()
	int iter = 0
	while(iter < injectInto.length)
		InjectIntoList(injectInto[iter], itemToInject, level, count)
		iter += 1
	endwhile
EndFunction
