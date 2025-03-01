Scriptname PAttP:AbandonedPowerArmorHandler extends Quest
{Script to handle the one-way transition if the abandoned power armor feature is turned off. All records in the mod should reflect having the feature turned on.}

PAttP:ConfigurationManager Property ConfigManager Auto Const Mandatory
{AUTOFILL Configuration manager responsible for telling us what we should enable and disable}

Struct DynamicReference
    string PluginFile
    {The plugin filename that contains the reference}

    int FormId
    {The form ID of the reference within the plugin}

    float editorPosX
    {The X position of the reference in the plugin - the reference will only be disabled if the position matches the editor position}

    float editorPosY
    {The Y position of the reference in the plugin - the reference will only be disabled if the position matches the editor position}

    float editorPosZ
    {The Z position of the reference in the plugin - the reference will only be disabled if the position matches the editor position}

    float positionTolerance = 0.1
    {How far away from the editor position an object can be without being considered "moved"}
EndStruct

DynamicReference[] Property DynamicallyDisableReferences Auto Const
{Dynamic references that will be disabled if they are still in their starting position, but will be enabled if the feature is turned off}

ObjectReference[] Property ToEnableIfFeatureIsOff Auto Const
{Object references that should be enabled if the feature is off - these should be initially disabled}


ObjectReference[] Property ToDisableIfFeatureIsOff Auto Const
{Object references that should be disabled if the feature is off - these should not be anything the player can take with them, like power armor furniture or items, as these will still disappear if they have been moved}

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

Quest[] Property QuestsToStartIfDisabled Auto Const
{Some power armor mods add their sets through a quest, which should be made to no longer run at start up. These quests can be put here to start if the feature is disabled.}

Event OnQuestInit()
    RegisterCustomEvents()
    HandleFeatureEnabled(ConfigManager.AbandonedPowerArmorReplacementEnabled)
EndEvent

Function HandleFeatureEnabled(bool abRemoveAbandonedPowerArmor)
    UpdateDynamicReferencesEnabled(abRemoveAbandonedPowerArmor)
    UpdateReferencesEnabled(abRemoveAbandonedPowerArmor)
    UpdateInjections(abRemoveAbandonedPowerArmor)
    StartQuests(abRemoveAbandonedPowerArmor)
EndFunction

Function UpdateDynamicReferencesEnabled(bool abRemoveAbandonedPowerArmor)
    if !DynamicallyDisableReferences
        return
    EndIf

    int i = 0
    while i < DynamicallyDisableReferences.length
        DynamicReference reference = DynamicallyDisableReferences[i]
        ObjectReference object = Game.GetFormFromFile(reference.FormId, reference.PluginFile) as ObjectReference

        if object
            if abRemoveAbandonedPowerArmor
                if !HasObjectMovedFromEditorPosition(reference, object)
                    debug.trace(self + " is disabling a reference because it has not moved: " + object)
                    object.Disable()
                EndIf
            else
                debug.trace(self + " is enabling a reference: " + object)
                object.Enable()
            endIf
        else
            debug.trace(self + " did not find an object reference that matches " + reference)
            RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
        EndIf
        i += 1
    EndWhile
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    ; Check if we can find the dynamic references now 
    UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    UpdateDynamicReferencesEnabled(ConfigManager.AbandonedPowerArmorReplacementEnabled)
EndEvent

bool Function HasObjectMovedFromEditorPosition(DynamicReference akDynamicReference, ObjectReference akObject)
    return Math.abs(akDynamicReference.editorPosX - akObject.GetPositionX()) > akDynamicReference.positionTolerance || Math.abs(akDynamicReference.editorPosY - akObject.GetPositionY()) > akDynamicReference.positionTolerance || Math.abs(akDynamicReference.editorPosZ - akObject.GetPositionZ()) > akDynamicReference.positionTolerance
EndFunction

Function UpdateReferencesEnabled(bool abFeatureEnabled)
    if(!abFeatureEnabled)
        EnableReferences(ToEnableIfFeatureIsOff)
        DisableReferences(ToDisableIfFeatureIsOff)
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

Function DisableReferences(ObjectReference[] akReferences)
    if !akReferences
        return
    EndIf

    debug.trace(Self + " is disabling these references: " + akReferences)
    
    int i = 0
    while i < akReferences.length
        akReferences[i].Disable()
        i += 1
    EndWhile
EndFunction

Function UpdateInjections(bool abEnabled)
    if !Injections
        return
    EndIf

    debug.trace(self + " is injecting abandoned power armor changes: " + Injections)
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

Function StartQuests(bool abEnabled)
    if(abEnabled || !QuestsToStartIfDisabled)
        return
    EndIf
    
    debug.trace(self + " is starting quests because abandoned power armor replacements are disabled: " + QuestsToStartIfDisabled)
    int i = 0
    while i < QuestsToStartIfDisabled.length
        if !QuestsToStartIfDisabled[i].Start()
            debug.trace(self + " failed to start quest " + QuestsToStartIfDisabled[i])
        EndIf
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
