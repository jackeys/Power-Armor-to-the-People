Scriptname PAttP:AddSpellOnPowerAttackMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

float Property SpellChance = 100.0 Auto Const
{The chance that the spell will be added when the target is hit}

float Property MinimumDelayBetweenHits = 0.0 Auto Const
{How many seconds to wait before the spell can be applied again}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterHitEvent()
EndEvent

Function RegisterHitEvent()
	if IsBoundGameObjectAvailable()
		RegisterForHitEvent(GetTargetActor(), akAggressorFilter = GetCasterActor())
	endIf
EndFunction

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	Actor targetActor = akTarget as Actor
	debug.trace(self + " " + akAggressor + " hit " + akTarget + " | Power attack: " + abPowerAttack)
	if abPowerAttack && targetActor && Utility.RandomFloat(0, 100) <= SpellChance
		debug.trace(targetActor + " was hit by a power attack, casting spell " + SpellToApply + " from " + akAggressor)
		SpellToApply.Cast(akAggressor, targetActor)
		
		if MinimumDelayBetweenHits > 0.0
			StartTimer(MinimumDelayBetweenHits)
			return
		EndIf
	endIf

	RegisterHitEvent()
EndEvent

Event OnTimer(int aiTimerID)
	RegisterHitEvent()
EndEvent
