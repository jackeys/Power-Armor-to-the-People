Scriptname PAttP:ChangeJetpackSettingsQuest extends Quest
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

Message Property JetpackModDetectedMessage Auto Const Mandatory

bool Property UseCustomConfiguration = true Auto

; The typo "inital" is in the actual game setting name
string JetpackInitialDrainSettingName = "fJetpackDrainInital" const
string JetpackSustainedDrainSettingName = "fJetpackDrainSustained" const
string JetpackInitialThrustSettingName = "fJetpackThrustInitial" const

string HasModifiedJetpackSettingName = "bPATTP_HasModifiedJetpackSettings" const

int JETPACK_SETTING_UNMODIFIED = 0 const
int JETPACK_SETTING_MODIFIED = 1 const

float VANILLA_AP_DRAIN = 64.0 const
float VANILLA_THRUST = 768.0 const

float CurrentGameSetting_APDrain
float CurrentGameSetting_Thrust

float LastGameSetting_APDrain = 64.0
float LastGameSetting_Thrust = 768.0

Event OnQuestInit()
    StoreCurrentGameSettings()

    DetectJetpackMods()

    ; We want to watch for when the game is loaded, since game settings can go back to their defaults then
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    ; We want to watch when the player "sits," since entering and exiting power armor counts as sitting
    RegisterForRemoteEvent(Game.GetPlayer(), "OnSit")
    UpdateJetpackSettings()
EndEvent

Function DetectJetpackMods()
    if F4SE.GetVersionMinor() >= 3 && (CurrentGameSetting_APDrain != LastGameSetting_APDrain || CurrentGameSetting_Thrust != LastGameSetting_Thrust)
        LastGameSetting_APDrain = CurrentGameSetting_APDrain
        LastGameSetting_Thrust = CurrentGameSetting_Thrust
        HandleJetpackModDetected()
    endIf
EndFunction

int JETPACK_MOD_RESPONSE_OUT_OF_PA = 0
int JETPACK_MOD_RESPONSE_PA = 1
int JETPACK_MOD_RESPONSE_IGNORE = 2
int JETPACK_MOD_RESPONSE_DISABLE = 3

Function HandleJetpackModDetected()
    int response = JetpackModDetectedMessage.Show(Game.GetGameSettingFloat(JetpackSustainedDrainSettingName), Game.GetGameSettingFloat(JetpackInitialThrustSettingName))

    if response == JETPACK_MOD_RESPONSE_OUT_OF_PA
        DefaultJetpackAPDrain_OutOfPA.SetValue(CurrentGameSetting_APDrain)
        DefaultJetpackThrust_OutOfPA.SetValue(CurrentGameSetting_Thrust)
    elseif response == JETPACK_MOD_RESPONSE_PA
        DefaultJetpackAPDrain.SetValue(CurrentGameSetting_APDrain)
        DefaultJetpackThrust.SetValue(CurrentGameSetting_Thrust)
        ; We should set the values outside of power armor, too, since adding a standalone jetpack later would make it feel heavier than power armor (assuming no one ever mods their game to make the jetpack fly even less)
        DefaultJetpackAPDrain_OutOfPA.SetValue(CurrentGameSetting_APDrain)
        DefaultJetpackThrust_OutOfPA.SetValue(CurrentGameSetting_Thrust)
    elseif response == JETPACK_MOD_RESPONSE_DISABLE
        UseCustomConfiguration = false
    endIf
EndFunction

Function StoreCurrentGameSettings()
    debug.trace(self + " Storing current game settings: AP Drain = " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) + " | Thrust = " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
    CurrentGameSetting_APDrain = Game.GetGameSettingFloat(JetpackSustainedDrainSettingName)
    CurrentGameSetting_Thrust = Game.GetGameSettingFloat(JetpackInitialThrustSettingName)
EndFunction

Function UpdateJetpackSettings()
    ChangeJetpackSettings(Game.GetPlayer().GetValue(PATTP_AV_JetpackThrustIncreasePercent), Game.GetPlayer().GetValue(PATTP_AV_JetpackDrainReductionPercent))
EndFunction

Event Actor.OnPlayerLoadGame(Actor akSender)
    ; When the game is loaded for the very first time, the game settings will match what is in the files, but if another saved game was loaded before this that changed the game settings, it will also be reflected here
    ; Since we can't trust that the game settings actually reflect what is in the files unless this is our first loaded game, we use a canary game setting to check
    ; If this is set, it means that Power Armor to the People in a different saved game already changed the game setting for the jetpack, so we cannot trust the current values
    if Game.GetGameSettingInt(HasModifiedJetpackSettingName) == JETPACK_SETTING_UNMODIFIED
        StoreCurrentGameSettings()
    endIf

    DetectJetpackMods()

    UpdateJetpackSettings()
EndEvent

Event Actor.OnSit(Actor akSender, ObjectReference akFurniture)
    UpdateJetpackSettings()
EndEvent

Function ChangeJetpackSettings(float afThrustIncreasePercent, float afAPDrainReductionPercent)
    ; Set the modified flag before we make changes, just in case another game is loaded while the changes are in progress
    if afThrustIncreasePercent != 0 || afAPDrainReductionPercent != 0
        Game.SetGameSettingInt(HasModifiedJetpackSettingName, JETPACK_SETTING_MODIFIED)
    endIf
    
    ChangeJetpackThrustSettings(afThrustIncreasePercent)
    ChangeJetpackDrainSettings(afAPDrainReductionPercent)
    
    ; Set the unmodified flag after we make changes, just in case another game is loaded while the changes are in progress
    if afThrustIncreasePercent == 0 && afAPDrainReductionPercent == 0
        Game.SetGameSettingInt(HasModifiedJetpackSettingName, JETPACK_SETTING_UNMODIFIED)
    endIf
EndFunction

Function ChangeJetpackThrustSettings(float afPercentIncrease)
    float newValue = AdjustedThrustValue(afPercentIncrease)
    
    Game.SetGameSettingFloat(JetpackInitialThrustSettingName, newValue)
    debug.trace("Jetpack thrust is now " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
EndFunction

float Function AdjustedThrustValue(float afPercentIncrease)
    debug.trace("Jetpack thrust should be increased by " + afPercentIncrease + "%")

    if !UseCustomConfiguration
        debug.trace(self + " is using the thrust game setting directly")
        return CurrentGameSetting_Thrust * (1 + (afPercentIncrease / 100))
    elseif Game.GetPlayer().WornHasKeyword(ArmorTypePower)
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
    
    if !UseCustomConfiguration
        debug.trace(self + " is using the AP drain game setting directly")
        return CurrentGameSetting_APDrain * (1 - (TotalDrainReduction / 100))
    elseif Game.GetPlayer().WornHasKeyword(ArmorTypePower)
        return DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100))
    else
        debug.trace(self + " target appears to have jetpack outside of power armor")
        return DefaultJetpackAPDrain_OutOfPA.GetValue() * (1 - (TotalDrainReduction / 100))
    endIf
EndFunction