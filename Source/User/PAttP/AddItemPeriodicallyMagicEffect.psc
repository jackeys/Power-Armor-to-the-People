Scriptname PAttP:AddItemPeriodicallyMagicEffect extends ActiveMagicEffect const
{Adds a specific item to the target's inventory on a specific game timer period}

Form Property ItemToAdd Auto Const
{The item that should be added to the target's inventory}

float Property IntervalInSeconds Auto Const Mandatory
{The number of real world seconds between each time the item is added}

GlobalVariable Property RequireWeaponWithMatchingAmmoType Auto Const
{If provided and set to 1, the target has to have a weapon with an ammo type that matches the item to add}

int Property NumberToAdd = 1 Auto Const 
{How many of the item should be added on each interval}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(IntervalInSeconds)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
EndEvent

Event OnTimer(int aiTimerID)
	if IsBoundGameObjectAvailable()
		Actor target = GetTargetActor()
		if !RequireWeaponWithMatchingAmmoType || RequireWeaponWithMatchingAmmoType.GetValueInt() == 0 || target.GetEquippedWeapon().GetAmmo() == ItemToAdd
			target.AddItem(ItemToAdd, NumberToAdd, true)
		endIf

		StartTimer(IntervalInSeconds)
	endIf
EndEvent