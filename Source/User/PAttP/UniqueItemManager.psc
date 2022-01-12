Scriptname PAttP:UniqueItemManager Extends Quest

Struct CustomItemRule

    String ID
    {Identifier - used to help identify items in array. Not otherwise used.}
    
    Quest TriggerQuest
    {If populated, look for this quest to place the item}

    int TriggerObjective
    {Which objective from the trigger quest needs to be completed for the item to be placed}
    
    LeveledItem LeveledListToSpawnFrom
    {List to spawn from}
    
    ObjectMod LegendaryMod

    ObjectMod IncreasedCostMod

    ObjectMod CosmeticMod

    ObjectMod MiscMod
    
    ObjectReference ReferenceToSpawnIn
    {Where to spawn item}
    
    ReferenceAlias AliasToSpawnIn
    {Where to spawn in, overrides ReferenceToSpawnIn}
    
    bool PlaceAtMeInstead = false
    {Place AT instead of IN ReferenceToSpawnIn}
    
    ReferenceAlias AliasToForceItemInto
    {if set, item will be forced into this alias}

    bool IsFallback = true
    {Whether this entry is a fallback or not - fallbacks are only placed if the setting is configured}
    
    Form PlacedItem
EndStruct

CustomItemRule[] Property CustomItemRules Const Auto Mandatory
bool Property PlaceFallbackItems = false Auto

Event OnInit()
    SpawnItems()
EndEvent

Function SpawnItems()
    int i = 0
    while i < CustomItemRules.Length
        SpawnItemIfConditionsMet(CustomItemRules[i])
        i += 1
    EndWhile
EndFunction

Function OverrideUniqueItem(String asID, ObjectMod akMiscMod = None, ObjectMod akCosmeticMod = None, LeveledItem akLeveledListToSpawnFrom = None)
    int ruleIndex = CustomItemRules.FindStruct("ID", asID)

    if ruleIndex < 0
        debug.trace(self + " cannot override rule with ID " + asID + " because it could not be found")
        return
    EndIf

    If CustomItemRules[ruleIndex].IsFallback == false
        debug.trace(self + " has already registered an override for rule with ID " + asID)
    EndIf

    CustomItemRules[ruleIndex].IsFallback = false
    CustomItemRules[ruleIndex].MiscMod = akMiscMod
    CustomItemRules[ruleIndex].CosmeticMod = akCosmeticMod

    ; We have to have an item to spawn, so if one was not included, we should assume that we can keep using the original form
    if akLeveledListToSpawnFrom
        CustomItemRules[ruleIndex].LeveledListToSpawnFrom = akLeveledListToSpawnFrom
    EndIf

    SpawnItemIfConditionsMet(CustomItemRules[ruleIndex])
EndFunction

Function SpawnItemIfConditionsMet(CustomItemRule rule)
    ; We don't want to place the item again if we already placed it, and unless configured, we don't want to place fallbacks
    if (!rule.IsFallback || PlaceFallbackItems) && !rule.PlacedItem
        rule.PlacedItem = SpawnUniqueItem(rule)
    EndIf
EndFunction

form Function SpawnUniqueItem(CustomItemRule rule) global
    ObjectReference spawnInRef

    if rule.AliasToSpawnIn
        spawnInRef = rule.AliasToSpawnIn.GetReference()
    elseif rule.ReferenceToSpawnIn
        spawnInRef = rule.ReferenceToSpawnIn
    else
        debug.trace("Didn't find spawnInRef for unique item " + rule.ID + ", using Game.GetPlayer() instead.")
        spawnInRef = Game.GetPlayer()
    endif

    ObjectReference item = spawnInRef.PlaceAtMe(rule.LeveledListToSpawnFrom, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true, abDeleteWhenAble = false)

    debug.trace("Creating item " + item)

    PossiblyAttachMod(item, rule.LegendaryMod)
    PossiblyAttachMod(item, rule.IncreasedCostMod)
    PossiblyAttachMod(item, rule.CosmeticMod)
    PossiblyAttachMod(item, rule.MiscMod)
        
    item.enable()

    if rule.AliasToForceItemInto
        rule.AliasToForceItemInto.ForceRefTo(item)
    endif

    if rule.PlaceAtMeInstead
        debug.trace("Placing unique item " + rule.ID + ": " + item + " at " + spawnInRef)
    else
        debug.trace("Adding unique item " + rule.ID + ": " + item + " to " + spawnInRef)
        spawnInRef.additem(item)
    endif

    RETURN item
EndFunction

bool Function PossiblyAttachMod(ObjectReference akItem, ObjectMod akMod) global
    bool success = false
    
    if akMod
        success = akItem.AttachMod(akMod)

        if success == false
            debug.trace("FAILED TO ATTACH " + akMod + " to " + akItem)
        else
            debug.trace("Attached " + akMod + " to " + akItem)
        endif
    EndIf

    return success
EndFunction
