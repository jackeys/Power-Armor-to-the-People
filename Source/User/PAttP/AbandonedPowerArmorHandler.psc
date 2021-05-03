Scriptname PAttP:AbandonedPowerArmorHandler extends Quest

PAttP:ConfigurationManager Property ConfigManager Auto Const Mandatory
{AUTOFILL Configuration manager responsible for telling us what we should enable and disable}

ObjectReference[] Property ToEnableIfFeatureIsOff Auto Const
{Object references that should be enabled if the feature is on and disabled otherwise}

Struct InjectionInfo
    Form ItemToInject
    {This will typically be a LeveledItem containing a partial set of power armor, but it doesn't have to be}

    LeveledItem InjectInto
    {This will typically be a LeveledItem that gets directly referenced by the placed power armor furniture}

    int Level = 2
EndStruct

InjectionInfo[] Property InjectIfFeatureIsOn Auto Const
{Typically used to add a set of replacement leveled items into a LeveledItem so that they will be used instead of the ones from the default mods}

Event OnQuestInit()
    RegisterCustomEvents()
    HandleFeatureEnabled(ConfigManager.AbandonedPowerArmorReplacementEnabled)
EndEvent

Function HandleFeatureEnabled(bool abEnabled)
    EnableReferencesIfFeatureIsOff(abEnabled)
    UpdateInjections(abEnabled)
EndFunction

Function EnableReferencesIfFeatureIsOff(bool abEnabled)
    if(!abEnabled)
        EnableReferences(ToEnableIfFeatureIsOff)
    EndIf
EndFunction

Function EnableReferences(ObjectReference[] akReferences)
    if !akReferences
        return
    EndIf

    debug.trace(Self + " is enabling these references: " + akReferences)
    
    int i = 0
    while i < akReferences.length
        akReferences[i].Enable()
        i += 1
    EndWhile
EndFunction

Function UpdateInjections(bool abEnabled)
    if !InjectIfFeatureIsOn
        return
    EndIf

    if abEnabled
        debug.trace(self + " is injecting because abandoned power armor replacements are enabled: " + InjectIfFeatureIsOn)
        int i = 0
        while i < InjectIfFeatureIsOn.length
            InjectionInfo currentInjection = InjectIfFeatureIsOn[i]
            currentInjection.InjectInto.AddForm(currentInjection.ItemToInject, currentInjection.Level, 1)
            i += 1
        EndWhile
    Else
        debug.trace(self + " is reverting because abandoned power armor replacements are disabled: " + InjectIfFeatureIsOn)
        int i = 0
        while i < InjectIfFeatureIsOn.length
            InjectIfFeatureIsOn[i].InjectInto.Revert()
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

    HandleFeatureEnabled(akArgs[0] as bool)
EndEvent
