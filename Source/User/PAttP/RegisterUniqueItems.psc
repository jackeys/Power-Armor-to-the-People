Scriptname PAttP:RegisterUniqueItems Extends Quest const

Struct UniqueItemReplacement

    String ID
    {Identifier - used to help identify items in array. Not otherwise used.}

    LeveledItem LeveledListToSpawnFrom
    {List to spawn from}

    ObjectMod CosmeticMod

    ObjectMod MiscMod
EndStruct

UniqueItemReplacement[] Property UniqueItems Const Auto Mandatory
PAttP:UniqueItemManager Property PATTP_UniqueItemManager Const Auto Mandatory
{AUTOFILL}

Event OnInit()
    RegisterUniques()
EndEvent

Function RegisterUniques()
    int i = 0
    while i < UniqueItems.Length
        UniqueItemReplacement uniqueItem = UniqueItems[i]
        debug.trace(self + " is overriding unique item " + uniqueItem.ID)
        PATTP_UniqueItemManager.OverrideUniqueItem(uniqueItem.ID, uniqueItem.MiscMod, uniqueItem.CosmeticMod, uniqueItem.LeveledListToSpawnFrom)
        i += 1
    EndWhile
EndFunction

