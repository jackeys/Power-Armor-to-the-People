Scriptname PAttP:AddItemQuest extends Quest const

ObjectReference Property AddItemTo Auto Const Mandatory
LeveledItem Property ItemToAdd Auto Const Mandatory

Event OnQuestInit()
    AddItemToReference()
EndEvent

Function AddItemToReference()
    AddItemTo.AddItem(ItemToAdd)
EndFunction