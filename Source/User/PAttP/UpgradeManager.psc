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
    debug.trace(self + " is checking if a version change occurred")
    If lastVersion != Version
        ; Schedule the upgrade to allow time for any newly added modules to finish injection
        ; This usually only takes 1 second, the player won't notice if it takes minutes to occur, so we'll wait for a longer time just in case
        debug.trace(self + " is scheduling an update for 60 seconds from now")
        StartTimer(60)
    EndIf
EndEvent

Event OnTimer(int aiTimerId)
    PerformUpgrade()
EndEvent

Function PerformUpgrade()
    debug.trace(self + " performing upgrade from version " + lastVersion + " to version " + Version)
    Var[] args = new Var[2]
    args[0] = lastVersion
    args[1] = Version
    SendCustomEvent("VersionChanged", args)
EndFunction