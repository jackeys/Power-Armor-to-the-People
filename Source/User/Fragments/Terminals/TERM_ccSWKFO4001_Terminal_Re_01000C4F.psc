;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:Terminals:TERM_ccSWKFO4001_Terminal_Re_01000C4F Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(ccSWKFO4001_LLI_Redemption_Posters, 5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(Jangles01, 8)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(ccSWKFO4001_CosmosSpaceSuit_Redemption, 20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(ccSWKFO4001_CC1EnergyGun_Redemption, 20, PATTP_Setting_CosmosRedemptionLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(ccSWKFO4001_misc_Figurine, 10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(ccSWKFO4001_LLI_Redemption_Mystery, 3)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(ccSWKFO4001_LLI_Redemption_PowerArmor, 15, PATTP_Setting_CosmosRedemptionLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

LeveledItem Property ccSWKFO4001_LLI_Redemption_Mystery Auto Const Mandatory

LeveledItem Property ccSWKFO4001_LLI_Redemption_Posters Auto Const Mandatory

MiscObject Property Jangles01 Auto Const Mandatory

MiscObject Property ccSWKFO4001_misc_Figurine Auto Const Mandatory

LeveledItem Property ccSWKFO4001_LLI_Redemption_PowerArmor Auto Const Mandatory

GlobalVariable Property PATTP_Setting_CosmosRedemptionLegendaryChance Auto Const Mandatory

Armor Property ccSWKFO4001_CosmosSpaceSuit_Redemption Auto Const Mandatory

Weapon Property ccSWKFO4001_CC1EnergyGun_Redemption Auto Const Mandatory
