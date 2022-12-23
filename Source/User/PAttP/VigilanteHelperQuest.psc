Scriptname PAttP:VigilanteHelperQuest extends Quest const
{Script for sending settler vigilantes to help the player}

ActorBase Property VigilanteActor Auto Const Mandatory
{The type of actor to spawn when a vigilante is helping}

GlobalVariable Property SuccessfulPlayerDefenses Auto Const Mandatory
GlobalVariable Property VigilanteChance Auto Const Mandatory
Keyword Property IncreaseChanceIfPlayerWearingKeyword Auto Const Mandatory

int Property MinSuccessfulDefensesBeforeVigilantesHelp = 5 Auto Const Mandatory
int Property SuccessfulDefensesForUniqueItem = 10 Auto Const Mandatory
int Property UniqueItemGivenStage = 20 Auto Const Mandatory

Struct WorkshopAttackQuestInfo
    WorkshopAttackScript EncounterQuest
    ReferenceAlias VigilanteSpawnLocation
EndStruct

WorkshopAttackQuestInfo[] Property WorkshopAttacksToHelpDuring Auto Const Mandatory

Event OnQuestInit()
    debug.trace(self + " is starting up")
    RegisterForRandomEncounterQuests()
EndEvent

Function RegisterForRandomEncounterQuests()
    int i = 0
    while i < WorkshopAttacksToHelpDuring.length
        debug.trace(self + " registering for quest " + WorkshopAttacksToHelpDuring[i])
        RegisterForRemoteEvent(WorkshopAttacksToHelpDuring[i].EncounterQuest, "OnStageSet")
        i += 1
    EndWhile
EndFunction

Function UnregisterForRandomEncounterQuests()
    int i = 0
    while i < WorkshopAttacksToHelpDuring.length
        debug.trace(self + " registering for quest " + WorkshopAttacksToHelpDuring[i])
        UnregisterForRemoteEvent(WorkshopAttacksToHelpDuring[i].EncounterQuest, "OnStageSet")
        i += 1
    EndWhile
EndFunction

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    debug.trace(self + " heard that quest " + akSender + " reached stage " + auiStageID + " - item " + auiItemID)

    int questIndex = WorkshopAttacksToHelpDuring.FindStruct("EncounterQuest", akSender as WorkshopAttackScript)

    if questIndex < 0
        return
    endIf

    WorkshopAttackQuestInfo questInfo = WorkshopAttacksToHelpDuring[questIndex]

    ; Only look at item 0 so that we don't spawn multiple vigilantes if a quest sets a stage multiple times
    if questInfo.EncounterQuest.attackStartStage == auiStageID && auiItemID == 0
        if SuccessfulPlayerDefenses.GetValueInt() >= MinSuccessfulDefensesBeforeVigilantesHelp && Utility.RandomInt(1, 100) <= GetChance()
            debug.trace(self + " spawning a vigilante to help during " + questInfo)
            questInfo.VigilanteSpawnLocation.GetRef().PlaceAtMe(VigilanteActor)
        else
            debug.trace(self + " not enough player defenses or vigilante chance was not chosen - no vigilante is coming to help")
        endIf
    elseif questInfo.EncounterQuest.attackDoneStage == auiStageID && auiItemID == 0
        SuccessfulPlayerDefenses.Mod(1)
        debug.trace(self + " incrementing successful defense count to " + SuccessfulPlayerDefenses.GetValueInt())

        if GetStage() < UniqueItemGivenStage && SuccessfulPlayerDefenses.GetValueInt() >= SuccessfulDefensesForUniqueItem
            debug.trace(self + " enough settlements have been defended - awarding unique item!")
            SetStage(UniqueItemGivenStage) 
        endIf
    endIf
EndEvent

int Function GetChance()
    int chance = VigilanteChance.GetValueInt()

    if Game.GetPlayer().WornHasKeyword(IncreaseChanceIfPlayerWearingKeyword)
        chance *= 2
    endIf

    return chance
EndFunction