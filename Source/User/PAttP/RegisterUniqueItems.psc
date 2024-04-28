Scriptname PAttP:RegisterUniqueItems Extends Quest const

Struct UniqueItemReplacement

    String ID
    {Identifier - used to help identify items in array. Not otherwise used.}

    LeveledItem LeveledListToSpawnFrom
    {List to spawn from}

    ObjectMod CosmeticMod

    ObjectMod MiscMod

    bool ItemAlreadyPlaced = false
    {If the item is being manually placed outside of the unique item handler, set this to true}
EndStruct

Struct UniqueItemTrigger
    String ID

    Quest TriggerQuest

    int TriggerStage = -1

    ObjectReference ReferenceToSpawnIn
EndStruct

UniqueItemReplacement[] Property UniqueItems Const Auto
UniqueItemTrigger[] Property Triggers Const Auto
PAttP:UniqueItemManager Property PATTP_UniqueItemManager Const Auto Mandatory
{AUTOFILL}

bool Property StopAfterRegistration = false Const Auto
{Use this only if the quest does not need to keep running for other reasons}

Event OnQuestInit()
    ; Triggers don't set the IsFallback flag to false, so they won't cause the item to be placed
    ; Triggers need to happen first to make sure the item doesn't get placed in the wrong spot
    RegisterTriggers()
    RegisterUniques()

    if StopAfterRegistration
        Stop()
    endIf
EndEvent

Function RegisterUniques()
    if !UniqueItems
        return
    EndIf

    int i = 0
    while i < UniqueItems.Length
        UniqueItemReplacement uniqueItem = UniqueItems[i]
        debug.trace(self + " is overriding unique item " + uniqueItem.ID)
        PATTP_UniqueItemManager.OverrideUniqueItem(uniqueItem.ID, uniqueItem.MiscMod, uniqueItem.CosmeticMod, uniqueItem.LeveledListToSpawnFrom, uniqueItem.ItemAlreadyPlaced)
        i += 1
    EndWhile
EndFunction

Function RegisterTriggers()
    if !Triggers
        return
    EndIf

    int i = 0
    while i < Triggers.Length
        UniqueItemTrigger uniqueItemTrigger = Triggers[i]
        debug.trace(self + " is overriding unique item " + uniqueItemTrigger.ID)
        PATTP_UniqueItemManager.OverrideUniqueItemTrigger(uniqueItemTrigger.ID, uniqueItemTrigger.ReferenceToSpawnIn, uniqueItemTrigger.TriggerQuest, uniqueItemTrigger.TriggerStage)
        i += 1
    EndWhile
EndFunction
