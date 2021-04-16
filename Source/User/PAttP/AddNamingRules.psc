Scriptname PAttP:AddNamingRules extends Quest const
{Adds naming rules to the core Power Armor to the People naming ruleset for all modules}

PAttP:NamingRuleManager Property RuleManager Auto Const Mandatory
{Core naming rule manager to publish to for naming changes}

InstanceNamingRules Property SourceNamingRuleset Auto Const Mandatory
{Naming rules that should be published to the rest of Power Armor to the People}

Event OnInit()
    PublishRuleset()
EndEvent

Function PublishRuleset()
	RuleManager.AddRuleset(SourceNamingRuleset)
EndFunction
