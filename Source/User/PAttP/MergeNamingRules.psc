Scriptname PAttP:MergeNamingRules extends Quest const
{Merges naming rules from the core Power Armor to the People module into another naming ruleset}

PAttP:NamingRuleManager Property RuleManager Auto Const Mandatory
{Core naming rule manager to listen to for naming changes}

InstanceNamingRules Property DestinationNamingRuleset Auto Const Mandatory
{Naming rules that changes from the rule manager should be merged into}

Event OnInit()
	; Register for the change event before merging the core ruleset to make sure we don't miss anything
	RegisterCustomEvents()

	debug.trace(Self + " is merging core ruleset " + RuleManager.CoreNamingRules + " into " + DestinationNamingRuleset)
	DestinationNamingRuleset.MergeWith(RuleManager.CoreNamingRules)
EndEvent

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People naming ruleset changes")
	RegisterForCustomEvent(RuleManager, "NewRulesetRegistered")
EndFunction

Event PAttP:NamingRuleManager.NewRulesetRegistered(PAttP:NamingRuleManager akSender, Var[] akArgs)
	if akSender != RuleManager
		debug.trace("Ignoring naming ruleset change from unknown rule manager " + akSender)
		return
	endif

	if(!akArgs)
		debug.trace("Received empty arguments in ruleset merge event from " + akSender)
		return
	endif

	InstanceNamingRules sourceRules = akArgs[0] as InstanceNamingRules
	if !sourceRules
		debug.trace("Unable to get instance naming rules from naming rule event argument " + akArgs[0])
		return
	endif

	debug.trace(Self + " is merging new ruleset " + sourceRules + " into " + DestinationNamingRuleset)
	DestinationNamingRuleset.MergeWith(sourceRules)
EndEvent
