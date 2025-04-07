Scriptname PAttP:BefriendCombatTargetsMagicEffect extends ActiveMagicEffect const
{Can make combat targets friendly to the player}

FormList Property TargetKeywords auto const mandatory
{Targets are only valid to be befriended if they have one of these keywords}

Faction Property PlayerAllyFaction auto const Mandatory

GlobalVariable Property NextTimeBefriendCanHappen auto const Mandatory

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
        StartTimer(3.0)
    EndIf
EndEvent

Event OnTimer(int aiTimerID)
    if IsBoundGameObjectAvailable()
        debug.trace(self + " looking for friends...")
        int i = 0
        Actor[] targets = Game.GetPlayer().GetAllCombatTargets()
        while i < targets.length
            Actor potentialFriend = targets[i]

            if potentialFriend.HasKeywordInFormList(TargetKeywords) && potentialFriend.GetLevel() <= Game.GetPlayer().GetLevel() && !potentialFriend.IsDead() && !potentialFriend.IsEssential()
                Befriend(potentialFriend)
                return
            EndIf

            i += 1
        endWhile
    endIf
EndEvent

Function Befriend(Actor akTarget)
    debug.trace(self + " befriending " + akTarget)
    akTarget.RemoveFromAllFactions()
    akTarget.SetFactionRank(PlayerAllyFaction, 1)
    NextTimeBefriendCanHappen.SetValue(Utility.GetCurrentGameTime() + CooldownDays)
EndFunction