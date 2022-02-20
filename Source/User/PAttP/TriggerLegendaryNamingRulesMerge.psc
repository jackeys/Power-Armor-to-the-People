Scriptname PAttP:TriggerLegendaryNamingRulesMerge extends Quest const
{Generic quest that can be started by external mods to merge the default legendary naming rules after they have injected into them}

PAttP:LegendaryPowerArmorManager Property LegendaryManager Auto Const Mandatory
{Autofill}

Event OnQuestInit()
    debug.trace(self + " Triggering legendary rules merge from external mod")
    LegendaryManager.SendMergeRulesEvent(LegendaryManager.DefaultPowerArmorNamingRules)

    ; Allow this quest to be started again
    Reset()
EndEvent
