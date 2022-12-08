Scriptname PAttP:RegisterUniqueItemsEffect Extends ActiveMagicEffect const

String[] Property UniqueItems Const Auto
{IDs of unique items to place on this actor when the effect starts}
PAttP:UniqueItemManager Property PATTP_UniqueItemManager Const Auto Mandatory
{AUTOFILL}

Event OnEffectStart(Actor akTarget, Actor akCaster)
    RegisterTriggers(akTarget)
EndEvent

Function RegisterTriggers(Actor akTarget)
    if !UniqueItems
        return
    EndIf

    int i = 0
    while i < UniqueItems.Length
        string ID = UniqueItems[i]
        debug.trace(self + " is overriding unique item " + ID)
        PATTP_UniqueItemManager.OverrideUniqueItemTrigger(ID, akTarget)
        i += 1
    EndWhile
EndFunction
