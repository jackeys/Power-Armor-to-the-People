Scriptname PAttP:UpgradeManager extends Quest
{Checks to see if an upgrade occurred to notify other systems that might care}

int Property Version = 0 Auto Const
{Used to detect if a change has been made that requires refreshing the injection lists across releases}

Quest Property MQ101 Auto Const Mandatory
{AUTOFILL
Initial quest, used to determine if the mod has been installed mid-game or not}

Actor[] Property ActorsToResetWhenInstalledMidgame_1 Auto Const
{Actors that need to be reset due to template changes that make them appear naked and/or without names - this only applies to actors that will never respawn by passing time in an interior cell (the Forged)}

int lastVersion

CustomEvent VersionChanged

Event OnQuestInit()
    lastVersion = Version
    RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")

    if IsGameInProgress()
        debug.trace(self + " detected that the mod was installed mid-game")
        ResetActors(ActorsToResetWhenInstalledMidgame_1)
        FixPossiblyNullForgedActors()
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
        FixPossiblyNullForgedActors()
    EndIf
EndFunction

bool Function IsGameInProgress()
    return MQ101.IsCompleted()
EndFunction

Function ResetActors(Actor[] akActors)
    debug.trace(self + " is going to reset any living actors from this list: " + akActors)

    int i = 0
    while i < akActors.length
        ResetActor(akActors[i])
        i += 1
    EndWhile
EndFunction

Function ResetActor(Actor akActor)
    if !akActor.IsDead()
        debug.trace(self + " is resetting " + akActor)
        akActor.Reset()
    EndIf
EndFunction

; This is an ugly hack to make sure the Forged all get reset - three of them might not be loaded, but can still be stored somewhere with incorrect templates
Function FixPossiblyNullForgedActors()
    ; This is from the Creation Club, so it's either there or not - if the creation isn't present, it will work if it comes later, so we just need one check
    Actor forgedKeeper = Game.GetFormFromFile(0xFCA, "ccbgsfo4116-heavyflamer.esl") as Actor
    if forgedKeeper
        ResetActor(forgedKeeper)
    EndIf
    
    ; If the Forged actors are not present, listen for location changes until we find them
    if !ResetPossiblyNullForgedActorsIfPresent()
        debug.trace(self + " is registering for player location changes to reset Forged NPCs")
        RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    EndIf
EndFunction

; Both of these actors are in the same place, so both should be loaded at the same time
bool Function ResetPossiblyNullForgedActorsIfPresent()
    Actor forged1 = Game.GetFormFromFile(0x2A504, "Fallout4.esm") as Actor
    if forged1
        ResetActor(forged1)
    endif
    
    Actor forged2 = Game.GetFormFromFile(0x2A509, "Fallout4.esm") as Actor
    if forged2
        ResetActor(forged2)
    endif
    
    return forged1 || forged2
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    ; Check if the Forged are nearby, and if they are, we can stop listening for location changes after the reset
    If ResetPossiblyNullForgedActorsIfPresent()
        debug.trace(self + " reset Forged NPCs after changing locations - unregistering for location changes")
        UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    EndIf
EndEvent