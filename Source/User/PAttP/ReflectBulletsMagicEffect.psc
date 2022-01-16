Scriptname PAttP:ReflectBulletsMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

float Property SpellChance = 100.0 Auto Const
{The chance that the spell will be added when the target is hit - unused if SpellChanceAV is provided}

ActorValue Property SpellChanceAV Auto Const
{An actor value that governs the chance that the spell will be added when the target is hit - overrides SpellChance if provided}

float Property AutomaticWeaponChanceModifier = 1.0 Auto Const
{Multiplier for spell chance if the weapon is an automatic weapon}

FormList Property AutomaticWeaponKeywords Auto Const Mandatory
{AUTOFILL}

FormList Property IncludedWeaponKeywords Auto Const
{A weapon must have a keyword from this list for its hit to add the spell. If excluded, all weapons are valid unless they are on the ExcludedWeaponKeywords list}

FormList Property ExcludedWeaponKeywords Auto Const
{A weapon cannot have a keyword from this list for its hit to add the spell}

struct ImpactMapping
	Keyword WeaponType
	ImpactDataSet ImpactType
EndStruct

ImpactMapping[] Property ImpactMappings Auto Const
ImpactDataSet Property DefaultImpact Auto Const
string Property ImpactNode = "" Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForHitEvent(akTarget)
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	Weapon sourceWeapon = akSource as Weapon
	Actor targetActor = akTarget as Actor
	if akProjectile && sourceWeapon && targetActor && WeaponShouldBeIncluded(sourceWeapon) && Utility.RandomFloat(0, 100) <= GetSpellChance(akTarget, sourceWeapon)
		ObjectReference spellTarget = akAggressor
		
		debug.trace(targetActor + " was hit, adding spell " + SpellToApply + " to " + spellTarget)
		SpellToApply.Cast(akTarget, spellTarget)
		PlayImpactByKeywords(akSource, spellTarget)
	endIf
	
	RegisterForHitEvent(akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnregisterForHitEvent(akTarget)
EndEvent

Function PlayImpactByKeywords(Form akSource, ObjectReference akTarget)
	; Play the first impact we find in the list with a matching keyword
	int i = 0
	while i < ImpactMappings.Length
		ImpactMapping mapping = ImpactMappings[i]
		if akSource.HasKeyword(mapping.WeaponType)
			debug.trace(self + " is playing impact " + mapping.ImpactType + " on node " + ImpactNode + " because damage source " + akSource + " has keyword " + mapping.WeaponType)
			akTarget.PlayImpactEffect(mapping.ImpactType, ImpactNode, Utility.RandomFloat(-0.8, 0.8), Utility.RandomFloat(-0.75, 0.75), -1, 320, false, true)
			return
		EndIf
		i += 1
	EndWhile

	if DefaultImpact
		debug.trace(self + " is playing default impact " + DefaultImpact + " on node " + ImpactNode + " because damage source " + akSource + " has no keywords with mappings")
		akTarget.PlayImpactEffect(DefaultImpact, ImpactNode)
	EndIf
EndFunction

float Function GetSpellChance(ObjectReference akTarget, Weapon akSourceWeapon)
	float adjustedSpellChance
	
	if SpellChanceAV
		adjustedSpellChance = akTarget.GetValue(SpellChanceAV)
	else
		adjustedSpellChance = SpellChance
	EndIf

	if akSourceWeapon.HasKeywordInFormList(AutomaticWeaponKeywords)
		adjustedSpellChance *= AutomaticWeaponChanceModifier
	EndIf

	return adjustedSpellChance
EndFunction

bool Function WeaponShouldBeIncluded(Weapon akWeapon)
	return (!IncludedWeaponKeywords || akWeapon.HasKeywordInFormList(IncludedWeaponKeywords)) && (!ExcludedWeaponKeywords || !akWeapon.HasKeywordInFormList(ExcludedWeaponKeywords))
EndFunction
