Scriptname PAttP:DetectAndInjectItems extends PAttP:InjectionQuest
{Finds Creation Club content and injects it to the legendaries lists}


; Keep these as separate properties instead of a struct so the Enabled properties can be set by MCM

; CREATION CLUB

Bool Property TeslaCannonEnabled = false Auto
LeveledItem[] Property TeslaCannonInjectionPoints Auto Mandatory Const
int Property TeslaCannonLevel Auto Mandatory Const

Bool  Property HeavyIncineratorEnabled = false Auto
LeveledItem[] Property HeavyIncineratorInjectionPoints Auto Mandatory Const
int Property HeavyIncineratorLevel Auto Mandatory Const

Bool  Property SolarCannonEnabled = false Auto
LeveledItem[] Property SolarCannonInjectionPoints Auto Mandatory Const
int Property SolarCannonLevel Auto Mandatory Const

Bool  Property CosmicCannonEnabled = false Auto
LeveledItem[] Property CosmicCannonInjectionPoints Auto Mandatory Const
int Property CosmicCannonLevel Auto Mandatory Const

Bool  Property ThunderboltEnabled = false Auto
LeveledItem[] Property ThunderboltInjectionPoints Auto Mandatory Const
int Property ThunderboltLevel Auto Mandatory Const

; UNIQUE WEAPONS

Bool  Property BroadsiderEnabled = false Auto
LeveledItem[] Property BroadsiderInjectionPoints Auto Mandatory Const
int Property BroadsiderLevel Auto Mandatory Const

Bool  Property CryolatorEnabled = false Auto
LeveledItem[] Property CryolatorInjectionPoints Auto Mandatory Const
int Property CryolatorLevel Auto Mandatory Const

; MOD WEAPONS

Bool  Property UltraciteEnabled = false Auto
LeveledItem[] Property UltraciteLaserAutoInjectionPoints Auto Mandatory Const
int Property UltraciteLaserAutoLevel Auto Mandatory Const
LeveledItem[] Property UltraciteLaserSemiAutoInjectionPoints Auto Mandatory Const
int Property UltraciteLaserSemiAutoLevel Auto Mandatory Const
LeveledItem[] Property UltraciteGatlingInjectionPoints Auto Mandatory Const
int Property UltraciteGatlingLevel Auto Mandatory Const

Bool  Property TeslaHeavyAutocannonEnabled = false Auto
LeveledItem[] Property TeslaHeavyAutocannonInjectionPoints Auto Mandatory Const
int Property TeslaHeavyAutocannonLevel Auto Mandatory Const

Bool  Property MinigunsRebirthEnabled = false Auto
LeveledItem[] Property MinigunsRebirthInjectionPoints Auto Mandatory Const
int Property MinigunsRebirthLevel Auto Mandatory Const

Bool  Property MachinegunsRebirthEnabled = false Auto
LeveledItem[] Property MachinegunsRebirthInjectionPoints Auto Mandatory Const
int Property MachinegunsRebirthLevel Auto Mandatory Const

Bool  Property HeavySelectShotgunEnabled = false Auto
LeveledItem[] Property HeavySelectShotgunInjectionPoints Auto Mandatory Const
int Property HeavySelectShotgunLevel Auto Mandatory Const

Bool  Property ArcWelderEnabled = false Auto
LeveledItem[] Property ArcWelderInjectionPoints Auto Mandatory Const
int Property ArcWelderLevel Auto Mandatory Const

Bool  Property EnclavePlasmaEnabled = false Auto
LeveledItem[] Property EnclavePlasmaInjectionPoints Auto Mandatory Const
int Property EnclavePlasmaLevel Auto Mandatory Const

Bool  Property Mk41GyrojetEnabled = false Auto
LeveledItem[] Property Mk41GyrojetInjectionPoints Auto Mandatory Const
int Property Mk41GyrojetLevel Auto Mandatory Const

