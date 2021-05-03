Scriptname PAttP:AbandonedPowerArmorHandler extends Quest

PAttP:ConfigurationManager Property ConfigManager Auto Const Mandatory
{AUTOFILL Configuration manager responsible for telling us what we should enable and disable}

ObjectReference[] Property ToEnableIfFeatureIsOn Auto Const
{Object references that should be enabled if the feature is on and disabled otherwise}

ObjectReference[] Property ToDisableIfFeatureIsOn Auto Const
{Object references that should be disabled if the feature is on and enabled otherwise}

Event OnQuestInit()
    RegisterCustomEvents()
    EnableDisableReferences(ConfigManager.AbandonedPowerArmorReplacementEnabled)
EndEvent

Function EnableDisableReferences(bool abFeatureEnabled)
    SetEnabledForReferences(abFeatureEnabled, ToEnableIfFeatureIsOn)
    SetEnabledForReferences(!abFeatureEnabled, ToDisableIfFeatureIsOn)
EndFunction

Function SetEnabledForReferences(bool abEnabled, ObjectReference[] akReferences)
    if !akReferences
        return
    EndIf

    debug.trace(Self + " is setting enabled to " + abEnabled + " for list " + akReferences)
    
    int i = 0
    if abEnabled
        while i < akReferences.length
            akReferences[i].Enable()
            i += 1
        EndWhile
    else
        while i < akReferences.length
            akReferences[i].Disable()
            i += 1
        EndWhile
    EndIf
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

    EnableDisableReferences(akArgs[0] as bool)
EndEvent
