Scriptname LegendaryPowerArmor_InjectLegendaries extends Quest

Int Property count = 1 Auto Const
{How many of the item should be returned}

Int Property level Auto Const
{The level at which the item should start appearing}

LeveledItem[] Property injectInto Auto Const
{The lists that the item should be injected into}

LeveledItem Property listToInject Auto Const
{The list that should be injected into the other lists with the specified count and level}

int iter = 0

Event OnInit()
	iter = 0
	
	while(iter < injectInto.length)
		injectInto[iter].AddForm(listToInject, level, count)
		iter += 1
	endwhile
EndEvent