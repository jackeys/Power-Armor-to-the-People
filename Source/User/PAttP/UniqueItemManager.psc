Scriptname PAttP:UniqueItemManager Extends Quest

Struct CustomItemRule

    String ID
    {Identifier to match items when registering and storing state - should be unique}
    
    Quest TriggerQuest
    {If populated, look for this quest to place the item}

    int TriggerStage
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

    float PlaceAtMePosX
    {Only valid if using PlaceAtMeInstead and a custom position is desired}
    float PlaceAtMePosY
    {Only valid if using PlaceAtMeInstead and a custom position is desired}
    float PlaceAtMePosZ
    {Only valid if using PlaceAtMeInstead and a custom position is desired}
    float PlaceAtMeRotX
    {Only valid if using PlaceAtMeInstead and a custom rotation is desired}
    float PlaceAtMeRotY
    {Only valid if using PlaceAtMeInstead and a custom rotation is desired}
    float PlaceAtMeRotZ
    {Only valid if using PlaceAtMeInstead and a custom rotation is desired}
    
    ReferenceAlias AliasToForceItemInto
    {if set, item will be forced into this alias}

    Faction OwningFaction
    {Set if the item should belong to a particular faction}

    bool IsFallback = true
    {Whether this entry is a fallback or not - fallbacks are only placed if the setting is configured}

    Form PlacedItem
    {Should be left alone}
EndStruct

Struct CustomItemRuleState
    String ID
    {Identifier to match items when registering and storing state - should be unique}
    
    LeveledItem LeveledListToSpawnFrom
    
    ObjectMod CosmeticMod
    
    ObjectMod MiscMod
    
    bool IsFallback

    Form PlacedItem
EndStruct

CustomItemRuleState[] RuleStates

CustomItemRule[] Property CustomItemRules Const Auto Mandatory
bool Property PlaceFallbackItems = false Auto

Event OnInit()
    RuleStates = new CustomItemRuleState[0]
    SpawnItems()
EndEvent

Function SpawnItems()
    int i = 0
    while i < CustomItemRules.Length
        SpawnItemIfConditionsMet(GetItemRuleWithState(CustomItemRules[i].ID))
        i += 1
    EndWhile
EndFunction

; "None" means no change
Function OverrideUniqueItem(String asID, ObjectMod akMiscMod = None, ObjectMod akCosmeticMod = None, LeveledItem akLeveledListToSpawnFrom = None)
    int ruleIndex = RuleStates.FindStruct("ID", asID)

    debug.trace(self + " overriding custom item rule for ID " + asID)

    if ruleIndex < 0
        debug.trace(self + " creating new state for ID " + asID + " to record override because it could not be found")
        CustomItemRuleState ruleUpdate = new CustomItemRuleState
        ruleUpdate.ID = asID
        ruleUpdate.IsFallback = false
        ruleUpdate.MiscMod = akMiscMod
        ruleUpdate.CosmeticMod = akCosmeticMod
        ruleUpdate.LeveledListToSpawnFrom = akLeveledListToSpawnFrom
        RuleStates.Add(ruleUpdate)
    else
        If RuleStates[ruleIndex].IsFallback == false
            debug.trace(self + " has already registered an override for rule with ID " + asID)
        EndIf
        
        RuleStates[ruleIndex].IsFallback = false
        RuleStates[ruleIndex].MiscMod = akMiscMod
        RuleStates[ruleIndex].CosmeticMod = akCosmeticMod
        RuleStates[ruleIndex].LeveledListToSpawnFrom = akLeveledListToSpawnFrom
    EndIf
    
    SpawnItemIfConditionsMet(GetItemRuleWithState(asID))
EndFunction

