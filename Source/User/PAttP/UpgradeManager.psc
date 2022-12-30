Scriptname PAttP:UpgradeManager extends Quest
{Checks to see if an upgrade occurred to notify other systems that might care}

int Property Version = 0 Auto Const
{Used to detect if a change has been made that requires refreshing the injection lists across releases}

Quest Property MQ101 Auto Const Mandatory
{AUTOFILL
Initial quest, used to determine if the mod has been installed mid-game or not}

PAttP:CustomLegendaryRulesQuest Property PATTP_LegendaryRulesManager const auto mandatory
{Autofill}

Actor[] Property ActorsToResetWhenInstalledMidgame_1 Auto Const
{Actors that need to be reset due to template changes that make them appear naked and/or without names - this only applies to actors that will never respawn by passing time in an interior cell (the Forged)}

LegendaryItemQuestScript:LegendaryModRule[] Property LegendaryModsRulesToRemove_2 auto const
{Legendary rules that will be removed from the legendary item quest when upgrading to version 2 - must be an exact match}

GlobalVariable Property PATTP_Setting_T60ForGunners_OBSOLETE Auto Const
{AUTOFILL}
GlobalVariable Property PATTP_Setting_T60ForRaiders_OBSOLETE Auto Const
{AUTOFILL}
GlobalVariable Property PATTP_Setting_T60ExclusiveToBoS Auto Const
{AUTOFILL}
GlobalVariable Property PAttP_Setting_LevelScalePowerArmorEnemyChance Auto Const Mandatory
{AUTOFILL}
GlobalVariable Property PAttP_Setting_LevelScalePowerArmorBossEnemyChance Auto Const Mandatory
{AUTOFILL}
GlobalVariable Property PAttP_Setting_LevelScalePowerArmorLegendaryEnemyChance Auto Const Mandatory
{AUTOFILL}

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
    EndIf
EndEvent

Function PerformUpgrade()
    debug.trace(self + " performing upgrade from version " + lastVersion + " to version " + Version)
    
    If Version >= 1 && lastVersion < 1
        UpgradeToVersion1()
    EndIf
    If Version >= 2 && lastVersion < 2
        UpgradeToVersion2()
    EndIf
    
    Var[] args = new Var[2]
    args[0] = lastVersion
    args[1] = Version
    SendCustomEvent("VersionChanged", args)
    
    lastVersion = Version
EndFunction

Function UpgradeToVersion1()
    debug.trace(self + " is upgrading to version 1")
    debug.trace(self + " is resetting The Forged")
    ResetActors(ActorsToResetWhenInstalledMidgame_1)
    FixPossiblyNullForgedActors()
    
    ; If T-60 was removed from Gunners or Raiders, the closest parallel is to make T-60 exclusive to the BoS
    if PATTP_Setting_T60ForGunners_OBSOLETE.value == 0 || PATTP_Setting_T60ForRaiders_OBSOLETE.value == 0
        debug.trace(self + " is making T-60 exclusive to the Brotherhood of Steel based on previous settings")
        PATTP_Setting_T60ExclusiveToBoS.value = 1
    endif
EndFunction

Function UpgradeToVersion2()
    debug.trace(self + " is upgrading to version 2")
    
    ; This used to be a ChanceNone, so to preserve the settings, invert (e.g. 0 becomes 100, 100 becomes 0)
    debug.trace(self + " is inverting level scaling ChanceNones to Chances")
    PAttP_Setting_LevelScalePowerArmorEnemyChance.value = 100 - PAttP_Setting_LevelScalePowerArmorEnemyChance.value
    PAttP_Setting_LevelScalePowerArmorBossEnemyChance.value = 100 - PAttP_Setting_LevelScalePowerArmorBossEnemyChance.value
    PAttP_Setting_LevelScalePowerArmorLegendaryEnemyChance.value = 100 - PAttP_Setting_LevelScalePowerArmorLegendaryEnemyChance.value

    debug.trace(self + " is removing old legendary rules")
    RemoveLegendaryRules(LegendaryModsRulesToRemove_2)

    ; We changed back to individual settings for each faction, so if the default is not being used, change it to preserve the user's setting
    if PATTP_Setting_T60ExclusiveToBoS.value == 1
        debug.trace(self + " is making T-60 unavailable to Gunners and Raiders based on previous settings")
        PATTP_Setting_T60ForGunners_OBSOLETE.value = 0
        PATTP_Setting_T60ForRaiders_OBSOLETE.value = 0
    endif
EndFunction

Function UpgradeToVersion4()
    debug.trace(self + " is upgrading to version 4")
    
    PAttP:RegisterUniqueItems registrationQuest = Game.GetFormFromFile(0x0000083B, "Power Armor to the People - Enclave X-02.esp") as PAttP:RegisterUniqueItems
    
    if registrationQuest
        debug.trace(self + " is registering new X-02 unique item")
        registrationQuest.RegisterUniques()
    endIf
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

Function RemoveLegendaryRules(LegendaryItemQuestScript:LegendaryModRule[] aaRules)
    int i = 0
    while i < aaRules.Length
        PATTP_LegendaryRulesManager.UpdateModRule("Rule Removed By Upgrade", false, aaRules[i])
        i += 1
    EndWhile
EndFunction