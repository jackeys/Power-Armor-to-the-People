Scriptname PAttP:RedemptionMachine extends ObjectReference Const

LegendaryItemQuestScript Property LegendaryItemQuest Auto Const
Form Property Currency Auto Const Mandatory
Message Property InsufficientCurrencyMessage Auto Const Mandatory

bool Function PurchaseItem(Form akItem, int aiCost, int aiCount = 1)
    bool success = TakePayment(aiCost)

    if success
        debug.trace(self + " is giving the player " + aiCount + " " + akItem)
        Game.GetPlayer().AddItem(akItem, aiCount)
    EndIf

    return success
EndFunction

bool Function PurchaseLegendaryItem(Form akItem, int aiCost, GlobalVariable akLegendaryChance)
    bool success = TakePayment(aiCost)

    if success
        GivePlayerPossiblyLegendaryItem(akItem, akLegendaryChance)
    EndIf

    return success
EndFunction

bool Function TakePayment(int aiCost)
    if Game.GetPlayer().GetItemCount(Currency) >= aiCost
        debug.trace(self + " is taking " + aiCost + " " + Currency + " as payment")
        Game.GetPlayer().RemoveItem(Currency, aiCost)
        return true
    else
        debug.trace(self + " is not taking a payment of " + aiCost + " " + Currency +" because the player only has " + Game.GetPlayer().GetItemCount(Currency))
        InsufficientCurrencyMessage.Show()
        return false
    EndIf
EndFunction

Function GivePlayerPossiblyLegendaryItem(Form akItem, GlobalVariable akLegendaryChance)
    ; If this item can be legendary and we get the right roll, make it legendary
    if LegendaryItemQuest && Utility.RandomInt(1, 100) <= akLegendaryChance.GetValue()
        debug.trace(self + " is giving the player a legendary " + akItem)
        GenerateLegendaryItem(Game.GetPlayer(), akItem)
    else
        debug.trace(self + " is giving the player a normal " + akItem + " instead of a legendary")
        Game.GetPlayer().AddItem(akItem)
    EndIf
EndFunction

ObjectReference Function GenerateLegendaryItem(ObjectReference ObjectToSpawnIn, Form akItem, FormList ListOfSpecificModsToChooseFrom = None, FormList ListOfSpecificModsToDisallow = None)
	ObjectReference item = ObjectToSpawnIn.PlaceAtMe(akItem, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true, abDeleteWhenAble = false)

	if item
		debug.trace(self + "GenerateLegendaryItem() PlaceAtMe returned: " + item)
	else
		debug.trace(self + "GenerateLegendaryItem() PlaceAtMe returned nothing")
	endif

	LegendaryItemQuest.AddLegendaryMod(item, ListOfSpecificModsToChooseFrom, ListOfSpecificModsToDisallow)

	debug.trace(self + "GenerateLegendaryItem() adding item: " + item)
	ObjectToSpawnIn.additem(item)

	item.enable()
	return item
EndFunction