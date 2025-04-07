Scriptname PAttP:AddSpellToCombatTargetMagicEffect extends ActiveMagicEffect const
{Applies a spell to a combat target with a lower level than the player every time the cooldown is finished}

FormList Property TargetKeywords auto const mandatory
{Targets are only valid to be Frenzied if they have one of these keywords}

Spell Property SpellToApply auto const Mandatory

GlobalVariable Property NextTimeSpellCanHappen auto const Mandatory

float Property CooldownDays = 0.4 auto const

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForRemoteEvent(akTarget, "OnCombatStateChanged")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForRemoteEvent(akTarget, "OnCombatStateChanged")
EndEvent

Event Actor.OnCombatStateChanged(Actor akSender, Actor akTarget, int aeCombatState)
    if aeCombatState > 0
        ; Wait to get a target count
        StartTimer(1.0)
    EndIf
EndEvent

Event OnTimer(int aiTimerID)
    if IsBoundGameObjectAvailable()
        debug.trace(self + " looking for targets...")
        int i = 0
        Actor[] targets = Game.GetPlayer().GetAllCombatTargets()
        while i < targets.length
            Actor potentialTarget = targets[i]

            if potentialTarget.HasKeywordInFormList(TargetKeywords) && potentialTarget.GetLevel() <= Game.GetPlayer().GetLevel() && !potentialTarget.IsDead() && !potentialTarget.IsEssential()
                CastSpell(potentialTarget)
                return
            EndIf

            i += 1
        endWhile
    endIf
EndEvent

Function CastSpell(Actor akTarget)
    debug.trace(self + " applying spell to " + akTarget)
    
    SpellToApply.Cast(akTarget)
    NextTimeSpellCanHappen.SetValue(Utility.GetCurrentGameTime() + CooldownDays)
EndFunction