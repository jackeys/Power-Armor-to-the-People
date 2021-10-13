Scriptname PAttP:UpgradeManager extends Quest
{Checks to see if an upgrade occurred to notify other systems that might care}

int Property Version = 0 Auto Const
{Used to detect if a change has been made that requires refreshing the injection lists across releases}

Quest Property MQ101 Auto Const Mandatory
{AUTOFILL
Initial quest, used to determine if the mod has been installed mid-game or not}

Actor[] Property ActorsToResetWhenInstalledMidgame_1 Auto Const

int lastVersion

CustomEvent VersionChanged

Event OnQuestInit()
    lastVersion = Version
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")

    if IsGameInProgress()
        debug.trace(self + " detected that the mod was installed mid-game")
        ResetActors(ActorsToResetWhenInstalledMidgame_1)
    EndIf
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
    debug.trace(self + " is checking if a version change occurred (last version = " + lastVersion + ", current version = " + Version + ")")
    If lastVersion != Version
        PerformUpgrade()
        lastVersion = Version
    EndIf
EndEvent

Function PerformUpgrade()
    debug.trace(self + " performing upgrade from version " + lastVersion + " to version " + Version)
    Var[] args = new Var[2]
    args[0] = lastVersion
    args[1] = Version
    SendCustomEvent("VersionChanged", args)
    
    If Version >= 1 && lastVersion < 1
        debug.trace(self + " is resetting actors for version 1")
        ResetActors(ActorsToResetWhenInstalledMidgame_1)
    EndIf
EndFunction

bool Function IsGameInProgress()
    return MQ101.IsCompleted()
EndFunction

Function ResetActors(Actor[] akActors)
    debug.trace(self + " is going to reset any living actors from this list: " + akActors)

    int i = 0
    while i < akActors.length
        Actor currentActor = akActors[i]
        if !currentActor.IsDead()
            debug.trace(self + " is resetting " + currentActor)
            currentActor.Reset()
        EndIf
        i += 1
    EndWhile
EndFunction