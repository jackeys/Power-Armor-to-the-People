Scriptname PAttP:ApplyKeywordMagicEffect extends ActiveMagicEffect
{Possibly attaches a legendary mod to a piece of power armor in the object's inventory}

GlobalVariable Property AffectedActorSetting Auto Const Mandatory
{AUTOFILL
Global variable where 0 is disabled, 1 is legendary enemies only, and 2 is all enemies}

int Property SETTING_DISABLED = 0 autoReadOnly hidden
int Property SETTING_LEGENDARY = 1 autoReadOnly hidden
int Property SETTING_ALL = 2 autoReadOnly hidden

Keyword Property EncTypeLegendary Auto Const Mandatory
{AUTOFILL}

Keyword Property KeywordToAdd Auto Const Mandatory
{The keyword that should be added if the enemy type matches the setting}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if AffectedActorSetting.GetValueInt() == SETTING_ALL || AffectedActorSetting.GetValueInt() == SETTING_LEGENDARY && akTarget.HasKeyword(EncTypeLegendary)
		debug.trace(self + "Adding keyword " + KeywordToAdd + " to " + akTarget)
		akTarget.AddKeyword(KeywordToAdd)
	endif
EndEvent
