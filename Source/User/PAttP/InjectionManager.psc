Scriptname PAttP:InjectionManager Extends Quest

LeveledItem[] modifiedListsRegistrar

CustomEvent RefreshInjection

Event OnInit()
    modifiedListsRegistrar = new LeveledItem[0]
EndEvent

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

; Activated by MCM button / changing MCM toggles
Function RefreshListInjections()
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