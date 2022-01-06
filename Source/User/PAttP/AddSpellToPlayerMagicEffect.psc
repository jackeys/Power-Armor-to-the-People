Scriptname PAttP:AddSpellToPlayerMagicEffect extends ActiveMagicEffect const
{Has a chance of applying a spell to the target of an attack}

Spell Property SpellToApply Auto Const Mandatory
{The spell that should be applied to the target of the attack}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	debug.trace(self + " Applying spell " + SpellToApply + " to the player after being cast on " + akTarget)
	SpellToApply.Cast(Game.GetPlayer(), Game.GetPlayer())
EndEvent
