Scriptname PAttP:EquipUnequipPAHelmet extends ActiveMagicEffect const
{Causes an NPC to take their power armor helmet off outside of combat}

Form Property PAHelmet Auto Const Mandatory
{The helmet the actor should equip/unequip. They must have it in their inventory.}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForRemoteEvent(akTarget, "OnCombatStateChanged")
    ChangeHelmetEquipState(akTarget, akTarget.GetCombatState())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForRemoteEvent(akTarget, "OnCombatStateChanged")
EndEvent

Event Actor.OnCombatStateChanged(Actor akSender, Actor akTarget, int aeCombatState)
    ChangeHelmetEquipState(akSender, aeCombatState)
EndEvent

Function ChangeHelmetEquipState(Actor akWearer, int aeCombatState)
    ; Not in combat - remove the helmet
    if aeCombatState == 0
        akWearer.UnequipItem(PAHelmet, true, true)
    else
        akWearer.EquipItem(PAHelmet, true, true)
    endIf
EndFunction