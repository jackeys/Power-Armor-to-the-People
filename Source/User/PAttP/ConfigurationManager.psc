Scriptname PAttP:ConfigurationManager extends Quest
{Manages configurations that are more complex than just setting a global variable, such as those that require a numeric conversion between what a user sees and what is used}

; MCM can only see Auto properties, but Auto properties can't have custom get and set functions, so we need to map the MCM property to a full property that can do what needs to be done

GlobalVariable Property PAttP_Setting_LegendaryPA_DropChanceNone Auto Const Mandatory
{AUTOFILL}

; Convert our ChanceNone into a Chance so it makes more sense
float Property MCM_LegendaryPowerArmorDropChance Auto
float Property LegendaryPowerArmorDropChance
    float Function get()
        return 100.0 - PAttP_Setting_LegendaryPA_DropChanceNone.GetValue()
    EndFunction
    Function set(float value)
        PAttP_Setting_LegendaryPA_DropChanceNone.SetValue(100.0 - value)
    EndFunction
EndProperty

GlobalVariable Property PAttP_Setting_RaiderRareMixedSetPiecesChanceNone Auto Const Mandatory
{AUTOFILL}

; Convert our ChanceNone into a Chance so it makes more sense
float Property MCM_RaiderRareMixedPieceChance Auto
float Property RaiderRareMixedPieceChance
    float Function get()
        return 100.0 - PAttP_Setting_RaiderRareMixedSetPiecesChanceNone.GetValue()
    EndFunction
    Function set(float value)
        PAttP_Setting_RaiderRareMixedSetPiecesChanceNone.SetValue(100.0 - value)
    EndFunction
EndProperty

GlobalVariable Property PAttP_Setting_RaiderRareSetChanceNone Auto Const Mandatory
{AUTOFILL}

; Convert our ChanceNone into a Chance so it makes more sense
float Property MCM_RaiderRareSetChance Auto
float Property RaiderRareSetChance
    float Function get()
        return 100.0 - PAttP_Setting_RaiderRareSetChanceNone.GetValue()
    EndFunction
    Function set(float value)
        PAttP_Setting_RaiderRareSetChanceNone.SetValue(100.0 - value)
    EndFunction
EndProperty

GlobalVariable Property PAttP_Setting_ScavengerPowerArmorChanceNone Auto Const Mandatory
{AUTOFILL}

; Convert our ChanceNone into a Chance so it makes more sense
float Property MCM_ScavengerPowerArmorChance Auto
float Property ScavengerPowerArmorChance
    float Function get()
        return 100.0 - PAttP_Setting_ScavengerPowerArmorChanceNone.GetValue()
    EndFunction
    Function set(float value)
        PAttP_Setting_ScavengerPowerArmorChanceNone.SetValue(100.0 - value)
    EndFunction
EndProperty

GlobalVariable Property PAttP_Setting_ScavengerFullSetChanceNone Auto Const Mandatory
{AUTOFILL}

; Convert our ChanceNone into a Chance so it makes more sense
float Property MCM_ScavengerFullSetChance Auto
float Property ScavengerFullSetChance
    float Function get()
        return 100.0 - PAttP_Setting_ScavengerFullSetChanceNone.GetValue()
    EndFunction
    Function set(float value)
        PAttP_Setting_ScavengerFullSetChanceNone.SetValue(100.0 - value)
    EndFunction
EndProperty

GlobalVariable Property PAttP_Setting_AbandonedPowerArmorReplacementChance Auto Const Mandatory
{AUTOFILL Variable to hold the chance the replacement should be used for leveled lists that depend on the feature}

GlobalVariable Property PAttP_Setting_AbandonedPowerArmorReplacementChanceNone Auto Const Mandatory
{AUTOFILL Variable to hold the chance the replacement should not be used for leveled lists that depend on the feature (inverse of the above)}

GlobalVariable Property PATTP_Setting_T51ForRaiders Auto Const Mandatory
{AUTOFILL}

GlobalVariable Property PATTP_Setting_X01ForBoS Auto Const Mandatory
{AUTOFILL}

PAttP:InjectionManager Property InjectionManager Auto Const Mandatory

bool Property MCM_ManuallyManageModDependentSettings = False Auto
{Whether the configuration manager should adjust settings that are dependent on other mods or let the user set them manually}

