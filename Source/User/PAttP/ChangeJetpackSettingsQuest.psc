Scriptname PAttP:ChangeJetpackSettingsQuest extends Quest const
{Changes jetpack game settings to allow different pieces of gear to have different thrust and AP drain - requires F4SE}

ActorValue Property PATTP_AV_JetpackThrustIncreasePercent Auto Const Mandatory
{AUTOFILL}

ActorValue Property PATTP_AV_JetpackDrainReductionPercent Auto Const Mandatory
{AUTOFILL}

Keyword Property ArmorTypePower Auto Const Mandatory
{AUTOFILL}

GlobalVariable Property DefaultJetpackAPDrain Auto Const Mandatory
{The jetpack drain that should be used while in power armor and no items that affect drain are used}

GlobalVariable Property DefaultJetpackThrust Auto Const Mandatory
{The jetpack initial and sustained thrust that should be used while in power armor and no items that affect thrust are used}

GlobalVariable Property DefaultJetpackAPDrain_OutOfPA Auto Const Mandatory
{The jetpack drain that should be used while outside of power armor and no items that affect drain are used}

GlobalVariable Property DefaultJetpackThrust_OutOfPA Auto Const Mandatory
{The jetpack initial and sustained thrust that should be used while outside of power armor and no items that affect thrust are used}

; The typo "inital" is in the actual game setting name
string Property JetpackInitialDrainSettingName = "fJetpackDrainInital" autoReadOnly
string Property JetpackSustainedDrainSettingName = "fJetpackDrainSustained" autoReadOnly
string Property JetpackInitialThrustSettingName = "fJetpackThrustInitial" autoReadOnly Hidden

Event OnQuestInit()
    ; We want to watch for when the game is loaded, since game settings can go back to their defaults then
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    ; We want to watch when the player "sits," since entering and exiting power armor counts as sitting
    RegisterForRemoteEvent(Game.GetPlayer(), "OnSit")
    UpdateJetpackSettings()
EndEvent

Function UpdateJetpackSettings()
    ChangeJetpackSettings(Game.GetPlayer().GetValue(PATTP_AV_JetpackThrustIncreasePercent), Game.GetPlayer().GetValue(PATTP_AV_JetpackDrainReductionPercent))
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
    UpdateJetpackSettings()
EndEvent

Event Actor.OnSit(Actor akSender, ObjectReference akFurniture)
    UpdateJetpackSettings()
EndEvent

Function ChangeJetpackSettings(float afThrustIncreasePercent, float afAPDrainReductionPercent)
    ChangeJetpackThrustSettings(afThrustIncreasePercent)
    ChangeJetpackDrainSettings(afAPDrainReductionPercent)
EndFunction

Function ChangeJetpackThrustSettings(float afPercentIncrease)
    float newValue = AdjustedThrustValue(afPercentIncrease)
    
    Game.SetGameSettingFloat(JetpackInitialThrustSettingName, newValue)
    debug.trace("Jetpack thrust is now " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
EndFunction

float Function AdjustedThrustValue(float afPercentIncrease)
    debug.trace("Jetpack thrust should be increased by " + afPercentIncrease + "%")

    if Game.GetPlayer().WornHasKeyword(ArmorTypePower)
        return DefaultJetpackThrust.GetValue() * (1 + (afPercentIncrease / 100))
    else
        debug.trace(self + " target appears to have jetpack outside of power armor")
        return DefaultJetpackThrust_OutOfPA.GetValue() * (1 + (afPercentIncrease / 100))
    endIf
EndFunction

Function ChangeJetpackDrainSettings(float afPercentReduction)
    float newValue = AdjustedDrainValue(afPercentReduction)
    
    Game.SetGameSettingFloat(JetpackInitialDrainSettingName, newValue)
    Game.SetGameSettingFloat(JetpackSustainedDrainSettingName, newValue)
    debug.trace("Jetpack drain settings are now " + Game.GetGameSettingFloat(JetpackInitialDrainSettingName) + " initial, " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) + " sustained")
EndFunction

float Function AdjustedDrainValue(float afPercentReduction)
    float TotalDrainReduction = Math.Min(afPercentReduction, 90)
    debug.trace("Jetpack AP drain should be lowered by " + TotalDrainReduction + "%")
    
    if Game.GetPlayer().WornHasKeyword(ArmorTypePower)
        return DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100))
    else
        debug.trace(self + " target appears to have jetpack outside of power armor")
        return DefaultJetpackAPDrain_OutOfPA.GetValue() * (1 - (TotalDrainReduction / 100))
    endIf
EndFunction