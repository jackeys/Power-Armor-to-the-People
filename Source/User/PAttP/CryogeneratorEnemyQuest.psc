Scriptname PAttP:CryogeneratorEnemyQuest extends Quest

ReferenceAlias Property SpawnLocation Auto Const
ReferenceAlias Property WinterSoldier Auto Const
ActorBase Property Enemy Auto Const
int Property EnemyKilledStage = 20 Auto Const
int Property FindEnemyObjective = 10 Auto Const

struct Point
    float x
    float y
    float z
EndStruct

; Destination has a position of -1412.6014, -2131.7263, 14.9896
; Therefore, desired offset is -1348.6014, -1843.7263, 86.9896
Point Property SpawnOffset Auto Const

Event OnQuestInit()
    ; Spawn the enemy in the appropriate position
    ObjectReference spawnedEnemy = SpawnLocation.GetRef().PlaceAtMe(Enemy)
    spawnedEnemy.MoveTo(SpawnLocation.GetRef(), SpawnOffset.x, SpawnOffset.y, SpawnOffset.z)
    WinterSoldier.ForceRefTo(spawnedEnemy)
    RegisterForRemoteEvent(spawnedEnemy as Actor, "OnDeath")
    SetObjectiveDisplayed(FindEnemyObjective, true)
EndEvent

Event Actor.OnDeath(Actor akDeceased, Actor akKiller)
    SetStage(EnemyKilledStage)
EndEvent