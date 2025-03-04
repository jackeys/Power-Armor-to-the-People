Scriptname PARTS:ManagePerkProxies extends Quest const
{Add and remove perk proxies so a player never sees them but they can be used at a repair station}

PerkProgression[] Property PerkProgressions Auto Const
{Each progression is a progression of a single Perk type (e.g. Armorer 1, 2, 3, 4)}

int Property NumberToAdd = 100 Auto Const

; Arrays within structs aren't supported, so we have to set a cap on the highest number of perks we expect to see
Struct PerkProgression
    Perk requiredPerk1
    Form proxyItem1
    Perk requiredPerk2 = None
    Form proxyItem2 = None
    Perk requiredPerk3 = None
    Form proxyItem3 = None
    Perk requiredPerk4 = None
    Form proxyItem4 = None
    Perk requiredPerk5 = None
    Form proxyItem5 = None
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
    ; Remove any proxies that might already be in the inventory to keep counts precise
    RemovePerkProxies()
    int i = 0

    while i < PerkProgressions.length
        PerkProgression progression = PerkProgressions[i]

        ; For each level N, add NumberToAdd * N if we have the perk so all levels can repair the same number of pieces before leaving the menu
        ; If a perk level has not been obtained, add N-1 for this and all subsequent levels
        int perkLevel = 0

        if Game.GetPlayer().HasPerk(progression.requiredPerk5)
            perkLevel = 5
        elseif Game.GetPlayer().HasPerk(progression.requiredPerk4)
            perkLevel = 4
        elseif Game.GetPlayer().HasPerk(progression.requiredPerk3)
            perkLevel = 3
        elseif Game.GetPlayer().HasPerk(progression.requiredPerk2)
            perkLevel = 2
        elseif Game.GetPlayer().HasPerk(progression.requiredPerk1)
            perkLevel = 1
        EndIf

        if perkLevel >= 1
            Game.GetPlayer().AddItem(progression.proxyItem1, NumberToAdd, true)
        endIf
        
        if perkLevel >= 2
            Game.GetPlayer().AddItem(progression.proxyItem2, NumberToAdd * 2, true)
        else
            Game.GetPlayer().AddItem(progression.proxyItem2, perkLevel, true)
        EndIf
        
        if perkLevel >= 3
            Game.GetPlayer().AddItem(progression.proxyItem3, NumberToAdd * 3, true)
        else
            Game.GetPlayer().AddItem(progression.proxyItem3, perkLevel, true)
        EndIf
        
        if perkLevel >= 4
            Game.GetPlayer().AddItem(progression.proxyItem4, NumberToAdd * 4, true)
        else
            Game.GetPlayer().AddItem(progression.proxyItem4, perkLevel, true)
        EndIf
        
        if perkLevel >= 5
            Game.GetPlayer().AddItem(progression.proxyItem5, NumberToAdd * 5, true)
        else
            Game.GetPlayer().AddItem(progression.proxyItem5, perkLevel, true)
        EndIf

        i += 1
    EndWhile
EndFunction

Function RemovePerkProxies()
    int i = 0

    while i < PerkProgressions.length
        PerkProgression progression = PerkProgressions[i]
        ; Remove -1 to remove all of them in case the counts got messed up somehow
        Game.GetPlayer().RemoveItem(progression.proxyItem1, -1, true)
        Game.GetPlayer().RemoveItem(progression.proxyItem2, -1, true)
        Game.GetPlayer().RemoveItem(progression.proxyItem3, -1, true)
        Game.GetPlayer().RemoveItem(progression.proxyItem4, -1, true)
        Game.GetPlayer().RemoveItem(progression.proxyItem5, -1, true)

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