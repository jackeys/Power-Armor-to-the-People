Scriptname PAttP:ChangeJetpackSettingsMagicEffect extends ActiveMagicEffect
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

ActorValue Property PATTP_AV_PA_LessJetpackDrain Auto Const Mandatory
{AUTOFILL}

float Property DrainReductionPercent = 15.0 Auto Const
{The percentage that jetpack AP drain should be reduced by for every piece that is equipped}

GlobalVariable Property PATTP_Setting_DefaultJetpackAPDrain Auto Const Mandatory

string JetpackInitialDrainSettingName = "fJetpackDrainInital"
string JetpackSustainedDrainSettingName = "fJetpackDrainSustained"

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf

    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_PA_LessJetpackDrain))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    ; This should only apply to the player
    if akTarget != Game.GetPlayer()
        return
    endIf

    ; The item with this effect should have already modified our actor value, so we can just change the settings again
    ChangeJetpackSettings(akTarget.GetValue(PATTP_AV_PA_LessJetpackDrain))
EndEvent

Function ChangeJetpackSettings(float afNumberOfEffectsToApply)
    float TotalDrainReduction = Math.Min(afNumberOfEffectsToApply * DrainReductionPercent, 90)
    debug.trace("Found  " + afNumberOfEffectsToApply + " power armor pieces that reduce jetpack drain, reducing AP drain by " + TotalDrainReduction + "%")
    
    ; The typo is in the actual game setting, not this script
    Game.SetGameSettingFloat(JetpackInitialDrainSettingName, PATTP_Setting_DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100)))
    Game.SetGameSettingFloat(JetpackSustainedDrainSettingName, PATTP_Setting_DefaultJetpackAPDrain.GetValue() * (1 - (TotalDrainReduction / 100)))
    debug.trace("Jetpack settings are now " + Game.GetGameSettingFloat(JetpackInitialDrainSettingName) + " initial, " + Game.GetGameSettingFloat(JetpackSustainedDrainSettingName) + " sustained")
EndFunction