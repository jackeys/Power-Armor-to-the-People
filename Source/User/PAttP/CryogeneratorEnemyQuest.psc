Scriptname PAttP:CryogeneratorEnemyQuest extends Quest

ReferenceAlias Property SpawnLocation Auto Const
ReferenceAlias Property WinterSoldier Auto Const
ActorBase Property Enemy Auto Const
GlobalVariable Property NoteChanceNone Auto Const
int Property EnemySpawnedStage = 10 Auto Const
int Property EnemyKilledStage = 20 Auto Const
int Property FindEnemyObjective = 10 Auto Const
int Property RequiredPlayerLevel = 32 Auto Const

struct Point
    float x
    float y
    float z
EndStruct

; Destination has a position of -1412.6014, -2131.7263, 14.9896
; Therefore, desired offset is -1348.6014, -1843.7263, 86.9896
Point Property SpawnOffset Auto Const

Event OnQuestInit()
    ; Check for when the player is high enough level
    if !EnableTriggerNoteDropIfHighEnoughLevel()
        debug.trace(self + " Player is not high enough level - waiting to see when they are")
        RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    endIf
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
    if auiStageID == EnemySpawnedStage
        SpawnEnemy()
    endIf
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
    If EnableTriggerNoteDropIfHighEnoughLevel()
        debug.trace(self + " No need to listen to future location changes")
        UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
    EndIf
EndEvent

bool Function EnableTriggerNoteDropIfHighEnoughLevel()
    if Game.GetPlayer().GetLevel() >= RequiredPlayerLevel
        debug.trace(self + " Player is high enough level - enabling note drop")
        NoteChanceNone.SetValue(70)
        return true
    endIf
    
    return false
EndFunction

Function SpawnEnemy()
    debug.trace(self + " spawning enemy")
    ; Spawn the enemy in the appropriate position
    ObjectReference spawnedEnemy = SpawnLocation.GetRef().PlaceAtMe(Enemy)
    spawnedEnemy.MoveTo(SpawnLocation.GetRef(), SpawnOffset.x, SpawnOffset.y, SpawnOffset.z)
    WinterSoldier.ForceRefTo(spawnedEnemy)
    RegisterForRemoteEvent(spawnedEnemy as Actor, "OnDeath")
    SetObjectiveDisplayed(FindEnemyObjective, true)
    NoteChanceNone.SetValue(100)
EndFunction

Event Actor.OnDeath(Actor akDeceased, Actor akKiller)
    SetStage(EnemyKilledStage)
EndEvent