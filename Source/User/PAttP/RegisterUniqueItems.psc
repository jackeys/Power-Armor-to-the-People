Scriptname PAttP:RegisterUniqueItems Extends Quest const

Struct UniqueItemReplacement

    String ID
    {Identifier - used to help identify items in array. Not otherwise used.}

    LeveledItem LeveledListToSpawnFrom
    {List to spawn from}

    ObjectMod CosmeticMod

    ObjectMod MiscMod
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

Event OnQuestInit()
    RegisterUniques()
    RegisterTriggers()
EndEvent

Function RegisterUniques()
    if !UniqueItems
        return
    EndIf

    int i = 0
    while i < UniqueItems.Length
        UniqueItemReplacement uniqueItem = UniqueItems[i]
        debug.trace(self + " is overriding unique item " + uniqueItem.ID)
        PATTP_UniqueItemManager.OverrideUniqueItem(uniqueItem.ID, uniqueItem.MiscMod, uniqueItem.CosmeticMod, uniqueItem.LeveledListToSpawnFrom)
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
