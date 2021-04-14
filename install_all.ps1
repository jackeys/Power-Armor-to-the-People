# Self-elevate the script if we aren't already an administrator, since making symbolic links requires Administrator privileges
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Read-Host -Prompt "This script needs to be run as Administrator because it creates symbolic links in your game directory to this project  -- Press Enter to continue"
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CurrentDirectory = Get-Location
        $GameDirectory = $args[0]
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + "`"$CurrentDirectory`" " + "`"$GameDirectory`""
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList  $CommandLine
        Exit
    }
}

# This is supplied automatically when the script is run from the mod directory, passed in through the self-elevation above
$mod_directory = $args[0]
$game_directory = $args[1]

if ([string]::IsNullOrWhiteSpace($game_directory)) {
    $game_directory = Read-Host -Prompt "Enter the absolute path to your Fallout 4 install directory"
}

Read-Host -Prompt "Linking all scripts and configs to $game_directory -- Press Enter to continue"

Set-Location -Path "$mod_directory"
$content_files = Get-ChildItem "Content" -Recurse -File

foreach ($f in $content_files) {
    if ($f.Extension -eq ".pex") {
        # Take only the part of the path after Scripts, since that directory structure needs to be preserved in the game folder
        $relative_path = $f.FullName -replace '^.*Scripts\\', ""
        
        # We need to use the -Force flag because the namespace folders likely won't exist
        New-Item -Path "$game_directory\Data\Scripts\$relative_path" -ItemType SymbolicLink -Value $f.FullName -Force
    }
    elseif ($f.FullName -match "MCM") {
        # Take only the part of the path after MCM, since that directory structure needs to be preserved in the game folder
        $relative_path = $f.FullName -replace '^.*MCM\\', ""
        
        # We need to use the -Force flag because the namespace folders likely won't exist
        New-Item -Path "$game_directory\Data\MCM\$relative_path" -ItemType SymbolicLink -Value $f.FullName -Force
    }
}

$source_files = Get-ChildItem "Source" -Recurse -File

foreach ($f in $source_files) {
    # Take only the part of the path after Source, since that directory structure needs to be preserved in the game folder
    $relative_path = $f.FullName -replace '^.*Source\\', ""
    
    # We need to use the -Force flag because the namespace folders likely won't exist
    New-Item -Path "$game_directory\Data\Scripts\Source\$relative_path" -ItemType SymbolicLink -Value $f.FullName -Force
}
