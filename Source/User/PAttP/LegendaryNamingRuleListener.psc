Scriptname PAttP:LegendaryNamingRuleListener extends Quest const
{Use to update your naming rules dynamically when an external mod adds new names to Power Armor to the People.}

PAttP:LegendaryPowerArmorManager Property LegendaryManager Auto Const Mandatory
{Autofill}

InstanceNamingRules[] Property PowerArmorNamingRules Auto Const
{The naming rules that should get the names from the Power Armor to the People main plugin}

Event OnQuestInit()
    RegisterCustomEvents()
    MergeRules(LegendaryManager.DefaultPowerArmorNamingRules)
EndEvent

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People naming rule merges")
    RegisterForCustomEvent(LegendaryManager, "MergeNamingRules")
EndFunction

Function MergeRules(InstanceNamingRules akRulesToMerge)
    int i = 0
	while i < PowerArmorNamingRules.length
		debug.trace(self + " Merging naming rules " + akRulesToMerge + " into " + PowerArmorNamingRules[i])
		PowerArmorNamingRules[i].MergeWith(akRulesToMerge)
		i += 1
	endWhile
EndFunction

Event PAttP:LegendaryPowerArmorManager.MergeNamingRules(PAttP:LegendaryPowerArmorManager akSender, Var[] akArgs)
    if akSender != LegendaryManager
        debug.trace(self + " received unexpected naming rule merge event from " + akSender)
        return
    EndIf

    InstanceNamingRules newRules = akArgs[0] as InstanceNamingRules

    if !newRules
        debug.trace(self + " received an invalid argument that can't be turned into instance naming rules: " + akArgs[0])
        return
    endIf

    MergeRules(newRules)
EndEvent