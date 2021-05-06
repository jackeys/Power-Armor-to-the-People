Scriptname PAttP:InjectItemIntoExternalLeveledList extends Quest
{Inject a leveled item into another leveled item in a plugin that does not belong to Power Armor to the People. If you are injecting into Power Armor to the People, DO NOT USE THIS SCRIPT. This is a one-time script and cannot be refreshed like internal injections can be, so updates can only be applied to the Leveled Items being injected.}

Struct InjectionInfo
    Int Count = 1
    {How many of the item should be returned}
    
    Int Level = -1
    {The level at which the item should start appearing. If this isn't set, the DefaultLevel will be used.}
    
    LeveledItem InjectInto
    {The list that the item should be injected into}
    
    LeveledItem ItemToInject
    {The item that should be injected into the list. This is the only piece that can be updated for existing users, so having a single item that references many items within your mod is better than injecting many items into the same list}
    
EndStruct
    
Int Property DefaultLevel = 1 Auto Const
{Default value for any injection that doesn't override the level}

InjectionInfo[] Property Injections Auto Const Mandatory

Event OnQuestInit()
    Inject()
EndEvent

Function InjectIntoList(LeveledItem akInjectInto, Form akItemToInject, int aiLevel, int aiCount = 1)
    debug.trace(self + " injecting " + akItemToInject + " into " + akInjectInto + " at level " + aiLevel)
    akInjectInto.AddForm(akItemToInject, aiLevel, aiCount)
EndFunction

Function Inject()
    int i = 0
	while(i < injections.length)
		InjectionInfo currentInjection = injections[i]
		
		; If the level is not specified for this injection, use the default
		int level = currentInjection.level

		if level < 0
			level = DefaultLevel
		endif

		InjectIntoList(currentInjection.InjectInto, currentInjection.ItemToInject, Level, currentInjection.Count)
		i += 1
	endwhile
EndFunction
