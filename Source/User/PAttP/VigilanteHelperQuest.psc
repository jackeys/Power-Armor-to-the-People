Scriptname PAttP:VigilanteHelperQuest extends Quest
{Script for sending settler vigilantes to help the player}

RefCollectionAlias Property Vigilantes Auto Const mandatory
{A refcollection that can be used to register against the random encounter - will be filled dynamically }

ActorBase Property VigilanteActor Auto Const Mandatory
{The type of actor to spawn when a vigilante is helping}

Struct REQuestInfo
    REScript EncounterQuest
    int StageToStartHelping = 20 ; For workshop attack quests, this is when the enemies are loaded
    ReferenceAlias VigilanteSpawnLocation
EndStruct

REQuestInfo[] Property QuestsToHelpDuring Auto Const Mandatory

Event OnQuestInit()
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

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    debug.trace(self + " heard that quest " + akSender + " reached stage " + auiStageID)

    int questIndex = QuestsToHelpDuring.FindStruct("EncounterQuest", akSender as REScript)

    if questIndex < 0
        return
    endIf

    REQuestInfo questInfo = QuestsToHelpDuring[questIndex]

    if questInfo.StageToStartHelping == auiStageID
        debug.trace(self + " spawning a vigilante to help during " + questInfo)
        ; Register our vigilantes to make sure they get cleaned up
        questInfo.EncounterQuest.RegisterCollectionAlias(Vigilantes)
        Vigilantes.AddRef(questInfo.VigilanteSpawnLocation.GetRef().PlaceAtMe(VigilanteActor))
    endIf
EndEvent