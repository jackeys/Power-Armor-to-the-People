Scriptname PARTS:ManagePerkProxies extends Quest const
{Add and remove perk proxies so a player never sees them but they can be used at a repair station}

PerkMapping[] Property Mappings Auto Const
{The item to use for each perk}

int Property NumberToAdd = 100 Auto Const

Struct PerkMapping
    Perk requiredPerk
    Form proxyItem
EndStruct

Event OnQuestInit()
    ; When the player loads the game or closes a menu, we will add the items
    ; We will hide them when the player opens a menu
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    RegisterForMenuOpenCloseEvent("PipboyMenu")
	RegisterForMenuOpenCloseEvent("ContainerMenu")
	RegisterForMenuOpenCloseEvent("BarterMenu")
    AddPerkProxies()
EndEvent

Function AddPerkProxies()
    int i = 0

    while i < Mappings.length
        PerkMapping mapping = Mappings[i]

        if Game.GetPlayer().HasPerk(mapping.requiredPerk)
            Game.GetPlayer().AddItem(mapping.proxyItem, NumberToAdd, true)
        EndIf

        i += 1
    EndWhile
EndFunction

Function RemovePerkProxies()
    int i = 0

    while i < Mappings.length
        PerkMapping mapping = Mappings[i]
        ; Remove -1 to remove all of them in case the counts got messed up somehow
        Game.GetPlayer().RemoveItem(mapping.proxyItem, -1, true)

        i += 1
    EndWhile
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
    AddPerkProxies()
EndEvent

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    ; Hide the items when one of the menus opens
    if abOpening
        RemovePerkProxies()
    else
        AddPerkProxies()
    EndIf
EndEvent