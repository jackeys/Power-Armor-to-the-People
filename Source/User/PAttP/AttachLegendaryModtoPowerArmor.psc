Scriptname PAttP:AttachLegendaryModtoPowerArmor extends ObjectReference
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

GlobalVariable Property LegendaryChance Auto Const Mandatory
{Global variable with a percent chance from 0 to 100, indicating the likelihood of attaching a legendary mod}

LegendaryItemQuestScript Property LegendaryItemQuest Auto Const Mandatory

Keyword Property PowerArmorKeyword Auto Const

Keyword Property IsPowerArmorFrameKeyword Auto Const

Event OnInit()
    AttachLegendaryModToPowerArmor()
EndEvent

Bool AlreadyAttached = false

Function AttachLegendaryModToPowerArmor()
	debug.trace("In AttachLegendaryModToPowerArmor()")

    ; We only want to do this once, and only if we get a lucky roll
    if(!AlreadyAttached && Utility.RandomInt(1, 100) <= LegendaryChance.GetValueInt())
		debug.trace("Looking for power armor to attach a legendary mod to")

		; This requires F4SE - be aware
		Form[] inventory = GetInventoryItems()
		
		; Find all of the power armor pieces
		Form[] powerArmorPieces = new Form[0]
		int i = 0
		while(i < inventory.length)
            Form  item = inventory[i]

            if item.HasKeyword(PowerArmorKeyword) && !item.HasKeyword(IsPowerArmorFrameKeyword)
				debug.trace("Item " + item + " in inventory has keyword " + PowerArmorKeyword)
				powerArmorPieces.Add(item)
			endif

			i += 1
		endwhile

		; If we have at least one piece of power armor, randomly select one to get a legendary mod
		int numPieces = powerArmorPieces.length
		if numPieces > 0
			int chosenIndex = Utility.RandomInt(0, numPieces - 1)
			debug.trace("Selecting power armor at index " + chosenIndex + " out of " + numPieces + " total")
			Form itemToMod = powerArmorPieces[chosenIndex]
			AddLegendaryMod(itemToMod)
			AlreadyAttached = true
		else
			debug.trace("No power armor pieces found to attach a legendary mod to")
		endif
    endif
EndFunction

Function AddLegendaryMod(Form  item, FormList ListOfSpecificModsToChooseFrom = None, FormList ListOfSpecificModsToDisallow = None)
	debug.trace("Attaching legendary mod to inventory item " + item)

	; Create a temporary reference so we can use the base game's legendary item quest and all of its legendary mod rules
	ObjectReference itemObject = PlaceAtMe(item, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true, abDeleteWhenAble = false)
	
	;GET THE MODS WE CAN INSTALL ON THIS ITEM
	ObjectMod[] AllowedMods = LegendaryItemQuest.GetAllowedMods(itemObject, ListOfSpecificModsToChooseFrom, ListOfSpecificModsToDisallow)

	itemObject.Delete()

	;ROLL A DIE AND PICK A MOD
	int max = AllowedMods.Length
	if max > 0
		int dieRoll = Utility.RandomInt(0, max - 1)

		ObjectMod legendaryMod = AllowedMods[dieRoll]

		debug.trace(self + "Attaching " + legendaryMod + " to inventory item " + item)

		bool success = AttachModToInventoryItem(item, legendaryMod)

		if success == false
			Game.Warning(self + "FAILED TO ATTACH " + legendaryMod + " to "+ item)
		endif
		
	else
		Game.Warning(self + "AddLegendaryMod() for power armored NPC could not find any appropriate Legendary Mods to add to item: " + item)

	endif

EndFunction
