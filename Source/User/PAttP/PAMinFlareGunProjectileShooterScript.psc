Scriptname PAttP:PAMinFlareGunProjectileShooterScript extends ObjectReference Const
{Used to fire a flare automatically from the player by putting it on an activator}

Weapon Property MinFlareWeapon Auto Const

float startingHeight = 0.0 Const

Event onLoad()
	Debug.Trace(self + ": Has called OnLoad")
	; Fire straight up
	Self.SetPosition(afX=GetPositionX(), afY=GetPositionY(), afZ = GetPositionZ() + startingHeight)
	MinFlareWeapon.Fire(self)
	utility.wait(3.0)
	delete()
EndEvent
