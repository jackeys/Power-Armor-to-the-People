Scriptname PAttP:AddPerkToFollowersInPowerArmor extends ActiveMagicEffect const
{Adds a perk to any followers of the player that are in power armor, and sets a global variable indicating if any followers are in power armor}

Perk Property PerkToAdd Auto Const
{The spell given to the followers in power armor, which should have a condition checking that they are in power armor}

float Property IntervalInSeconds Auto Const Mandatory
{The number of real world seconds between each time followers are checked for power armor}

GlobalVariable Property IsFollowerInPowerArmor Auto Const
{Will be set to 1 if any followers have power armor, 0 otherwise}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CheckFollowers()
	StartTimer(IntervalInSeconds)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer()
	RemoveSpellFromFollowers()
EndEvent

Event OnTimer(int aiTimerID)
	if IsBoundGameObjectAvailable()
		CheckFollowers()

		StartTimer(IntervalInSeconds)
	endIf
EndEvent

Function CheckFollowers()
	int i = 0
	bool followerInPowerArmor = false
	Actor[] followers = Game.GetPlayerFollowers()
	while i < followers.length
		if followers[i].IsInPowerArmor()
			debug.trace(self + " found " + followers[i] + " in power armor - adding spell " + PerkToAdd)
			followers[i].AddPerk(PerkToAdd)
			followerInPowerArmor = true
		EndIf
		i += 1
	endWhile

	if followerInPowerArmor
		IsFollowerInPowerArmor.setValue(1)
	else
		IsFollowerInPowerArmor.setValue(0)
	endIf
EndFunction

Function RemoveSpellFromFollowers()
	int i = 0
	Actor[] followers = Game.GetPlayerFollowers()
	while i < followers.Length
		followers[i].RemovePerk(PerkToAdd)
		i += 1
	endWhile

	IsFollowerInPowerArmor.setValue(0)
EndFunction