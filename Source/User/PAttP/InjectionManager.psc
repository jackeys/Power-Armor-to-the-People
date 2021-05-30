Scriptname PAttP:InjectionManager Extends Quest

PAttP:UpgradeManager Property UpgradeManager Auto Const Mandatory

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

Function RegisterInjection(LeveledItem modifiedItemList)
    if(modifiedItemList && modifiedListsRegistrar.Find(modifiedItemList) < 0)
        debug.trace("Registering " + modifiedItemList + " as script-modified")
        modifiedListsRegistrar.Add(modifiedItemList)
    EndIf
EndFunction

Function RegisterInjections(LeveledItem[] modifiedItemLists)
    int i = 0
    While(i < modifiedItemLists.length)
        RegisterInjection(modifiedItemLists[i])
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
    int numModifiedForms = modifiedListsRegistrar.length
    int i = 0
    while(i < numModifiedForms)
        LeveledItem injectionSite = modifiedListsRegistrar[i]
        debug.trace("Reverting " + injectionSite)
        injectionSite.Revert()
        i += 1
    EndWhile
EndFunction

Event OnTimer(int aiTimerId)
    RefreshListInjections()
EndEvent

Event PAttP:UpgradeManager.VersionChanged(PAttP:UpgradeManager akSender, Var[] akArgs)
    RefreshListInjections(true)
EndEvent