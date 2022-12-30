Scriptname PAttP:WorkshopAttackVigilanteScript extends Quest
{script for workshop attack quests where a vigilante helps}

ReferenceAlias Property WorkshopAlias const auto mandatory

WorkshopParentScript Property WorkshopParent Auto Const mandatory

REParentScript Property REParent Auto mandatory
{REParent quest, used to send cleanup custom event }

RefCollectionAlias Property Attackers Auto Const mandatory
{ attacker aliases }

ReferenceAlias[] Property ExtraAttackMarkers const auto
{ optional additional attack markers to spread out the attack if available }

faction Property AttackerFaction Auto Const mandatory
{ needs to be set in order for settlement to record "last attack" faction/date }

int Property attackStrength auto hidden
{ passed in by starting event - used to determine how many attackers to enable }

int Property numAttackers auto hidden   ; initialized by OnStoryScript - number of attackers to enable when attack starts

int Property attackStartStage = 20 auto const
{ stage which indicates the attack has started }
int Property attackDoneStage = 100 auto const
{ stage which indicates the attack is done - attackers killed }

float Property randomAttackStrengthMin = 0.7 auto
{ 1.0 = no randomization
 set to < 1 and > 0 to give a min % of randomization to the specified attack strength
 e.g. 0.7 = attack strength can vary from 70% to 100%
 }

bool Property NightAttack = false auto const
{ set to TRUE if you want attack to only happen at night }

RefCollectionAlias Property Defenders Auto Const mandatory
{ additional aliases that will help defend the settlement }

int minAttackers = 3

float playerWaitingGameTime = 0.1 const

float attackDelayGameTime = 15.0 const ; fast traveling across the map takes a bit more than 12 hours

bool PlayerIsWaiting = false

Event OnTimerGameTime(int aiTimerID)
    debug.trace(self + "OnTimerGameTime")

    RegisterForPlayerWait()

	if !GetStageDone(attackStartStage)
		; timer has expired without attack actually being triggered
        TryToStartAttack()
	else
		; send cleanup event - will resolve if everything is unloaded
        ; make sure flagged for cleanup on unload
        ((self as Quest) as REScript).StopQuestWhenAliasesUnloaded = true
		REParent.SendCustomEvent("RECheckForCleanup")
	endif
EndEvent

function TryToStartAttack()
    debug.trace(self + " TryToStartAttack")
    if ShouldStartAttack()
        debug.trace(self + " TryToStartAttack: setting attackStartStage=" + attackStartStage)
        CancelTimerGameTime()
        setStage(attackStartStage)
    else
        ; run timer to wait for correct time for attack
        if PlayerIsWaiting
            StartTimerGameTime(playerWaitingGameTime)
        else
            StartTimerGameTime(attackDelayGameTime)
        endif
    endif
endFunction


; called when player enters the area - if right time of day, start attack, otherwise continue to run timer
bool function ShouldStartAttack()
    debug.trace(self + " ShouldStartAttack")
    bool bStartAttack = false
    if NightAttack == false
        bStartAttack = true
    else
        ; otherwise, check time
        float gameHour = WorkshopParent.GameHour.GetValue()
        if gameHour < 4 || gameHour > 22
            bStartAttack = true
        endif
    endif

    debug.trace(self + " ShouldStartAttack " + bStartAttack)

    if PlayerIsWaiting == false
        return bStartAttack
    else
        debug.trace(self + " ShouldStartAttack  - player is waiting - run timer again")
        return false
    endif
endFunction

function StartAttack()
    debug.trace(self + " StartAttack")
    
    UnregisterForPlayerWait()
    
    ; record attack on this workshop
    WorkshopParent.RecordAttack(WorkshopAlias.GetRef() as WorkshopScript, attackerFaction)

    ; find valid extra attack markers
    ObjectReference[] extraMarkerRefs = new ObjectReference[0]
    int i = 0
    while i < ExtraAttackMarkers.Length
        ObjectReference markerRef = ExtraAttackMarkers[i].GetRef()
        if markerRef
            extraMarkerRefs.Add(markerRef)
        endif
        i += 1
    endWhile

    ; enable/kill attackers
    debug.trace(self + "    enabling " + numAttackers + " attackers")
    i = 0
    while i < Attackers.GetCount()
        Actor attacker = Attackers.GetAt(i) as Actor
        if i < numAttackers
            if extraMarkerRefs.Length > 0
                ; roll to randomly move attacker to a different marker
                int markerIndex = utility.RandomInt(0, extraMarkerRefs.Length)
                if markerIndex < extraMarkerRefs.Length
                    attacker.MoveTo(extraMarkerRefs[markerIndex])
                endif
            endif
            attacker.Enable()
        else
            ; kill the rest
            attacker.KillSilent()
        endif
        i += 1
    endWhile

    ; enable all additional defenders
    i = 0
    while i < Defenders.GetCount()
        Actor defender = Defenders.GetAt(i) as Actor
        defender.Enable()
        i += i
    EndWhile

    ; if attack isn't resolved in delay time, resolve offscreen
    StartTimerGameTime(attackDelayGameTime)
