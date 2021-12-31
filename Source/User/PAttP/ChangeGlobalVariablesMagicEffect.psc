Scriptname PAttP:ChangeGlobalVariablesMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Struct GlobalChange
	GlobalVariable Variable
	{The Global Variable that should be modified when the magic effect starts/stops}

	float ChangeInValue
	{The flat amount by which to change the global variable (this will be added when the effect is active and subtracted when it stops)}
EndStruct

GlobalChange[] Property Changes Auto Const Mandatory

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int i = 0
	while i < Changes.length
		debug.trace(self + " adjusting " + Changes[i].Variable + " by " + Changes[i].ChangeInValue)
		Changes[i].Variable.SetValue(Changes[i].Variable.GetValue() + Changes[i].ChangeInValue)
		i += 1
	EndWhile
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	while i < Changes.length
		debug.trace(self + " adjusting " + Changes[i].Variable + " by " + (-1 * Changes[i].ChangeInValue))
		Changes[i].Variable.SetValue(Changes[i].Variable.GetValue() - Changes[i].ChangeInValue)
		i += 1
	EndWhile
EndEvent
