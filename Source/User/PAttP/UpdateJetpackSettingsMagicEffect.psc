Scriptname PAttP:UpdateJetpackSettingsMagicEffect extends ActiveMagicEffect const
{Gives the jetpack quest a nudge to update game settings because we changed the actor values related to the jetpack}

PAttP:ChangeJetpackSettingsQuest Property JetpackQuest Auto Const Mandatory

Event OnEffectStart(Actor akTarget, Actor akCaster)
    JetpackQuest.UpdateJetpackSettings()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    JetpackQuest.UpdateJetpackSettings()
EndEvent