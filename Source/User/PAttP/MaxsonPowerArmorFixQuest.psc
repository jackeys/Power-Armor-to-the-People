Scriptname PAttP:MaxsonPowerArmorFixQuest extends Quest
{Fixes Maxson's power armor for the main quest when he wears a set all of the time}

Struct QuestTracker
    Quest questToTrack
    {A quest where Maxson will be forced into a different set of power armor}

    int stageToRemovePowerArmor
    {The stage of the quest where Maxson should leave his armor}

    Quest dependentQuest = None
    {If another quest must also be in progress for this to happen, put it here}

    int dependentQuestMinimumStage = -1
    {The stage the dependent quest must have reached for triggers to start working for the questToTrack}
EndStruct

QuestTracker[] Property QuestsWherePAIsForced Auto Const Mandatory
{The list of quests where Maxson is forced into a different power armor frame}

ReferenceAlias Property actorWearingPowerArmor Auto Const Mandatory
{Maxon's reference alias}

Keyword Property VertibirdSlotKeyword Auto Const Mandatory
{Keyword that needs to be removed for the final battle so Maxson drops down on the correct side of the vertibird}

Event OnQuestInit()
    StartTrackingQuests()
EndEvent

Function StartTrackingQuests()
    int i = 0
    while i < QuestsWherePAIsForced.length
        if !QuestsWherePAIsForced[i].questToTrack.IsCompleted()
            debug.trace(self + " is tracking stage changes for " + QuestsWherePAIsForced[i])
            RegisterForRemoteEvent(QuestsWherePAIsForced[i].questToTrack, "OnStageSet")
        EndIf

        i += 1
    endWhile
EndFunction

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    int trackerIndex = QuestsWherePAIsForced.FindStruct("questToTrack", akSender)

    if trackerIndex >= 0 && auiStageID == QuestsWherePAIsForced[trackerIndex].stageToRemovePowerArmor
        debug.trace(self + " tracked quest " + akSender + " reached stage " + auiStageID)
        if !QuestsWherePAIsForced[trackerIndex].dependentQuest || QuestsWherePAIsForced[trackerIndex].dependentQuest.GetStage() >= QuestsWherePAIsForced[trackerIndex].dependentQuestMinimumStage
            ExitPowerArmor()
            actorWearingPowerArmor.GetActorRef().RemoveKeyword(VertibirdSlotKeyword)
        endIf
    endIf

    if akSender.IsCompleted()
        UnregisterForRemoteEvent(akSender, "OnStageSet")
    endIf
EndEvent

Function ExitPowerArmor()
    debug.trace(self + " forcing " + actorWearingPowerArmor + " to exit power armor")
    actorWearingPowerArmor.GetActorRef().SwitchToPowerArmor(None)
EndFunction