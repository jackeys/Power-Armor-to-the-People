Scriptname PAttP:ChangeJetpackSettingsMagicEffect extends ActiveMagicEffect
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

ActorValue Property PATTP_AV_JetpackDrainReductionPercent Auto Const Mandatory
{AUTOFILL}

GlobalVariable Property PATTP_Setting_DefaultJetpackAPDrain Auto Const Mandatory
{AUTOFILL}

string JetpackInitialDrainSettingName = "fJetpackDrainInital"
string JetpackSustainedDrainSettingName = "fJetpackDrainSustained"

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf

    ; If we have never set the original AP drain before, we should do so now so we know how to restore it
    if PATTP_Setting_DefaultJetpackAPDrain.GetValue() == 0.0
        debug.trace("Setting default jetpack AP drain to " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
        PATTP_Setting_DefaultJetpackAPDrain.SetValue(Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
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
    ; When we load the game, the game settings match what is in the game files, not the saved game
    ; We can listen here to apply any changes that may have happened from other mods being installed
    debug.trace("Setting default jetpack AP drain to " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))
    PATTP_Setting_DefaultJetpackAPDrain.SetValue(Game.GetGameSettingFloat(JetpackSustainedDrainSettingName))

    ChangeJetpackSettings(Game.GetPlayer().GetValue(PATTP_AV_JetpackDrainReductionPercent))
EndEvent

Function ChangeJetpackSettings(float afPercentReduction)
    float TotalDrainReduction = Math.Min(afPercentReduction, 90)
    debug.trace("Reducing jetpack AP drain by " + TotalDrainReduction + "%")
    
    ; The typo is in the actual game setting, not this script
    Game.SetGameSettingFloat(JetpackInitialDrainSettingName, PATTP_Setting_DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100)))
    Game.SetGameSettingFloat(JetpackSustainedDrainSettingName, PATTP_Setting_DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100)))
    debug.trace("Jetpack settings are now " + Game.GetGameSettingFloat(JetpackInitialDrainSettingName) + " initial, " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) + " sustained")
EndFunction