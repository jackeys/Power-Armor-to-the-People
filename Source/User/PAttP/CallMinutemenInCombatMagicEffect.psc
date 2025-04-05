Scriptname PAttP:CallMinutemenInCombatMagicEffect extends ActiveMagicEffect const
{Possibly calls the Minutemen when combat begins}

Activator Property PATTP_PAFlareGunProjectileShooter auto const mandatory
{AUTOFILL}

Worldspace Property Commonwealth auto const Mandatory

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForRemoteEvent(akTarget, "OnCombatStateChanged")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForRemoteEvent(akTarget, "OnCombatStateChanged")
EndEvent

Event Actor.OnCombatStateChanged(Actor akSender, Actor akTarget, int aeCombatState)
    if aeCombatState > 0 && akSender.GetWorldspace() == Commonwealth
        ; Wait to get a target count
		StartTimer(3.0)
    EndIf
EndEvent

Event OnTimer(int aiTimerID)
    if IsBoundGameObjectAvailable()
        if GetTargetActor().GetAllCombatTargets().length >= 3
            FireMinutemenFlare(GetTargetActor())
        else
            debug.trace(self + " not calling for Minutemen - only " + GetTargetActor().GetAllCombatTargets().length + " targets")
        endIf
    endIf
EndEvent

Function FireMinutemenFlare(Actor akActor)
    debug.trace(self + " firing a Minutemen flare")
    akActor.PlaceAtMe(PATTP_PAFlareGunProjectileShooter)
EndFunction