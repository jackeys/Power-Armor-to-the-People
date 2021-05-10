Scriptname PAttP:LeveledEncounterManager extends Quest

Struct Encounter
    ObjectReference EncounterRef
    {The object that should be enabled when the player reaches the specified level}

    int Level
    {The level at which the reference should be enabled}
EndStruct

Encounter[] PendingLeveledEncounters

Event OnInit()
    PendingLeveledEncounters = new Encounter[0]

    EnableAllEncountersForAppropriateLevel(Game.GetPlayer().GetLevel())

    ; If we still have pending encounters, listen for location changes so we can organically enable them based on player level
    RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
EndEvent

Function EnableAllEncountersForAppropriateLevel(int aiLevel)
    ; Iterate through the list in reverse so we can remove the encounters we enable
    int i = PendingLeveledEncounters.length
    While i >= 0
        Encounter currentEncounter = PendingLeveledEncounters[i]
        if currentEncounter.Level <= aiLevel
            currentEncounter.EncounterRef.Enable()
            PendingLeveledEncounters.Remove(i)
        EndIf
        i += 1
    EndWhile
EndFunction

Function RegisterLeveledEncounter(ObjectReference akRefToEnable, int aiRequiredPlayerLevel)
    Encounter newEncounter = new Encounter
    newEncounter.EncounterRef = akRefToEnable
    newEncounter.Level = aiRequiredPlayerLevel
    PendingLeveledEncounters.Add(newEncounter)
EndFunction

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    EnableAllEncountersForAppropriateLevel(Game.GetPlayer().GetLevel())
EndEvent
