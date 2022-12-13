Scriptname PAttP:RarePowerArmorVendorTravelPackage extends Package

PAttP:RarePowerArmorVendorQuest Property VendorQuest Auto Const Mandatory

Event OnEnd(Actor akActor)
    VendorQuest.VendorArrivedAtDestination()
EndEvent