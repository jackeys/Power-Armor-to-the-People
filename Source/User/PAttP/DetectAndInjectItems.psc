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
EndFunction

Function InjectIfPluginPresent(int aiFormIdToInject, string asPlugin, LeveledItem[] akInjectInto, int aiLevel)
	Form itemToInject = Game.GetFormFromFile(aiFormIdToInject, asPlugin)

    if (itemToInject)
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
EndFunction