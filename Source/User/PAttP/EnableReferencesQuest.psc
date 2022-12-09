Scriptname PAttP:EnableReferencesQuest extends Quest const
{Used to enable references only if a player has already done something in the game - for example, replacing an item added by this mod if the original mod item it replaced is already in use}

ObjectReference Property ReferenceToCheckIfEnabled Auto Const
{If this reference is enabled, we want to enable the other references}
GlobalVariable Property VariableToCheck Auto Const
{Alternatively, if this is set to the correct value we will enable}
float Property VariableShouldEqual Auto Const
ObjectReference[] Property ReferencesToEnable Auto Const Mandatory

Event OnQuestInit()
    EnableReferences()
EndEvent

Function EnableReferences()
    if (VariableToCheck && VariableToCheck.GetValue() == VariableShouldEqual) || (ReferenceToCheckIfEnabled && ReferenceToCheckIfEnabled.isEnabled())
        debug.trace(self + " enabling references")
        int i = 0
        while i < ReferencesToEnable.length
        ReferencesToEnable[i].Enable()
        i += 1
        EndWhile
    Else
        debug.trace(self + " no action needed")
    EndIf
EndFunction