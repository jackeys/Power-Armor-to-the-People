Scriptname PAttP:InjectionManager Extends Quest

PAttP:UpgradeManager Property UpgradeManager Auto Const Mandatory

Struct LevelMapping
    GlobalVariable ShouldIgnore
    {Global variable containing 0 to use the normal level or non-zero to always inject items at level 1}

    FormList AffectedLists
    {The lists whose injections will be affected}
EndStruct

LevelMapping[] Property IgnoreLevels Auto Const

Struct LeveledActorMapping
    LeveledItem InjectionTrigger
    {When this item is injected, the corresponding leveled actor will be injected at the same level}

    LeveledActor ActorToInject
    {The leveled actor to inject into the Destination. This should be a leveled actor containing level-scaled Actors since the levels can be dynamic. 
    The lowest level an actor is available in this leveled actor will be the minimum level.
    It is expected that Actors in this list use the leveled item InjectionTrigger in some way.}

    LeveledActor Destination
    {The injection site. This should be used in the ConstantChance and LeveledChance lists used for templating power armored enemies}
EndStruct

LeveledActorMapping[] Property LeveledActorMappings Auto Const
{If the injected item is intended to be used by a leveled actor, which otherwise shouldn't spawn, add a mapping to indicate what actor should be inserted}

LeveledItem[] modifiedListsRegistrar

CustomEvent RefreshInjection

Event OnInit()
    modifiedListsRegistrar = new LeveledItem[0]
    RegisterCustomEvents()
EndEvent

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People version changes")
    RegisterForCustomEvent(UpgradeManager, "VersionChanged")
EndFunction

Function RegisterInjection(LeveledItem modifiedItemList, int aiLevel = -1)
    if(modifiedItemList && modifiedListsRegistrar.Find(modifiedItemList) < 0)
        debug.trace("Registering " + modifiedItemList + " as script-modified")
        modifiedListsRegistrar.Add(modifiedItemList)
    EndIf

    ; If this injection should be accompanied by an actor update, we need to do that
    if(aiLevel >= 0)
        int injectionLevel = aiLevel
        if ShouldIgnoreLevelFor(modifiedItemList)
            injectionLevel = 1
        EndIf
        
        int actorIndex = LeveledActorMappings.FindStruct("InjectionTrigger", modifiedItemList)
        if(actorIndex >= 0)
            LeveledActorMapping mapping = LeveledActorMappings[actorIndex]
            debug.trace("Injecting actor mapping " + mapping + " at level " + injectionLevel)
            mapping.Destination.AddForm(mapping.ActorToInject, injectionLevel)
        EndIf
    EndIf
EndFunction

Function RegisterInjections(LeveledItem[] modifiedItemLists, int aiLevel = -1)
    int i = 0
    While(i < modifiedItemLists.length)
        RegisterInjection(modifiedItemLists[i], aiLevel)
        i += 1
    EndWhile
EndFunction

; The delay should be set if this is happening when the game is loading, since new modules may be injecting
Function RefreshListInjections(bool delay = false)
    If delay
        ; New injections usually only take 1 second, the player won't notice if it takes minutes to occur, so we'll wait for a longer time just in case
        debug.trace(self + " is scheduling a refresh for 60 seconds from now")
        StartTimer(60)
        return
    EndIf

    debug.trace("Refreshing all Power Armor to the People internal injections")
    RevertAllLists()
    SendCustomEvent("RefreshInjection")
EndFunction

Function RevertAllLists()
    RevertLeveledActors()
    RevertLeveledItems()
EndFunction

Function RevertLeveledActors()
    int numModifiedForms = LeveledActorMappings.length
    int i = 0
    while(i < numModifiedForms)
        LeveledActor injectionSite = LeveledActorMappings[i].Destination
        debug.trace("Reverting " + injectionSite)
        injectionSite.Revert()
        i += 1
    EndWhile
EndFunction

Function RevertLeveledItems()
    int numModifiedForms = modifiedListsRegistrar.length
    int i = 0
    while(i < numModifiedForms)
        LeveledItem injectionSite = modifiedListsRegistrar[i]
        debug.trace("Reverting " + injectionSite)
        injectionSite.Revert()
        i += 1
    EndWhile
    modifiedListsRegistrar.clear()
EndFunction

bool Function ShouldIgnoreLevelFor(LeveledItem akInjectInto)
    int i = 0
    while i < IgnoreLevels.length
        LevelMapping current = IgnoreLevels[i]
        if current.ShouldIgnore.GetValueInt() != 0 && current.AffectedLists.HasForm(akInjectInto)
            return true
        EndIf
        i += 1
    EndWhile

    return false
EndFunction

Event OnTimer(int aiTimerId)
    RefreshListInjections()
EndEvent

Event PAttP:UpgradeManager.VersionChanged(PAttP:UpgradeManager akSender, Var[] akArgs)
    RefreshListInjections(true)
EndEvent