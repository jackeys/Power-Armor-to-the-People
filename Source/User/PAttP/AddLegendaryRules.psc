Scriptname PAttP:AddLegendaryRules extends Quest
{Adds items to the main LegendaryItemQuest's script's array}

LegendaryItemQuestScript Property LegendaryItemQuest const auto mandatory
{Autofill}

LegendaryItemQuestScript:LegendaryModRule[] Property LegendaryModRules auto
{After the item is spawned, check these rules, then add an appropriate legendary mod}

Event OnQuestInit()
	AddItemsToBaseGameArray()
EndEvent

Function AddItemsToBaseGameArray()
	
	int i = 0
	int len = LegendaryModRules.length
	
	;loop through our array
	while (i < len)
		
		;add our current item to the main game quest's array
		LegendaryItemQuest.LegendaryModRules.add(LegendaryModRules[i])

		i += 1
	endwhile
EndFunction
