Scriptname PAttP:InjectItemsIntoPAttPLeveledLists extends PAttP:InjectionQuest const
{Injects items into leveled lists in Power Armor to the People with the specified count and level. This should ONLY be used for Power Armor to the People lists, as it registers the list it injects into for automatic reversion and re-injection.}

Struct InjectionInfo

	Int Count = 1
	{How many of the item should be returned}
	
	Int Level = -1
	{The level at which the item should start appearing. If this isn't set, the DefaultLevel will be used.}
	
	LeveledItem InjectInto
	{The lists that the item should be injected into}
	
	Form ItemToInject
	{The item that should be injected into the other lists with the specified count and level. This should usually be a LeveledItem so that you can add filter keywords or change it without needing to re-inject, but in some cases it is appropriate to inject an armor piece directly.}
	
	GlobalVariable Enabled
	{If provided, this individual injection will not occur unless this global variable is greater than 0}

EndStruct

Int Property DefaultLevel = 1 Auto Const
{Default value for any injection that doesn't override the level}

InjectionInfo[] Property Injections Auto Const Mandatory

Function Inject()
	int iter = 0
	while(iter < Injections.length)
		InjectionInfo currentInjection = Injections[iter]

		if currentInjection.Enabled == None || currentInjection.Enabled.GetValueInt() > 0
			; If the level is not specified for this injection, use the default
			int level = currentInjection.Level
			
			if level < 0
				level = DefaultLevel
			endif
			
			InjectIntoList(currentInjection.InjectInto, currentInjection.ItemToInject, level, currentInjection.Count)
		Else
			debug.trace(self + " Skipping individual injection " + currentInjection)
		EndIf

		iter += 1
	endwhile
EndFunction
