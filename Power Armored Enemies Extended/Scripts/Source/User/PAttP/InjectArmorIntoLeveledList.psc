Scriptname PAttP:InjectArmorIntoLeveledList extends Quest
{Injects an item into one or more leveled lists with the specified count and level}

Int Property count = 1 Auto Const
{How many of the item should be returned}

Int Property level = 1 Auto Const
{The level at which the item should start appearing}

LeveledItem[] Property injectInto Auto Const
{The lists that the item should be injected into}

Armor Property itemToInject Auto Const
{The item that should be injected into the other lists with the specified count and level}

int iter = 0

Event OnInit()
	iter = 0
	
	while(iter < injectInto.length)
		injectInto[iter].AddForm(itemToInject, level, count)
		iter += 1
	endwhile
EndEvent
