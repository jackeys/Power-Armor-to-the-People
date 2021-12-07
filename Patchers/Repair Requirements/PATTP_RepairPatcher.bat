@echo off

set hasXedit=0
set hasRepairPatcherScript=0
set hasMXPF==0
set hasMTEFunctions==0
set hasRequiredFiles==0

IF EXIST "FO4Edit.exe" set hasXedit=1
IF EXIST "Edit Scripts\PATTP_RepairPatcher.pas" set hasRepairPatcherScript=1
IF EXIST "Edit Scripts\lib\mxpf.pas" set hasMXPF=1
IF EXIST "Edit Scripts\lib\mteFunctions.pas" set hasMTEFunctions=1

echo::: "Power Armor to the People Repair Requirements Patcher"
echo :
echo :
echo ::: Checking for required files :::
echo :

IF %hasXedit%==1 (
  echo : FO4Edit found
) ELSE (
    echo : WARNING: FO4Edit.exe not found
)
IF %hasRepairPatcherScript%==1 (
    echo : PATTP_RepairPatcher.pas found
) ELSE (
    echo : WARNING: PATTP_RepairPatcher.pas not found
)
IF %hasMXPF%==1 (
    echo : mxpf.pas found
) ELSE (
    echo : WARNING: mxpf.pas not found
)
IF %hasMTEFunctions%==1 (
    echo : mteFunctions.pas found
) ELSE (
    echo : WARNING: mteFunctions.pas not found
)

IF %hasXedit%==1 IF %hasRepairPatcherScript%==1 IF %hasMXPF%==1 IF %hasMTEFunctions%==1 set hasRequiredFiles=1
IF %hasRequiredFiles%==1 (
    echo :
    echo :
    %choice%
) ELSE (
    echo :
    echo :
    echo : Required files not found. Terminating process.
    echo :
    echo :
    pause
    exit
)

:choice
set /P c=::: All required files installed. Would you like to patch your power armor repair requirements? [Y/N]?
if /I "%c%" EQU "Y" goto :runPatch
if /I "%c%" EQU "N" goto :exitPatch
goto :choice


:runPatch
start FO4Edit.exe -nobuildrefs -script:"PATTP_RepairPatcher.pas"

:exitPatch
exit


