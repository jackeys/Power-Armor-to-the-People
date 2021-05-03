Scriptname PAttP:AbandonedPowerArmorHandler extends Quest

PAttP:ConfigurationManager Property ConfigManager Auto Const Mandatory
{AUTOFILL Configuration manager responsible for telling us what we should enable and disable}

ObjectReference[] Property ToEnableIfFeatureIsOff Auto Const
{Object references that should be enabled if the feature is on and disabled otherwise}

Event OnQuestInit()
    RegisterCustomEvents()
    EnableReferencesIfFeatureIsOff(ConfigManager.AbandonedPowerArmorReplacementEnabled)
EndEvent

Function EnableReferencesIfFeatureIsOff(bool abEnabled)
    if(!abEnabled)
        EnableReferences(ToEnableIfFeatureIsOff)
    EndIf
EndFunction

Function EnableReferences(ObjectReference[] akReferences)
    if !akReferences
        return
    EndIf

    debug.trace(Self + " is setting enabling these references: " + akReferences)
    
    int i = 0
    while i < akReferences.length
        akReferences[i].Enable()
        i += 1
    EndWhile
EndFunction


Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People abandoned power armor configuration changes")
    RegisterForCustomEvent(ConfigManager, "AbandonedPowerArmorEnabledChanged")
EndFunction

Event PAttP:ConfigurationManager.AbandonedPowerArmorEnabledChanged(PAttP:ConfigurationManager akSender, Var[] akArgs)
    if akSender != ConfigManager
        debug.trace(self + " received unexpected config change event from " + akSender)
        return
    EndIf

    if !akArgs || akArgs.length < 1
        debug.trace(self + " received config change event without the value as an argument")
        return
    EndIf

    EnableReferencesIfFeatureIsOff(akArgs[0] as bool)
EndEvent
