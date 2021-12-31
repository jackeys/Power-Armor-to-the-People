Scriptname PAttP:ChangeJetpackThrustSettingsMagicEffect extends ActiveMagicEffect const
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

ActorValue Property PATTP_AV_JetpackThrustIncreasePercent Auto Const Mandatory
{AUTOFILL}

GlobalVariable Property PATTP_Cache_DefaultJetpackThrust Auto Const Mandatory
{AUTOFILL}

string Property JetpackInitialThrustSettingName = "fJetpackThrustInitial" autoReadOnly Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf

    ; If we have never set the original thrust before, we should do so now so we know how to restore it
    if PATTP_Cache_DefaultJetpackThrust.GetValue() == 0.0
        debug.trace("Setting default jetpack thrust to " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
        PATTP_Cache_DefaultJetpackThrust.SetValue(Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
    endIf
    
    ; The game setting will reset when the game is loaded, so we need to reapply it
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_JetpackThrustIncreasePercent))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf
    
    ; The item with this effect should have already modified our actor value, so we can just change the settings again
    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_JetpackThrustIncreasePercent))
    UnregisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    float expectedThrustValue = AdjustedThrustValue(Game.GetPlayer().GetValue(PATTP_AV_JetpackThrustIncreasePercent))
    if Game.GetGameSettingFloat(JetpackInitialThrustSettingName) == expectedThrustValue
        debug.trace("Jetpack thrust is already set to the correct value: " + expectedThrustValue)
        return
    endif
    
    ; If the game setting doesn't match what we set it to when the game was saved, it changed in the game files
    debug.trace("Setting default jetpack thrust to " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
    PATTP_Cache_DefaultJetpackThrust.SetValue(Game.GetGameSettingFloat(JetpackInitialThrustSettingName))

    ChangeJetpackSettings(Game.GetPlayer().GetValue(PATTP_AV_JetpackThrustIncreasePercent))
EndEvent

Function ChangeJetpackSettings(float afPercentIncrease)
    float newValue = AdjustedThrustValue(afPercentIncrease)
    
    Game.SetGameSettingFloat(JetpackInitialThrustSettingName, newValue)
    debug.trace("Jetpack thrust is now " + Game.GetGameSettingFloat(JetpackInitialThrustSettingName))
EndFunction

float Function AdjustedThrustValue(float afPercentIncrease)
    debug.trace("Jetpack thrust should be increased by " + afPercentIncrease + "%")
    return PATTP_Cache_DefaultJetpackThrust.GetValue() * (1 + (afPercentIncrease / 100))
EndFunction