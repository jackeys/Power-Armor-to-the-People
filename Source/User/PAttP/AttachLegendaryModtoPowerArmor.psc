Scriptname PAttP:AttachLegendaryModtoPowerArmor extends ActiveMagicEffect
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

GlobalVariable Property NormalLegendaryChance Auto Const Mandatory
{Global variable with a percent chance from 0 to 100, indicating the likelihood of attaching a legendary mod for a normal enemy}

GlobalVariable Property LegendaryLegendaryChance Auto Const Mandatory
{Global variable with a percent chance from 0 to 100, indicating the likelihood of attaching a legendary mod for a legendary enemy}

LegendaryPowerArmorManager Property LegendaryPowerArmorQuest Auto Const Mandatory
{AUTOFILL}

Keyword Property ArmorTypePower Auto Const Mandatory
{AUTOFILL}

FormList Property ExcludeKeywordsList Auto Const Mandatory
{If any of the keywords in this form list are present on an item, it will be excluded from the eligible equipment for a legendary mod}

Keyword Property EncTypeLegendary Auto Const Mandatory
{AUTOFILL}

Event OnEffectStart(Actor akTarget, Actor akCaster)
    AttachLegendaryModToPowerArmor(akTarget)
EndEvent

int Function LegendaryChance(Actor akRecipient)
	if (akRecipient.HasKeyword(EncTypeLegendary))
		return LegendaryLegendaryChance.GetValueInt()
	else
		return NormalLegendaryChance.GetValueInt()
	endif
EndFunction

Bool RunOnce = false

Function AttachLegendaryModToPowerArmor(Actor akRecipient)
	debug.trace(self + " Checking if we should attach a legendary mod to power armor for " + akRecipient)

    ; We only want to do this once to prevent duplicate legendaries or skewed probability
    if(RunOnce)
		return
	endif
	
	; Set our flag to prevent this from running again right away, because if we call another script, this could get called again while we wait for it to return
	RunOnce = true

	if(Utility.RandomInt(1, 100) <= LegendaryChance(akRecipient))
		debug.trace(self + " Looking for power armor to attach a legendary mod to for " + akRecipient)

		; This requires F4SE - be aware
		Form[] inventory = akRecipient.GetInventoryItems()
		
		; Find all of the power armor pieces
		Form[] powerArmorPieces = new Form[0]
		int i = 0
		while(i < inventory.length)
            Form  item = inventory[i]

            if item.HasKeyword(ArmorTypePower) && !item.HasKeywordInFormList(ExcludeKeywordsList)
				debug.trace(akRecipient + "Item " + item + " in inventory has keyword " + ArmorTypePower)
				powerArmorPieces.Add(item)
			endif

			i += 1
		endwhile

		; If we have at least one piece of power armor, randomly select one to get a legendary mod
		int numPieces = powerArmorPieces.length
		if numPieces > 0
			int chosenIndex = Utility.RandomInt(0, numPieces - 1)
			debug.trace(akRecipient + "Selecting power armor at index " + chosenIndex + " out of " + numPieces + " total")
			Form itemToMod = powerArmorPieces[chosenIndex]
			AddLegendaryMod(akRecipient, itemToMod)
		else
			debug.trace(akRecipient + "No power armor pieces found to attach a legendary mod to")
		endif
    endif
EndFunction

Function AddLegendaryMod(ObjectReference akRecipient, Form  item, FormList ListOfSpecificModsToChooseFrom = None, FormList ListOfSpecificModsToDisallow = None)
	debug.trace(akRecipient + "Attaching legendary mod to inventory item " + item)

	; Create a temporary reference so we can use the base game's legendary item quest and all of its legendary mod rules
	ObjectReference itemObject = akRecipient.PlaceAtMe(item, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true, abDeleteWhenAble = false)
	
	;GET THE MODS WE CAN INSTALL ON THIS ITEM
	ObjectMod[] AllowedMods = LegendaryPowerArmorQuest.GetAllowedMods(itemObject, ListOfSpecificModsToChooseFrom, ListOfSpecificModsToDisallow)

	itemObject.Delete()

	;ROLL A DIE AND PICK A MOD
	int max = AllowedMods.Length
	if max > 0
		int dieRoll = Utility.RandomInt(0, max - 1)

		ObjectMod legendaryMod = AllowedMods[dieRoll]

		debug.trace(akRecipient + "Attaching " + legendaryMod + " to inventory item " + item)

		bool success = akRecipient.AttachModToInventoryItem(item, legendaryMod)

		if success == false
			Game.Warning(akRecipient + "FAILED TO ATTACH " + legendaryMod + " to "+ item)
		endif
		
	else
		Game.Warning(akRecipient + "AddLegendaryMod() for power armored NPC could not find any appropriate Legendary Mods to add to item: " + item)

	endif

EndFunction
