@echo off

REM Since this script is intended to be run as administrator, we need to explicitly set our starting directory
pushd %~dp0

if "%~1" == "" (
    set /p TARGET_DIRECTORY=Enter absolute path to Fallout 4 install directory: 
) else (set TARGET_DIRECTORY=%~1)

echo Deploying to %TARGET_DIRECTORY%

For /R Content %%F IN (*.esp) do mklink "%TARGET_DIRECTORY%\Data\%%~nxF" "%%F"