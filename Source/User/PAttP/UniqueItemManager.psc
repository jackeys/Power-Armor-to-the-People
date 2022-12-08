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

    Form PlaceContainerInstead
    {Place this container AT the ReferenceToSpawnIn, and spawn the item inside of it - all PlaceAtMe position and rotation variables apply to this}

    int ContainerLockLevel
    {Used only if PlaceContainerInstead is used. 25=Novice, 50=Advanced, 75=Expert, 100=Master}
    
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

    bool PlacedItem = false
    {Should be left alone - whether the item was placed already}

    ObjectReference PlacedReference
    {Should be left alone - populated with the new reference sitting in the world, if any (item if PlaceAtMeInstead, container if PlaceContainerInstead)}
EndStruct

Struct CustomItemRuleState
    String ID
    {Identifier to match items when registering and storing state - should be unique}

    ObjectReference ReferenceToSpawnIn

    Quest TriggerQuest

    int TriggerStage = -1
    
    LeveledItem LeveledListToSpawnFrom
    
    ObjectMod CosmeticMod
    
    ObjectMod MiscMod
    
    bool IsFallback

    bool PlacedItem

    ObjectReference PlacedReference
EndStruct

CustomItemRuleState[] RuleStates

CustomItemRule[] Property CustomItemRules Const Auto Mandatory
bool Property PlaceFallbackItems = false Auto

Event OnInit()
    InitRuleStatesIfNeeded()
    SpawnItems()
EndEvent

Function InitRuleStatesIfNeeded()
    if RuleStates == None
        RuleStates = new CustomItemRuleState[0]
    endIf
EndFunction

Function SpawnItems()
    int i = 0
    while i < CustomItemRules.Length
        SpawnItemIfConditionsMet(GetItemRuleWithState(CustomItemRules[i].ID))
        i += 1
    EndWhile
EndFunction

; "None" means no change
Function OverrideUniqueItem(String asID, ObjectMod akMiscMod = None, ObjectMod akCosmeticMod = None, LeveledItem akLeveledListToSpawnFrom = None)
    ; This can get called from the OnInit of other quests, so our OnInit may not have run yet
    InitRuleStatesIfNeeded()
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

; "None" means no change
Function OverrideUniqueItemTrigger(String asID, ObjectReference akReferenceToSpawnIn = None, Quest akTriggerQuest = None, int aiTriggerStage = -1)
    ; This can get called from the OnInit of other quests, so our OnInit may not have run yet
    InitRuleStatesIfNeeded()
    int ruleIndex = RuleStates.FindStruct("ID", asID)

    debug.trace(self + " overriding custom item trigger for ID " + asID)

    if ruleIndex < 0
        debug.trace(self + " creating new state for ID " + asID + " to record trigger override because it could not be found")
        CustomItemRuleState ruleUpdate = new CustomItemRuleState
        ruleUpdate.ID = asID
        ruleUpdate.ReferenceToSpawnIn = akReferenceToSpawnIn
        ruleUpdate.TriggerQuest = akTriggerQuest
        ruleUpdate.TriggerStage = aiTriggerStage
        RuleStates.Add(ruleUpdate)
    else
        RuleStates[ruleIndex].ReferenceToSpawnIn = akReferenceToSpawnIn
        RuleStates[ruleIndex].TriggerQuest = akTriggerQuest
        RuleStates[ruleIndex].TriggerStage = aiTriggerStage
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
            SpawnUniqueItem(rule)
        else
            debug.trace(self + " Rule " + rule.ID + " waiting for quest " + rule.TriggerQuest + " to reach stage " + rule.TriggerStage)
            RegisterForRemoteEvent(rule.TriggerQuest, "OnStageSet")
        endIf
    EndIf
EndFunction

ObjectReference Function SpawnUniqueItem(CustomItemRule rule)
    ObjectReference spawnInRef

    if rule.AliasToSpawnIn
        spawnInRef = rule.AliasToSpawnIn.GetReference()
    elseif rule.ReferenceToSpawnIn
        spawnInRef = rule.ReferenceToSpawnIn
    else
        debug.trace("Didn't find spawnInRef for unique item " + rule.ID + ", not placing")
        return None
    endif

    ; Indicate upfront that we are placing this item to prevent duplicate items, then update again to keep the actual item reference
    UpdateRulePlacement(rule)
    
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
    
    ObjectReference worldItem = None
    if rule.PlaceContainerInstead
        debug.trace("Placing container for unique item " + rule.ID + ": " + item + " at " + spawnInRef)
        ObjectReference newContainer = spawnInRef.PlaceAtMe(rule.PlaceContainerInstead, aiCount = 1, abForcePersist = false, abInitiallyDisabled = false, abDeleteWhenAble = false)
        RepositionPlacedObject(newContainer, rule)
        newContainer.addItem(item)
        if rule.ContainerLockLevel > 0
            debug.trace(self + " Locking container for item " + rule.ID + " with lock level " + rule.ContainerLockLevel)
            newContainer.SetLockLevel(rule.ContainerLockLevel)
            newContainer.Lock()
        EndIf
        worldItem = newContainer
    elseif rule.PlaceAtMeInstead
        debug.trace("Placing unique item " + rule.ID + ": " + item + " at " + spawnInRef)
        RepositionPlacedObject(item, rule)
        worldItem = Item
    else
        debug.trace("Adding unique item " + rule.ID + ": " + item + " to " + spawnInRef)
        spawnInRef.additem(item)
        Actor spawnInActor = spawnInRef as Actor
        if spawnInActor
            spawnInActor.EquipItem(item.GetBaseObject())
        EndIf
    endif

    UpdateRulePlacement(rule, true, worldItem)
    return worldItem
