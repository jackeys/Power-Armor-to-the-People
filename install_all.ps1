$game_directory = $args[0]

if ($game_directory -eq $null) {
    $game_directory = Read-Host -Prompt "Enter the absolute path to your Fallout 4 install directory"
}

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