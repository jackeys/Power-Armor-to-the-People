Scriptname PAttP:NamingRuleManager Extends Quest
{Manages the registration and merging of naming rules within Power Armor to the People}

InstanceNamingRules Property CoreNamingRules Auto Const Mandatory
{Core naming rules that other modules should merge to get all supported names}

CustomEvent NewRulesetRegistered

Function AddRuleset(InstanceNamingRules newRuleset)
    debug.trace("Adding new ruleset " + newRuleset + " for all Power Armor to the People modules")

    ; Merge the ruleset first to make sure anyone who merges this gets the changes right away, since they might not be listening yet
    CoreNamingRules.MergeWith(newRuleset)

    ; Send the new ruleset to anyone who is listening so they can merge it, too
    Var[] kargs = new Var[1]
    kargs[0] = newRuleset
    SendCustomEvent("NewRulesetRegistered", kargs)
EndFunction
