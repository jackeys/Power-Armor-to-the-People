Scriptname PAttP:AddItemPeriodicallyMagicEffect extends ActiveMagicEffect const
{Adds a specific item to the target's inventory on a specific game timer period}

Form Property ItemToAdd Auto Const Mandatory
{The item that should be added to the target's inventory}

float Property IntervalInSeconds Auto Const Mandatory
{The number of real world seconds between each time the item is added}

int Property NumberToAdd = 1 Auto Const 
{How many of the item should be added on each interval}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(IntervalInSeconds)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
EndEvent

Event OnTimer(int aiTimerID)
	Actor target = GetTargetActor()
	debug.trace(self + " adding " + NumberToAdd + " " + ItemToAdd + " to inventory of " + target)
	target.AddItem(ItemToAdd, NumberToAdd, true)

	StartTimer(IntervalInSeconds)
EndEvent