Scriptname PAttP:EquipUnequipPAHelmet extends ActiveMagicEffect const
{Causes an NPC to take their power armor helmet off outside of combat}

Form Property PAHelmet Auto Const Mandatory
{The helmet the actor should equip/unequip. They must have it in their inventory.}

QuestTracker[] Property AlwaysOnWhenQuestsActive Auto Const
{If any of these quests are active, the helmet will be on}

Struct QuestTracker
    Quest questToTrack
    int minimumStage
    bool takeOffAtStageInstead = false
EndStruct

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForRemoteEvent(akTarget, "OnCombatStateChanged")
    StartTrackingQuests()
    ChangeHelmetEquipState(akTarget, akTarget.GetCombatState())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForRemoteEvent(akTarget, "OnCombatStateChanged")
    UnregisterQuests()
EndEvent

Function UnregisterQuests()
    int i = 0
    while i < AlwaysOnWhenQuestsActive.length
        UnregisterForRemoteEvent(AlwaysOnWhenQuestsActive[i].questToTrack, "OnStageSet")
         i += 1
    endWhile
EndFunction

Event Actor.OnCombatStateChanged(Actor akSender, Actor akTarget, int aeCombatState)
    ChangeHelmetEquipState(akSender, aeCombatState)
EndEvent

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    ChangeHelmetEquipState(GetTargetActor(), GetTargetActor().GetCombatState())

    if akSender.IsCompleted()
        UnregisterForRemoteEvent(akSender, "OnStageSet")
    endIf
EndEvent

Function ChangeHelmetEquipState(Actor akWearer, int aeCombatState)
    ; Not in combat - remove the helmet
    if aeCombatState == 0 && !ImportantQuestInProgress()
        akWearer.UnequipItem(PAHelmet, true, true)
    else
        akWearer.EquipItem(PAHelmet, true, true)
    endIf
EndFunction

Function StartTrackingQuests()
    int i = 0
    while i < AlwaysOnWhenQuestsActive.length
        if !AlwaysOnWhenQuestsActive[i].questToTrack.IsCompleted()
            RegisterForRemoteEvent(AlwaysOnWhenQuestsActive[i].questToTrack, "OnStageSet")
        EndIf

        i += 1
    endWhile
EndFunction

bool Function ImportantQuestInProgress()
    int i = 0
    while i < AlwaysOnWhenQuestsActive.length
        QuestTracker currentQuestTracker = AlwaysOnWhenQuestsActive[i]
        if !currentQuestTracker.questToTrack.IsCompleted() 
            if !currentQuestTracker.takeOffAtStageInstead && currentQuestTracker.questToTrack.GetStage() >= currentQuestTracker.minimumStage
                return true
            elseif currentQuestTracker.takeOffAtStageInstead && currentQuestTracker.questToTrack.isRunning() && currentQuestTracker.questToTrack.GetStage() < currentQuestTracker.minimumStage
                return true
            endIf
        endIf

        i += 1
    endWhile

    return false
EndFunction