Scriptname PAttP:InjectArmorIntoLeveledList extends Quest
{Injects one or more armor pieces into one or more leveled lists with the specified count and level}

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

InjectionInfo[] Property injections Auto Const

Event OnInit()
	int iter = 0
	
	while(iter < injections.length)
		InjectionInfo currentInjection = injections[iter]

		currentInjection.injectInto.AddForm(currentInjection.itemToInject, currentInjection.level, currentInjection.count)
		iter += 1
	endwhile
EndEvent
