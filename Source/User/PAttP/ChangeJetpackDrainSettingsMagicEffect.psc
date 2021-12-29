Scriptname PAttP:ChangeJetpackDrainSettingsMagicEffect extends ActiveMagicEffect
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

ActorValue Property PATTP_AV_JetpackDrainReductionPercent Auto Const Mandatory
{AUTOFILL}

GlobalVariable Property PATTP_Cache_DefaultJetpackAPDrain Auto Const Mandatory
{AUTOFILL}

; The typo "inital" is in the actual game setting name
string JetpackInitialDrainSettingName = "fJetpackDrainInital"
string JetpackSustainedDrainSettingName = "fJetpackDrainSustained"

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf

    ; If we have never set the original AP drain before, we should do so now so we know how to restore it
    if PATTP_Cache_DefaultJetpackAPDrain.GetValue() == 0.0
        debug.trace("Setting default jetpack AP drain to " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
        PATTP_Cache_DefaultJetpackAPDrain.SetValue(Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
    endIf
    
    ; The game setting will reset when the game is loaded, so we need to reapply it
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_JetpackDrainReductionPercent))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf
    
    ; The item with this effect should have already modified our actor value, so we can just change the settings again
    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_JetpackDrainReductionPercent))
    UnregisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    float expectedDrainValue = AdjustedDrainValue(Game.GetPlayer().GetValue(PATTP_AV_JetpackDrainReductionPercent))
    if Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) == expectedDrainValue
        debug.trace("Jetpack drain is already set to the correct value: " + expectedDrainValue)
        return
    endif
    
    ; If the game setting doesn't match what we set it to when the game was saved, it changed in the game files
    debug.trace("Setting default jetpack AP drain to " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
    PATTP_Cache_DefaultJetpackAPDrain.SetValue(Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))

    ChangeJetpackSettings(Game.GetPlayer().GetValue(PATTP_AV_JetpackDrainReductionPercent))
EndEvent

Function ChangeJetpackSettings(float afPercentReduction)
    float newValue = AdjustedDrainValue(afPercentReduction)
    
    Game.SetGameSettingFloat(JetpackInitialDrainSettingName, newValue)
    Game.SetGameSettingFloat(JetpackSustainedDrainSettingName, newValue)
    debug.trace("Jetpack drain settings are now " + Game.GetGameSettingFloat(JetpackInitialDrainSettingName) + " initial, " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) + " sustained")
EndFunction

float Function AdjustedDrainValue(float afPercentReduction)
    float TotalDrainReduction = Math.Min(afPercentReduction, 90)
    debug.trace("Jetpack AP drain should be lowered by " + TotalDrainReduction + "%")
    return PATTP_Cache_DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100))
EndFunction