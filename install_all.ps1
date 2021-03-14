# Self-elevate the script if we aren't already an administrator, since making symbolic links requires Administrator privileges
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
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

Read-Host -Prompt "Installing all mods to $game_directory -- Press any key to continue"

Set-Location -Path "$mod_directory"
$files = Get-ChildItem "Content" -Recurse

foreach ($f in $files) {
    if ($f.Extension -eq ".esp") {
        New-Item -Path "$game_directory\Data\$f" -ItemType SymbolicLink -Value $f.FullName
    }

    if ($f.Extension -eq ".pex") {
        # Take only the part of the path after Scripts, since that directory structure needs to be preserved in the game folder
        $relative_path = $f.FullName -replace '^.*Scripts\\', ""

        # We need to use the -Force flag because the namespace folders likely won't exist
        New-Item -Path "$game_directory\Data\Scripts\$relative_path" -ItemType SymbolicLink -Value $f.FullName -Force
    }
}