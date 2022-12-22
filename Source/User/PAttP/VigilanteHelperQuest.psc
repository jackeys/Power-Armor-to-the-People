Scriptname PAttP:VigilanteHelperQuest extends Quest const
{Script for sending settler vigilantes to help the player}

ActorBase Property VigilanteActor Auto Const Mandatory
{The type of actor to spawn when a vigilante is helping}

Struct REQuestInfo
    REScript EncounterQuest
    int StageToStartHelping = 20 ; For workshop attack quests, this is when the enemies are loaded
    ReferenceAlias VigilanteSpawnLocation
EndStruct

REQuestInfo[] Property QuestsToHelpDuring Auto Const Mandatory

Event OnQuestInit()
    debug.trace(self + " is starting up")
    RegisterForRandomEncounterQuests()
EndEvent

Function RegisterForRandomEncounterQuests()
    int i = 0
    while i < QuestsToHelpDuring.length
        debug.trace(self + " registering for quest " + QuestsToHelpDuring[i])
        RegisterForRemoteEvent(QuestsToHelpDuring[i].EncounterQuest, "OnStageSet")
        i += 1
    EndWhile
EndFunction

Function UnregisterForRandomEncounterQuests()
    int i = 0
    while i < QuestsToHelpDuring.length
        debug.trace(self + " registering for quest " + QuestsToHelpDuring[i])
        UnregisterForRemoteEvent(QuestsToHelpDuring[i].EncounterQuest, "OnStageSet")
        i += 1
    EndWhile
EndFunction

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    debug.trace(self + " heard that quest " + akSender + " reached stage " + auiStageID + " - item " + auiItemID)

    int questIndex = QuestsToHelpDuring.FindStruct("EncounterQuest", akSender as REScript)

    if questIndex < 0
        return
    endIf

    REQuestInfo questInfo = QuestsToHelpDuring[questIndex]

    ; Only look at item 0 so that we don't spawn multiple vigilantes if a quest sets a stage multiple times
    if questInfo.StageToStartHelping == auiStageID && auiItemID == 0
        debug.trace(self + " spawning a vigilante to help during " + questInfo)
        questInfo.VigilanteSpawnLocation.GetRef().PlaceAtMe(VigilanteActor)
    endIf
EndEvent