endFunction

; check to see if we need to resolve this attack by script
; return TRUE if attackers won
bool function CheckResolveAttack()
    debug.tracestack(self + " CheckResolveAttack")
    WorkshopScript workshopRef = WorkshopAlias.GetRef() as WorkshopScript
	; attackers aren't all dead, so resolve
	if GetStageDone(attackDoneStage) == false && workshopRef.Is3DLoaded() == false
        ; 1.3: 86527: disable attackers if we are resolving attack off screen
        Attackers.DisableAll()
        Defenders.DisableAll()
        ; 1.3: 89559: return ResolveAttack value (TRUE=attackers won)
		return WorkshopParent.ResolveAttack(workshopRef, attackStrength, attackerFaction)
    else
        return false
	endif
endFunction

; calculate attack strength
; attackstrength = 
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
    debug.trace(self + " OnStoryScript: location=" + akLocation + ", attackStrength=" + aiValue1)
    attackStrength = aiValue1
    ; if we didn't get it, calculate it
    if attackStrength == 0
        WorkshopScript workshopRef = WorkshopAlias.GetRef() as WorkshopScript
        attackStrength = WorkshopParent.CalculateAttackStrength(workshopRef.GetTotalFoodRating(WorkshopParent.WorkshopRatings), workshopRef.GetTotalWaterRating(WorkshopParent.WorkshopRatings))
    else
        ; randomization factor
        if randomAttackStrengthMin < 1.0
            int attackStrengthMin = (attackStrength * randomAttackStrengthMin ) as int

            debug.trace("       Base attackStrength=" + attackStrength)
            debug.trace("         attack strength variation=" + attackStrengthMin + " to " + attackStrength)

            attackStrength = attackStrength + utility.randomInt(attackStrengthMin, attackStrength) as int
            debug.trace("       attackStrength=" + attackStrength)
        endif
    endif

    float attackMult = attackStrength as float

    ; simple for now:
    attackMult = attackMult/WorkshopParent.maxAttackStrength
    debug.trace(self + "	attackMult=" + attackMult)

    ; 1.3: 84663: make sure minAttackers isn't > max possible attackers
    if minAttackers > Attackers.GetCount()
        minAttackers = Attackers.GetCount()
    endif
    ; end 84663
    
    numAttackers = minAttackers + math.floor((Attackers.GetCount() - minAttackers)*attackMult)
    debug.trace(self + "	numAttackers=" + numAttackers)

    RegisterForPlayerWait()
EndEvent


Event OnPlayerWaitStart(float afWaitStartTime, float afDesiredWaitEndTime)
    debug.trace(self + " OnPlayerWaitStart")
    PlayerIsWaiting = true
    Attackers.EvaluateAll()
EndEvent

Event OnPlayerWaitStop(bool abInterrupted)
    debug.trace(self + " OnPlayerWaitStop")
    PlayerIsWaiting = false
EndEvent


; add/remove passed in aliases to/from the WorkshopAttackDialogueFaction
; attackFactionValue: use SAE_XXX globals for the values
;   7.0 = raiders
function AddToGratefulFaction(ReferenceAlias theAlias, RefCollectionAlias theCollection, bool bAddToFaction = true, int attackFactionValue = 7)
    debug.trace(self + "AddToGratefulFaction " + theAlias + " " + theCollection + " " + bAddToFaction)
    if bAddToFaction
        if theAlias
            theAlias.TryToAddToFaction(WorkshopParent.WorkshopAttackDialogueFaction)
            theAlias.TryToSetValue(WorkshopParent.WorkshopAttackSAEFaction, attackFactionValue)
        endif
        if theCollection
            theCollection.AddToFaction(WorkshopParent.WorkshopAttackDialogueFaction)
            theCollection.SetValue(WorkshopParent.WorkshopAttackSAEFaction, attackFactionValue)
        endif
    else
        if theAlias
            theAlias.TryToRemoveFromFaction(WorkshopParent.WorkshopAttackDialogueFaction)
            theAlias.TryToSetValue(WorkshopParent.WorkshopAttackSAEFaction, -1)
        endif
        if theCollection
            theCollection.RemoveFromFaction(WorkshopParent.WorkshopAttackDialogueFaction)
            theCollection.SetValue(WorkshopParent.WorkshopAttackSAEFaction, -1)
        endif
    endif
endFunction

; 1.3: 86527: used to fix broken saves: disable attackers if attack is over, quest is waiting for aliases to unload, and workshop is unloaded
function CheckForDisableAttackers()
    MinRecruitQuestScript minRecruit = (self as Quest) as MinRecruitQuestScript
    if minRecruit && GetStageDone(minRecruit.StopStage) && minRecruit.StopQuestWhenAliasesUnloaded && WorkshopAlias.GetRef().Is3DLoaded() == false
        Attackers.DisableAll()
        Defenders.DisableAll()
    endif
endFunction