EndFunction

Function RepositionPlacedObject(ObjectReference akObject, CustomItemRule akRule)
    if akRule.PlaceAtMePosX != 0 || akRule.PlaceAtMePosY != 0 || akRule.PlaceAtMePosZ != 0
        debug.trace("Setting custom position of " + akRule.PlaceAtMePosX + "," + akRule.PlaceAtMePosY + "," + akRule.PlaceAtMePosZ + " for item " + akRule.ID)
        akObject.SetPosition(akRule.PlaceAtMePosX, akRule.PlaceAtMePosY, akRule.PlaceAtMePosZ)
    EndIf

    if akRule.PlaceAtMeRotX != 0 || akRule.PlaceAtMeRotY != 0 || akRule.PlaceAtMeRotZ != 0
        debug.trace("Setting custom rotation of " + akRule.PlaceAtMeRotX + "," + akRule.PlaceAtMeRotY + "," + akRule.PlaceAtMeRotZ + " for item " + akRule.ID)
        akObject.SetAngle(akRule.PlaceAtMeRotX, akRule.PlaceAtMeRotY, akRule.PlaceAtMeRotZ)

        ; Rotation doesn't seem to work when the cell hasn't loaded yet, so we will do it again the next time the player enters the cell just to make sure
        RegisterForRemoteEvent(akObject, "OnCellLoad")
    EndIf
EndFunction

Event ObjectReference.OnCellLoad(ObjectReference akSender)
    debug.trace(self + " received OnCellLoad event for " + akSender)
    int ruleIndex = RuleStates.FindStruct("PlacedReference", akSender)

    if ruleIndex >= 0
        CustomItemRule rule = GetItemRuleWithState(RuleStates[ruleIndex].ID)
        debug.trace("Setting rotation on cell load of " + rule.PlaceAtMeRotX + "," + rule.PlaceAtMeRotY + "," + rule.PlaceAtMeRotZ + " for item " + rule.ID + ": " + rule.PlacedReference)
        akSender.SetAngle(rule.PlaceAtMeRotX, rule.PlaceAtMeRotY, rule.PlaceAtMeRotZ)
    Else
        debug.trace(self + " Could not find rule to change rotation on cell load for " + akSender)
    EndIf
    
    UnregisterForRemoteEvent(akSender, "OnCellLoad")
EndEvent

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

; Ignores all conditions and just spawns the item now, even if it was already spawned - meant for debugging
Function ForceSpawn(string asID)
    CustomItemRule rule = GetItemRuleWithState(asID)
    if rule
        SpawnUniqueItem(rule)
    EndIf
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
        rule.PlacedItem = ruleState.PlacedItem
        rule.PlacedReference = ruleState.PlacedReference
        
        ; We only overlay state if it has a real value
        if ruleState.CosmeticMod
            rule.CosmeticMod = ruleState.CosmeticMod
        EndIf

        if ruleState.MiscMod
            rule.MiscMod = ruleState.MiscMod
        EndIf
        
        if ruleState.LeveledListToSpawnFrom
            rule.LeveledListToSpawnFrom = ruleState.LeveledListToSpawnFrom
        EndIf

        if ruleState.ReferenceToSpawnIn
            rule.ReferenceToSpawnIn = ruleState.ReferenceToSpawnIn
        EndIf

        if ruleState.TriggerQuest
            rule.TriggerQuest = ruleState.TriggerQuest
            rule.TriggerStage = ruleState.TriggerStage
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
    
Function UpdateRulePlacement(CustomItemRule akRule, bool abPlacedItem = true, ObjectReference akPlacedReference = None)
    int ruleIndex = RuleStates.FindStruct("ID", akRule.ID)

    if ruleIndex < 0
        debug.trace(self + " creating new state for ID " + akRule.ID + " to record successful placement because it could not be found")
        CustomItemRuleState ruleUpdate = new CustomItemRuleState
        ruleUpdate.ID = akRule.ID
        ruleUpdate.PlacedItem = abPlacedItem
        ruleUpdate.PlacedReference = akPlacedReference
        RuleStates.Add(ruleUpdate)
    else
        RuleStates[ruleIndex].PlacedItem = abPlacedItem
        RuleStates[ruleIndex].PlacedReference = akPlacedReference
    EndIf
EndFunction