CustomEvent AbandonedPowerArmorEnabledChanged

; We set both a Chance and ChanceNone to give integrators flexibility
bool Property AbandonedPowerArmorReplacementEnabled
    bool Function get()
        return PAttP_Setting_AbandonedPowerArmorReplacementChance.GetValueInt() == 100.0
    EndFunction
    Function set(bool enabled)
        if enabled
            PAttP_Setting_AbandonedPowerArmorReplacementChance.SetValue(100.0)
            PAttP_Setting_AbandonedPowerArmorReplacementChanceNone.SetValue(0.0)
        else
            PAttP_Setting_AbandonedPowerArmorReplacementChance.SetValue(0.0)
            PAttP_Setting_AbandonedPowerArmorReplacementChanceNone.SetValue(100.0)
        EndIf

        ; Inform everyone that this changed, since it can cause placed objects to be enabled or disabled
        Var[] args = new Var[1]
        args[0] = enabled
        SendCustomEvent("AbandonedPowerArmorEnabledChanged", args)
    EndFunction
EndProperty

Function RestoreOriginalAbandonedPowerArmorSets()
    debug.trace("Restoring original abandoned power armor sets")
    AbandonedPowerArmorReplacementEnabled = false
    debug.notification("Original abandoned power armor sets restored")
EndFunction

Event OnQuestInit()
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    RegisterCustomEvents()

    ; Always auto-detect settings when the mod is first installed to give the player sensible defaults
    AutodetectSettings()

    SetMCMPropertiesForDisplay()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    RegisterCustomEvents()

    if !MCM_ManuallyManageModDependentSettings
        AutodetectSettings()
    EndIf

    SetMCMPropertiesForDisplay()
EndEvent

Function RegisterCustomEvents()
    debug.trace(self + " registering for MCM events")
    RegisterForExternalEvent("OnMCMClose", "OnMCMClose")
EndFunction

Function AutodetectSettings()
    debug.trace(self + " auto-detecting settings")
    bool injectionRefreshNeeded = false

    ; Check to see if any plugins with automatic settings are installed
    injectionRefreshNeeded = ChangeValueBool(PATTP_Setting_T51ForRaiders, Game.IsPluginInstalled("consistent power armor overhaul.esp")) || injectionRefreshNeeded
    injectionRefreshNeeded = ChangeValueBool(PATTP_Setting_X01ForBoS, Game.IsPluginInstalled("consistent power armor overhaul.esp") || Game.IsPluginInstalled("armorkeywords.esm")) || injectionRefreshNeeded

    if injectionRefreshNeeded
        InjectionManager.RefreshListInjections(true)
    EndIf
EndFunction

; Returns whether the value was changed or not
bool Function ChangeValueBool(GlobalVariable akSetting, bool value)
    if akSetting.GetValueInt() == value as int
        return False
    EndIf

    akSetting.SetValueInt(value as int)
    return True    
EndFunction

Function OnMCMClose()
    ApplyMCMProperties()
EndFunction

; These need to be set so that MCM can show the right value
; Note that we don't do this using the OnMCMOpen event because only MCM can change these settings and the necessary refresh is noticable to the user
Function SetMCMPropertiesForDisplay()
    debug.trace(self + " updating MCM properties")
    MCM_LegendaryPowerArmorDropChance = LegendaryPowerArmorDropChance
    MCM_RaiderRareMixedPieceChance = RaiderRareMixedPieceChance
    MCM_RaiderRareSetChance = RaiderRareSetChance
    MCM_ScavengerFullSetChance = ScavengerFullSetChance
    MCM_ScavengerPowerArmorChance = ScavengerPowerArmorChance
EndFunction

; MCM properties are for display only, so this properly applies them to the game
Function ApplyMCMProperties()
    debug.trace(self + " applying MCM properties")
    LegendaryPowerArmorDropChance = MCM_LegendaryPowerArmorDropChance
    RaiderRareMixedPieceChance = MCM_RaiderRareMixedPieceChance
    RaiderRareSetChance = MCM_RaiderRareSetChance
    ScavengerFullSetChance = MCM_ScavengerFullSetChance
    ScavengerPowerArmorChance = MCM_ScavengerPowerArmorChance
EndFunction