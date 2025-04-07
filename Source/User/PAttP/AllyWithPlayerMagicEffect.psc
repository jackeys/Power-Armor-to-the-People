Scriptname PATTP:AllyWithPlayerMagicEffect extends ActiveMagicEffect

actor victimActor 
actorValue property Assistance auto mandatory
actorValue property Morality auto mandatory
keyword property TeammateDontUseAmmoKeyword auto mandatory
int startingAssistance
int startingAggression
int startingConfidence
int startingMorality

Event OnEffectStart(Actor akTarget, Actor akCaster)
		victimActor = akTarget
		;Store everything we will change
		startingAssistance = akTarget.GetValue(Assistance) as int
		startingConfidence = akTarget.GetValue(Game.GetConfidenceAV()) as int
		startingAggression = akTarget.GetValue(Game.GetAggressionAV()) as int
		startingMorality = akTarget.GetValue(Morality) as int

		;Make victim unaggressive
		akTarget.SetValue(Game.GetAggressionAV(), 0)	
		akTarget.SetValue(Assistance, 0)	
		akTarget.enableAI(False)
		akTarget.stopCombat()
		akTarget.enableAI()

		;Make them our friend
		victimActor.setplayerTeammate(true)
		victimActor.AddKeyword(TeammateDontUseAmmoKeyword)
		akTarget.SetValue(Morality, 0)

		;Now make them aggressive again
		akTarget.SetValue(Game.GetAggressionAV(), 2)	
		victimActor.EvaluatePackage()

        debug.trace(victimActor + " is now allied with the player")
EndEvent

Event onEffectFinish(Actor akTarget, Actor akCaster)
		akTarget.SetValue(Game.GetAggressionAV(), startingAggression)
		akTarget.SetValue(Game.GetConfidenceAV(), startingConfidence)
		akTarget.SetValue(Assistance, startingAssistance)
		akTarget.SetValue(Morality, startingMorality)
		victimActor.setplayerTeammate(false)
		victimActor.RemoveKeyword(TeammateDontUseAmmoKeyword)
        debug.trace(victimActor + " is no longer allied with the player")
endEvent