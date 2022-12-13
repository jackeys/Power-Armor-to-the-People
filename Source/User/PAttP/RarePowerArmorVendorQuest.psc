Scriptname PAttP:RarePowerArmorVendorQuest extends Quest

GlobalVariable Property VendorCurrentStatus Auto Const Mandatory
{0 = Traveling, 1 = Waiting}
GlobalVariable Property VendorCurrentDestination Auto Const Mandatory
{Moves in a loop from 1 to 2 to 3 to 2 to 1}

int previousLocation = 1

Function VendorArrivedAtDestination()
    Debug.Trace(self + " Vendor is starting to wait")
    VendorCurrentStatus.SetValue(1)
    ; Wait for 8 hours at the destination
	StartTimerGameTime(8)
EndFunction

Event OnTimerGameTime(int aiTimerID)		
	Debug.Trace(self + " Vendor has finished waiting")
    TravelToNextDestination()
EndEvent

Function TravelToNextDestination()
    int currentLocation = VendorCurrentDestination.GetValueInt()

    if currentLocation == 1
        VendorCurrentDestination.SetValue(2)
    elseif currentLocation == 2 && previousLocation == 1
        VendorCurrentDestination.SetValue(3)
    elseif currentLocation == 2 && previousLocation == 3
        VendorCurrentDestination.SetValue(1)
    else
        VendorCurrentDestination.SetValue(2)
    EndIf

    VendorCurrentStatus.SetValue(0)

    previousLocation = currentLocation
EndFunction
