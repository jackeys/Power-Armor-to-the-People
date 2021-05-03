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

GlobalVariable Property PAttP_Setting_AbandonedPowerArmorReplacementChanceNone Auto Const Mandatory
{AUTOFILL}

CustomEvent AbandonedPowerArmorEnabledChanged

; Convert our ChanceNone into a Chance so it makes more sense
bool Property MCM_AbandonedPowerArmorReplacementEnabled Auto
bool Property AbandonedPowerArmorReplacementEnabled
    bool Function get()
        return PAttP_Setting_AbandonedPowerArmorReplacementChanceNone.GetValueInt() == 0
    EndFunction
    Function set(bool enabled)
        if enabled
            PAttP_Setting_AbandonedPowerArmorReplacementChanceNone.SetValue(0.0)
        else
            PAttP_Setting_AbandonedPowerArmorReplacementChanceNone.SetValue(100.0)
        EndIf

        ; Inform everyone that this changed, since it can cause placed objects to be enabled or disabled
        Var[] args = new Var[1]
        args[0] = enabled
        SendCustomEvent("AbandonedPowerArmorEnabledChanged", args)
    EndFunction
EndProperty

Event OnQuestInit()
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    RegisterCustomEvents()
    SetMCMPropertiesForDisplay()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    RegisterCustomEvents()
    SetMCMPropertiesForDisplay()
EndEvent

Function RegisterCustomEvents()
    debug.trace(self + " registering for MCM events")
    RegisterForExternalEvent("OnMCMClose", "OnMCMClose")
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
    MCM_AbandonedPowerArmorReplacementEnabled = AbandonedPowerArmorReplacementEnabled
EndFunction

; MCM properties are for display only, so this properly applies them to the game
Function ApplyMCMProperties()
    debug.trace(self + " applying MCM properties")
    LegendaryPowerArmorDropChance = MCM_LegendaryPowerArmorDropChance
    RaiderRareMixedPieceChance = MCM_RaiderRareMixedPieceChance
    RaiderRareSetChance = MCM_RaiderRareSetChance
    AbandonedPowerArmorReplacementEnabled = MCM_AbandonedPowerArmorReplacementEnabled
EndFunction