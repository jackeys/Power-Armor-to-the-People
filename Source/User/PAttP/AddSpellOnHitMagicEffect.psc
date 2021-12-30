Scriptname PAttP:AddSpellOnHitMagicEffect extends ActiveMagicEffect
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

float Property SpellChance Auto Const Mandatory
{The chance that the spell will be added when the target is hit}

FormList Property IncludedWeaponKeywords Auto Const
{A weapon must have a keyword from this list for its hit to add the spell. If excluded, all weapons are valid}

float Property Duration = 0.0 Auto Const

Actor TargetActor

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForHitEvent(akTarget)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	Weapon sourceWeapon = akSource as Weapon
	TargetActor = akTarget as Actor
	if sourceWeapon && TargetActor && WeaponShouldBeIncluded(sourceWeapon) && Utility.RandomFloat(0, 100) <= SpellChance
		debug.trace(TargetActor + " was hit, adding spell " + SpellToApply)
		TargetActor.AddSpell(SpellToApply, false)
		if Duration > 0
			StartTimer(Duration)
		EndIf
	endIf
	
	RegisterForHitEvent(akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	TargetActor = akTarget as Actor
	if TargetActor
		TargetActor.RemoveSpell(SpellToApply)
	endIf
	CancelTimer()
EndEvent

Event OnTimer(int aiTimerID)
	debug.trace("Removing spell " + SpellToApply + " from " + TargetActor)
	TargetActor.RemoveSpell(SpellToApply)
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
		
	debug.trace(self + ": Weapon " + akWeapon + " does not have a keyword from " + IncludedWeaponKeywords + " and cannot be used to apply a spell")
	return false
EndFunction