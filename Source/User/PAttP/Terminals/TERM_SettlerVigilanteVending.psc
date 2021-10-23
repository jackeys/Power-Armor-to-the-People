;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PAttP:Terminals:TERM_SettlerVigilanteVending Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseItem(NewerMind43_LLI_Redemption_Tool, 20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_ArmLeft_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_ArmRight_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_Helmet_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_LegLeft_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_LegRight_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
PAttP:RedemptionMachine redemptionMachine = akTerminalRef as PAttP:RedemptionMachine
redemptionMachine.PurchaseLegendaryItem(NewerMind43_Armor_Power_T51_Torso_Settler, 100, PATTP_Setting_VendingMachineLegendaryChance)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

LeveledItem Property NewerMind43_LLI_Redemption_Tool Auto Const Mandatory

Armor Property NewerMind43_Armor_Power_T51_ArmLeft_Settler Auto Const Mandatory
Armor Property NewerMind43_Armor_Power_T51_ArmRight_Settler Auto Const Mandatory
Armor Property NewerMind43_Armor_Power_T51_LegLeft_Settler Auto Const Mandatory
Armor Property NewerMind43_Armor_Power_T51_LegRight_Settler Auto Const Mandatory
Armor Property NewerMind43_Armor_Power_T51_Helmet_Settler Auto Const Mandatory
Armor Property NewerMind43_Armor_Power_T51_Torso_Settler Auto Const Mandatory

GlobalVariable Property PATTP_Setting_VendingMachineLegendaryChance Auto Const Mandatory

