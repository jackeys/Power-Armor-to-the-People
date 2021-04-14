Scriptname PAttP:InjectionManager Extends Quest

FormList Property modifiedListsRegistrar Auto Const
{An empty FormList to hold the list of leveled items that other scripts are injecting into}


CustomEvent RefreshInjection

Function RegisterInjection(LeveledItem modifiedItemList)
    if(!modifiedListsRegistrar.HasForm(modifiedItemList))
        debug.trace("Registering " + modifiedItemList + " as script-modified")
        modifiedListsRegistrar.AddForm(modifiedItemList)
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
    int numModifiedForms = modifiedListsRegistrar.GetSize()
    int i = 0
    while(i < numModifiedForms)
        LeveledItem injectionSite = modifiedListsRegistrar.GetAt(i) as LeveledItem
        debug.trace("Reverting " + injectionSite)
        injectionSite.Revert()
        i += 1
    EndWhile
EndFunction