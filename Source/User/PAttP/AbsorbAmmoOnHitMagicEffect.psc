Scriptname PAttP:AbsorbAmmoOnHitMagicEffect extends ActiveMagicEffect const
{Has a chance of absorbing ammo from a hit}

float Property AbsorbChance Auto Const Mandatory
{The chance that the ammo will be added to the target's inventory when hit}

FormList Property IncludedWeaponKeywords Auto Const
{A weapon must have a keyword from this list for its ammo to be absorbed. If excluded, all weapons are valid}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForHitEvent(akTarget)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	Weapon sourceWeapon = akSource as Weapon
	if sourceWeapon && WeaponShouldBeIncluded(sourceWeapon) && Utility.RandomFloat(0, 100) <= AbsorbChance
		debug.trace(akTarget + " was hit, absorbing " + sourceWeapon.GetAmmo() + " ammo from " + sourceWeapon)
		akTarget.AddItem(sourceWeapon.GetAmmo())
	endIf
	
	RegisterForHitEvent(akTarget)
EndEvent

bool Function WeaponShouldBeIncluded(Weapon akWeapon)
	if !IncludedWeaponKeywords
		return true
	endif

	int i = 0
	while i < IncludedWeaponKeywords.GetSize()
		Keyword InclusionKeyword = IncludedWeaponKeywords.GetAt(i) as Keyword
		if akWeapon.HasKeyword(InclusionKeyword)
			return true
		endIf
		
		i += 1
		endWhile
		
	debug.trace(self + ": Weapon " + akWeapon + " does not have a keyword from " + IncludedWeaponKeywords + " and cannot be absorbed")
	return false
EndFunction