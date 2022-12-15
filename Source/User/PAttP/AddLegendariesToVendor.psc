Scriptname PAttP:AddLegendariesToVendor Extends Quest
{Adds random legendary items using the provided rules to vendors at a specific interval. If a legendary item was not purchased before the refresh interval expires again, it will be removed and unavailable, so each legendary placement rule can only produce a single unpurchased legendary item in the world at a time.}

Struct LegendaryPlacement
    ObjectReference VendorContainer
    {The object reference of the aspiration container for the vendor that should sell the produced legendary items}
    Form Item
    {The item that should be made legendary (typically a leveled item)}
    GlobalVariable LegendaryChance
    {The percent chance from 0-100 that a legendary item should be produced and placed in the vendor's inventory each time the refresh interval expires}
    int Level = 1
    {The player level at which this legendary item can begin showing up at the specified vendor}
    ObjectMod AspirationMod
    {Aspiration mods increase the cost of a special item, and can be found in the base game with editor IDs like Mod_Aspiration_Armor_IncreasedCost_<multiplier>}
    GlobalVariable MaxCount
    {The LegendaryChance will be evaluated this many times to attempt to add items. If not provided, it will default to 1.}
EndStruct

LegendaryPlacement[] Property Legendaries Auto Const Mandatory
{Rules for what legendary items to produce and where to put them}

float Property RefreshHours = 48.0 Auto Const
{The number of in-game hours between trying to generate a new legendary and replacing unpurchased ones}

LegendaryItemQuestScript Property LegendaryItemQuest Auto Const Mandatory
{AUTOFILL}

Struct ActiveLegendary
    Form item
    ObjectReference vendorContainer
EndStruct

ActiveLegendary[] ActiveLegendaries

Event OnInit()
    ActiveLegendaries = new ActiveLegendary[0]
EndEvent

Event OnQuestInit()
    RefreshLegendaries()
    StartTimerGameTime(RefreshHours)
EndEvent

Function RefreshLegendaries()
    debug.trace(self + " is refreshing legendary inventories")
    RemoveUnpurchasedLegendaries()
    AddLegendaries()
EndFunction

Function RemoveUnpurchasedLegendaries()
    int i = 0
    While i < ActiveLegendaries.length
        ActiveLegendary currentLegendary = ActiveLegendaries[i]
        int itemCount = currentLegendary.vendorContainer.GetItemCount(currentLegendary.item)

        if itemCount > 0
            debug.trace(self + " found " + itemCount + " unpurchased instances of " + currentLegendary.item + " to remove from " + currentLegendary.vendorContainer)
            currentLegendary.vendorContainer.RemoveItem(currentLegendary.item)
        EndIf
        i += 1
    EndWhile

    ActiveLegendaries.clear()
EndFunction

Function AddLegendaries()
    int i = 0
    While i < Legendaries.length
        LegendaryPlacement currentLegendary = Legendaries[i]
        If Game.GetPlayer().GetLevel() >= currentLegendary.Level
            int numLegendaries = NumberOfLegendariesToAdd(currentLegendary)
            int j = 0
            while j < numLegendaries
                if Utility.RandomInt(1, 100) <= currentLegendary.LegendaryChance.GetValueInt()
                    debug.trace(self + " is adding a new legendary " + currentLegendary.Item + " to " + currentLegendary.VendorContainer + " (minimum level of " + currentLegendary.Level + " was required)")
                    ActiveLegendary newLegendary = new ActiveLegendary
                    newLegendary.item = GenerateLegendaryItem(currentLegendary.VendorContainer, currentLegendary.Item, currentLegendary.AspirationMod)
                    newLegendary.vendorContainer = currentLegendary.VendorContainer
                    ActiveLegendaries.Add(newLegendary)
                endIf
                j += 1
            EndWhile
        EndIf
        i += 1
    EndWhile
EndFunction

int Function NumberOfLegendariesToAdd(LegendaryPlacement akLegendary)
    ; If a max count wasn't provided, we will always add an item
    if !akLegendary.MaxCount
        return 1
    else
        return akLegendary.MaxCount.GetValueInt()
    endIf
EndFunction

ObjectReference Function GenerateLegendaryItem(ObjectReference ObjectToSpawnIn, Form akItem, ObjectMod akAspiration, FormList ListOfSpecificModsToChooseFrom = None, FormList ListOfSpecificModsToDisallow = None)
	ObjectReference item = ObjectToSpawnIn.PlaceAtMe(akItem, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true, abDeleteWhenAble = false)

	if item
		debug.trace(self + "GenerateLegendaryItem() PlaceAtMe returned: " + item)
	else
		debug.trace(self + "GenerateLegendaryItem() PlaceAtMe returned nothing")
	endif

	LegendaryItemQuest.AddLegendaryMod(item, ListOfSpecificModsToChooseFrom, ListOfSpecificModsToDisallow)

    ; Add the aspiration to increase the cost
    item.AttachMod(akAspiration)

	debug.trace(self + "GenerateLegendaryItem() adding item: " + item)
	ObjectToSpawnIn.additem(item)

	item.enable()
	return item
EndFunction

Event OnTimerGameTime(int aiTimerId)
    RefreshLegendaries()
    StartTimerGameTime(RefreshHours)
EndEvent
    