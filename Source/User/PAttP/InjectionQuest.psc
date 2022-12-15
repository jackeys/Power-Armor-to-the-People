Scriptname PAttP:InjectionQuest extends Quest const
{Base script for Power Armor to the People injections. Extend this script, overriding Inject() with a function that calls InjectIntoList() for each injection it needs to perform.}

PAttP:InjectionManager Property injectionManager Auto Const Mandatory
{Autofill}

GlobalVariable Property ShouldInject Auto Const
{If provided, the value held by this variable is greater than 0, the provided injections will all take place - otherwise, they will be skipped}

Bool Property InvertShouldInject = false Auto Const
{If true, and ShouldInject is provided, consider a 0 in ShouldInject to be true and a non-zero to be false (logical NOT)}

GlobalVariable Property Enabled Auto Const
{For use with MCM - if provided, this must be greater than 0 for the injection to take place. If ShouldInject is also provided, both must be true (logical AND)}

Event OnQuestInit()
    RegisterCustomEvents()
    InjectIfEnabled()
EndEvent

Function InjectIntoList(LeveledItem akInjectInto, Form akItemToInject, int aiLevel, int aiCount = 1)
    ; Register here so that if we inject into new lists in an update they are captured
    injectionManager.RegisterInjection(akInjectInto)

    if injectionManager.ShouldIgnoreLevelFor(akInjectInto)
        debug.trace(self + " injecting " + akItemToInject + " into " + akInjectInto + " at level 1 (ignoring level of " + aiLevel + ")")
        aiLevel = 1
    else
        debug.trace(self + " injecting " + akItemToInject + " into " + akInjectInto + " at level " + aiLevel)
    EndIf

    akInjectInto.AddForm(akItemToInject, aiLevel, aiCount)
EndFunction

Function InjectIfEnabled()
    ; If ShouldInject was omitted, we always inject
	if (Enabled == None || Enabled.GetValueInt() > 0) && (ShouldInject == None || (!InvertShouldInject && ShouldInject.GetValueInt() > 0) || (InvertShouldInject && ShouldInject.GetValueInt() == 0))
		debug.trace("Beginning injection " + Self)
        Inject()
	else
        debug.trace("Skipping injection " + Self)
	endif
EndFunction

; Needs to be overridden
Function Inject()
    debug.trace(self + " is missing an override for the Inject() function")
EndFunction

Function RegisterCustomEvents()
    debug.trace("Registering " + Self + " for Power Armor to the People injection refreshes")
    RegisterForCustomEvent(injectionManager, "RefreshInjection")
EndFunction

Event PAttP:InjectionManager.RefreshInjection(PAttP:InjectionManager akSender, Var[] akArgs)
    if akSender != injectionManager
        debug.trace(self + " received unexpected refresh injection event from " + akSender)
        return
    EndIf

    InjectIfEnabled()
EndEvent