Scriptname PAttP:UpgradeManager extends Quest
{Checks to see if an upgrade occurred to notify other systems that might care}

int Property Version = 0 Auto Const
{Used to detect if a change has been made that requires refreshing the injection lists across releases}

int lastVersion

CustomEvent VersionChanged

Event OnQuestInit()
    lastVersion = Version
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    debug.trace(self + " is checking if a version change occurred (last version = " + lastVersion + ", current version = " + Version + ")")
    If lastVersion != Version
        PerformUpgrade()
    EndIf
EndEvent

Function PerformUpgrade()
    debug.trace(self + " performing upgrade from version " + lastVersion + " to version " + Version)
    Var[] args = new Var[2]
    args[0] = lastVersion
    args[1] = Version
    SendCustomEvent("VersionChanged", args)
EndFunction