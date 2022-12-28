Scriptname PAttP:StartQuestWhenRead extends ObjectReference

Quest property QuestToStart auto const
int property StageToSet auto const

auto state waiting
Event OnRead()
    QuestToStart.SetStage(StageToSet)
    gotoState("Done")
EndEvent
endState

state Done
endstate
