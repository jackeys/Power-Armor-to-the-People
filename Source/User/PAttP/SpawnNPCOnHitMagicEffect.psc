Scriptname PAttP:SpawnNPCOnHitMagicEffect extends ActiveMagicEffect const
{Has a chance of spawning an NPC at the target's location when they are hit}

Form Property NPCToSpawn Auto Const Mandatory
{The NPC that should spawn}

float Property SpawnChance Auto Const
{The chance that an NPC will spawn when hit}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForHitEvent(akTarget)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	if Utility.RandomFloat(0, 100) <= SpawnChance
		debug.trace(akTarget + " was hit, spawning " + NPCToSpawn)
		akTarget.PlaceAtMe(NPCToSpawn)
	endIf

	RegisterForHitEvent(akTarget)
EndEvent