Bool  Property InstituteHeavyAssaultLaserEnabled = false Auto
LeveledItem[] Property InstituteHeavyAssaultLaserInjectionPoints Auto Mandatory Const
int Property InstituteHeavyAssaultLaserLevel Auto Mandatory Const

; Tesla enemy injections
LeveledItem[] Property EnergyHeavyWeaponInjectionPoints Auto Mandatory Const
LeveledItem[] Property EnergyRifleInjectionPoints Auto Mandatory Const
; For use when only a raw weapon is available to provide instantiation filters
LeveledItem[] Property EnergyRifleWrappers Auto Mandatory Const

Function Inject()
	; Insert all of the enabled weapons for plugins that have been detected
	if TeslaCannonEnabled
		InjectIfPluginPresent(0x0000001E, "ccbgsfo4046-tescan.esl", TeslaCannonInjectionPoints, TeslaCannonLevel)
	endif
	
	if SolarCannonEnabled
		InjectIfPluginPresent(0x000008D5, "ccsbjfo4001-solarflare.esl", SolarCannonInjectionPoints, SolarCannonLevel)
	endif
	
	if HeavyIncineratorEnabled
		InjectIfPluginPresent(0x0000082B, "ccbgsfo4116-heavyflamer.esl", HeavyIncineratorInjectionPoints, HeavyIncineratorLevel)
	endif
	
	if CosmicCannonEnabled
		InjectIfPluginPresent(0x00000C45, "ccswkfo4001-astronautpowerarmor.esm", CosmicCannonInjectionPoints, CosmicCannonLevel)
	endif
	
	if ThunderboltEnabled
		InjectIfPluginPresent(0x00000872, "ccbgsfo4047-qthund.esl", ThunderboltInjectionPoints, ThunderboltLevel)
	endif
	
	if BroadsiderEnabled
		InjectIfPluginPresent(0x00188A6E, "Fallout4.esm", BroadsiderInjectionPoints, BroadsiderLevel)
	endif

	if CryolatorEnabled
		InjectIfPluginPresent(0x00188A70, "Fallout4.esm", CryolatorInjectionPoints, CryolatorLevel)
	endif

	if UltraciteEnabled
		InjectIfPluginPresent(0x00000806, "Power Armor to the People - Ultracite Power Armor.esp", UltraciteLaserAutoInjectionPoints, UltraciteLaserAutoLevel)
		InjectIfPluginPresent(0x0000081F, "Power Armor to the People - Ultracite Power Armor.esp", UltraciteLaserSemiAutoInjectionPoints, UltraciteLaserSemiAutoLevel)
		InjectIfPluginPresent(0x00000820, "Power Armor to the People - Ultracite Power Armor.esp", UltraciteGatlingInjectionPoints, UltraciteGatlingLevel)
	endif
	
	if TeslaHeavyAutocannonEnabled
		InjectIfPluginPresent(0x00000FBB, "TeslaHeavyGun.esl", TeslaHeavyAutocannonInjectionPoints, TeslaHeavyAutocannonLevel)
	EndIf
	
	if MinigunsRebirthEnabled
		InjectIfPluginPresent(0x0000006A, "Skb-MinigunsRebirth.esl", MinigunsRebirthInjectionPoints, MinigunsRebirthLevel)
	EndIf
	
	if MachinegunsRebirthEnabled
		InjectIfPluginPresent(0x00000196, "Skb-MachinegunsRebirth.esl", MachinegunsRebirthInjectionPoints, MachinegunsRebirthLevel)
	EndIf
	
	if HeavySelectShotgunEnabled
		InjectIfPluginPresent(0x0000002C, "HeavySelectShotgun.esl", HeavySelectShotgunInjectionPoints, HeavySelectShotgunLevel)
	EndIf
	
	if ArcWelderEnabled
		InjectIfPluginPresent(0x00003D5C, "ArcWelder.esp", ArcWelderInjectionPoints, ArcWelderLevel)
	EndIf
	
	if EnclavePlasmaEnabled
		; Auto Rifle
		InjectIfPluginPresent(0x0000084A, "EnclavePlasma.esp", EnclavePlasmaInjectionPoints, EnclavePlasmaLevel)
		; Flamer Rifle
		InjectIfPluginPresent(0x0000084B, "EnclavePlasma.esp", EnclavePlasmaInjectionPoints, EnclavePlasmaLevel)
		; Shotgun
		InjectIfPluginPresent(0x0000084F, "EnclavePlasma.esp", EnclavePlasmaInjectionPoints, EnclavePlasmaLevel)
		; Sniper Rifle
		InjectIfPluginPresent(0x00000850, "EnclavePlasma.esp", EnclavePlasmaInjectionPoints, EnclavePlasmaLevel)
	EndIf
	
	if Mk41GyrojetEnabled
		InjectIfPluginPresent(0x00000F99, "Mk41GyrojetHMG.esp", Mk41GyrojetInjectionPoints, Mk41GyrojetLevel)
	EndIf

	if InstituteHeavyAssaultLaserEnabled
		InjectIfPluginPresent(0x00000F9A, "InstituteHeavyAssaultLaser.esp", InstituteHeavyAssaultLaserInjectionPoints, InstituteHeavyAssaultLaserLevel)
		InjectIfPluginPresent(0x00000F9A, "InstituteHeavyAssaultLaserMu.esp", InstituteHeavyAssaultLaserInjectionPoints, InstituteHeavyAssaultLaserLevel)
	EndIf
	
	; Tesla - Energy weapons that are injected for everyone by their own mod, but will be missing because Tesla enemies have their own weapon list
	; Plasma Caster
	InjectIfPluginPresent(0x00001EF6, "WinchesterP94Balanced2.esp", EnergyHeavyWeaponInjectionPoints, 36)
	InjectIfPluginPresent(0x00000F99, "Moddable Plasma Caster.esp", EnergyHeavyWeaponInjectionPoints, 60)
	InjectIfPluginPresent(0x00004C7B, "P94PlasmaRifle.esp", EnergyRifleInjectionPoints, 21)
	
	; This is a raw weapon, so we want to inject it into the rifle wrappers to make sure we only get rifles
	if InjectIfPluginPresent(0x00000F99, "WattzLaserGun.esp", EnergyRifleWrappers, 18)
		debug.trace(self + " detected Wattz Laser Gun, injecting energy rifle wrappers into energy rifle lists")
		InjectLeveledItems(EnergyRifleWrappers, EnergyRifleInjectionPoints, 18)
	EndIf
EndFunction

bool Function InjectIfPluginPresent(int aiFormIdToInject, string asPlugin, LeveledItem[] akInjectInto, int aiLevel)
	Form itemToInject = Game.GetFormFromFile(aiFormIdToInject, asPlugin)

	bool itemAvailable = itemToInject != None
    if itemAvailable
		int i = 0
		while i < akInjectInto.length
			LeveledItem injectInto = akInjectInto[i]
			debug.trace(self + " injecting " + itemToInject + " from plugin " + asPlugin + " into " + injectInto)
			InjectIntoList(injectInto, itemToInject, aiLevel)
			i += 1
		EndWhile
	else
		debug.trace(self + " unable to find form ID " + aiFormIdToInject + " in plugin " + asPlugin)
	endif

	return itemAvailable
EndFunction

Function InjectLeveledItems(LeveledItem[] akToInject, LeveledItem[] akInjectInto, int aiLevel)
	int i = 0
	while i < akToInject.length
		Form itemToInject = akToInject[i]
		int j = 0
		while j < akInjectInto.length
			LeveledItem injectInto = akInjectInto[j]
			InjectIntoList(injectInto, itemToInject, aiLevel)
			j += 1
		EndWhile
		i += 1
	EndWhile
EndFunction