Function SpawnItemIfConditionsMet(CustomItemRule rule)
    if !rule
        debug.trace(self + " No rule provided to check spawn conditions")
        return
    EndIf

    ; We don't want to place the item again if we already placed it, and unless configured, we don't want to place fallbacks
    if (!rule.IsFallback || PlaceFallbackItems) && !rule.PlacedItem
        if !rule.TriggerQuest || rule.TriggerQuest.IsStageDone(rule.TriggerStage)
            Form placedItem = SpawnUniqueItem(rule)
            UpdateRulePlacement(rule, placedItem)
        else
            debug.trace(self + " Rule " + rule.ID + " waiting for quest " + rule.TriggerQuest + " to reach stage " + rule.TriggerStage)
            RegisterForRemoteEvent(rule.TriggerQuest, "OnStageSet")
        endIf
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

    debug.trace("Creating item " + rule.ID + item)

    PossiblyAttachMod(item, rule.LegendaryMod)
    PossiblyAttachMod(item, rule.IncreasedCostMod)
    PossiblyAttachMod(item, rule.CosmeticMod)
    PossiblyAttachMod(item, rule.MiscMod)

    if rule.OwningFaction
        debug.trace("Setting faction owner for item " + rule.ID + " to " + rule.OwningFaction)
        item.SetFactionOwner(rule.OwningFaction)
    EndIf
    
    item.enable()
    
    if rule.AliasToForceItemInto
        rule.AliasToForceItemInto.ForceRefTo(item)
    endif
    
    if rule.PlaceAtMeInstead
        debug.trace("Placing unique item " + rule.ID + ": " + item + " at " + spawnInRef)

        if rule.PlaceAtMePosX != 0 || rule.PlaceAtMePosY != 0 || rule.PlaceAtMePosZ != 0
            debug.trace("Setting custom position of " + rule.PlaceAtMePosX + "," + rule.PlaceAtMePosY + "," + rule.PlaceAtMePosZ + " for item " + rule.ID)
            item.SetPosition(rule.PlaceAtMePosX, rule.PlaceAtMePosY, rule.PlaceAtMePosZ)
        EndIf

        if rule.PlaceAtMeRotX != 0 || rule.PlaceAtMeRotY != 0 || rule.PlaceAtMeRotZ != 0
            debug.trace("Setting custom rotation of " + rule.PlaceAtMeRotX + "," + rule.PlaceAtMeRotY + "," + rule.PlaceAtMeRotZ + " for item " + rule.ID)
            item.SetAngle(rule.PlaceAtMeRotX, rule.PlaceAtMeRotY, rule.PlaceAtMeRotZ)
        EndIf
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

Event Quest.OnStageSet(Quest akSender, int auiStageID, int auiItemID)
    debug.trace(self + " received OnSetStage for quest " + akSender + " stage " + auiStageID)
    int numRulesWaitingForQuestStage = 0
    int ruleIndex = CustomItemRules.FindStruct("TriggerQuest", akSender)

    while ruleIndex > -1
        CustomItemRule rule = GetItemRuleWithState(CustomItemRules[ruleIndex].ID)
        if rule.TriggerStage == auiStageID
            debug.trace(self + " Rule " + rule.ID + " has reached trigger quest " + rule.TriggerQuest + " stage " + rule.TriggerStage)
            SpawnItemIfConditionsMet(rule)
        elseif !rule.PlacedItem
            debug.trace(self + " Rule " + rule.ID + " is still waiting for quest " + rule.TriggerQuest + " stage " + rule.TriggerStage)
            numRulesWaitingForQuestStage += 1
        EndIf

        ruleIndex = CustomItemRules.FindStruct("TriggerQuest", akSender, ruleIndex + 1)
    EndWhile

    if numRulesWaitingForQuestStage == 0
        debug.trace(self + " is unregistering from OnStageSet for quest " + akSender + " because there are no more rules waiting for it")
        UnregisterForRemoteEvent(akSender, "OnStageSet")
    EndIf
EndEvent

CustomItemRule Function GetItemRuleWithState(string asID)
    CustomItemRule rule = GetItemRule(asID)
    CustomItemRuleState ruleState = GetItemRuleState(asID)

    if rule && ruleState
        rule.IsFallback = ruleState.IsFallback
        
        ; We only overlay state if it has a real value
        if ruleState.CosmeticMod
            rule.CosmeticMod = ruleState.CosmeticMod
        EndIf

        if ruleState.MiscMod
            rule.MiscMod = ruleState.MiscMod
        EndIf

        if ruleState.PlacedItem
            rule.PlacedItem = ruleState.PlacedItem
        EndIf
        
        if ruleState.LeveledListToSpawnFrom
            rule.LeveledListToSpawnFrom = ruleState.LeveledListToSpawnFrom
        EndIf
    EndIf

    return rule
EndFunction

CustomItemRule Function GetItemRule(string asID)
    int ruleIndex = CustomItemRules.FindStruct("ID", asID)

    if ruleIndex >= 0
        return CustomItemRules[ruleIndex]
    else
        return None
    endIf
EndFunction

CustomItemRuleState Function GetItemRuleState(string asID)
    int ruleIndex = RuleStates.FindStruct("ID", asID)

    if ruleIndex >= 0
        return RuleStates[ruleIndex]
    else
        return None
    endIf
EndFunction
    
Function UpdateRulePlacement(CustomItemRule akRule, Form akPlacedItem)
    int ruleIndex = RuleStates.FindStruct("ID", akRule.ID)

    if ruleIndex < 0
        debug.trace(self + " creating new state for ID " + akRule.ID + " to record successful placement because it could not be found")
        CustomItemRuleState ruleUpdate = new CustomItemRuleState
        ruleUpdate.ID = akRule.ID
        ruleUpdate.PlacedItem = akPlacedItem
        RuleStates.Add(ruleUpdate)
    else
        RuleStates[ruleIndex].PlacedItem = akPlacedItem
    EndIf
EndFunction