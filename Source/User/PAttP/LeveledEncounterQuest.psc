Scriptname PAttP:LeveledEncounterQuest extends Quest
{Allows for placed enemies and objects to be enabled once the player reaches a certain level. Enabling occurs when the player changes locations.}

Struct Encounter
    ObjectReference EncounterRef
    {The object that should be enabled when the player reaches the specified level}

    int Level
    {The level at which the reference should be enabled}
EndStruct

Encounter[] PendingLeveledEncounters

Encounter[] Property Encounters Auto Const Mandatory
{The list of encounters that should be enabled when their specified levels are reached}

Event OnInit()
    SetAllEncountersToPending()
    EnableAllEncountersForLevel(Game.GetPlayer().GetLevel())

    ; If we still have pending encounters, listen for location changes so we can organically enable them based on player level
    if PendingLeveledEncounters.length > 0
        debug.trace(self + " has pending leveled encounters - registering location change listener")
        RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    EndIf
EndEvent

Function SetAllEncountersToPending()
    PendingLeveledEncounters = new Encounter[Encounters.length]

    ; All of our encounters start as pending encounters
    int i = 0
    While i < Encounters.length
        PendingLeveledEncounters.Add(Encounters[i])
        i += 1
    EndWhile
EndFunction

Function EnableAllEncountersForLevel(int aiLevel)
    ; Iterate through the list in reverse so we can remove the encounters we enable
    int i = PendingLeveledEncounters.length - 1
    While i >= 0
        Encounter currentEncounter = PendingLeveledEncounters[i]
        if currentEncounter.Level <= aiLevel
            debug.trace(self + " enabling encounter at level " + currentEncounter.Level + ": " + currentEncounter.EncounterRef)
            currentEncounter.EncounterRef.Enable()
            PendingLeveledEncounters.Remove(i)
        EndIf
        i -= 1
    EndWhile
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    EnableAllEncountersForLevel(Game.GetPlayer().GetLevel())

    If PendingLeveledEncounters.length == 0
        debug.trace(self + " has enabled all leveled encounters - unregistering location change listener")
        UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    EndIf
EndEvent
