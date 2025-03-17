Scriptname PAttP:MaxsonPowerArmorFixQuest extends Quest
{Fixes Maxson's power armor for the main quest when he wears a set all of the time}

Struct QuestTracker
    Quest questToTrack
    {A quest where Maxson will be forced into a different set of power armor}

    int stageToRemovePowerArmor
    {The stage of the quest where Maxson should leave his armor}
EndStruct

QuestTracker[] Property QuestsWherePAIsForced Auto Const Mandatory
{The list of quests where Maxson is forced into a different power armor frame}

ReferenceAlias Property actorWearingPowerArmor Auto Const Mandatory
{Maxon's reference alias}

Event OnQuestInit()
    StartTrackingQuests()
EndEvent

Function StartTrackingQuests()
    int i = 0
    while i < QuestsWherePAIsForced.length
        if !QuestsWherePAIsForced[i].questToTrack.IsCompleted()
            RegisterForRemoteEvent(QuestsWherePAIsForced[i].questToTrack, "OnStageSet")
        EndIf

        i += 1
    endWhile
EndFunction

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    int trackerIndex = QuestsWherePAIsForced.FindStruct("questToTrack", akSender)

    if trackerIndex >= 0 && auiStageID == QuestsWherePAIsForced[trackerIndex].stageToRemovePowerArmor
        debug.trace(self + " tracked quest " + akSender + " reached stage " + auiStageID)
        ExitPowerArmor()
    endIf

    if akSender.IsCompleted()
        UnregisterForRemoteEvent(akSender, "OnStageSet")
    endIf
EndEvent

Function ExitPowerArmor()
    debug.trace(self + " forcing " + actorWearingPowerArmor + " to exit power armor")
    actorWearingPowerArmor.GetActorRef().SwitchToPowerArmor(None)
EndFunction