Scriptname PAttP:AbandonedPowerArmorHandler extends Quest

PAttP:ConfigurationManager Property ConfigManager Auto Const Mandatory
{AUTOFILL Configuration manager responsible for telling us what we should enable and disable}

ObjectReference[] Property ToEnableIfFeatureIsOff Auto Const
{Object references that should be enabled if the feature is on and disabled otherwise}

Struct InjectionInfo
    Form ItemToInjectIfEnabled
    {This will typically be a LeveledItem containing a partial set of power armor, but it doesn't have to be}

    Form ItemToInjectIfDisabled
    {This should be the LeveledItem from the original mod that placed the item}

    LeveledItem InjectInto
    {This will typically be a LeveledItem that gets directly referenced by the placed power armor furniture}

    int Level = 1
EndStruct

InjectionInfo[] Property Injections Auto Const
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
    if !Injections
        return
    EndIf

    debug.trace(self + " is injecting because abandoned power armor replacements are enabled: " + Injections)
    int i = 0
    while i < Injections.length
        InjectionInfo currentInjection = Injections[i]
        currentInjection.InjectInto.Revert()
            
        if abEnabled
                currentInjection.InjectInto.AddForm(currentInjection.ItemToInjectIfEnabled, currentInjection.Level, 1)
            else
                currentInjection.InjectInto.AddForm(currentInjection.ItemToInjectIfDisabled, currentInjection.Level, 1)
        endIf
        
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

    HandleFeatureEnabled(akArgs[0] as bool)
EndEvent
