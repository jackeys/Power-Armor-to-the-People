$mod_directory = $args[0]
$game_directory = $args[1]


if ([string]::IsNullOrWhiteSpace($game_directory)) {
    $game_directory = Read-Host -Prompt "Enter the absolute path to your Fallout 4 install directory"
}

$data_folder = "$game_directory\Data\"

Set-Location -Path "$mod_directory"
$content_files = Get-ChildItem "Content" -Recurse -File

foreach ($f in $content_files) {
    if ($f.Extension -eq ".esp") {
        $mod_file = $f.FullName
        $game_file = $mod_file -replace '.*\\', "$data_folder"

        if ( Test-Path -Path $game_file ) {

            # Filter out the alternate versions that we don't directly develop against
            if ( $mod_file.Contains("ESP Version") ) {
                if (Compare-Object -ReferenceObject $(Get-Content $($mod_file -replace "ESP Version", "ESL Version")) -DifferenceObject $(Get-Content $game_file)) {
                    Write-Output "Create an alternate version of $mod_file"
                }
            } elseif ($mod_file.Contains("Hellcat Power Armor\1.1")) {
                if (Compare-Object -ReferenceObject $(Get-Content $($mod_file -replace "1.1", "1.2")) -DifferenceObject $(Get-Content $game_file)) {
                    Write-Output "Create an alternate version of $mod_file"
                }
            } elseif ($mod_file.Contains("Classic Advanced Power Armor\Overhaul")) {
                $game_file = $game_file -replace '.esp', ' [Overhaul].esp'
                Copy-Item -LiteralPath "$game_file" -Destination "$mod_file"
            } elseif ($mod_file.Contains("Combat Power Armor\Original")) {
                $game_file = $game_file -replace '.esp', ' [Original].esp'
                Copy-Item -LiteralPath "$game_file" -Destination "$mod_file"
            } elseif ($mod_file.Contains("Tumbajamba's Gunner Power Armor\Armor Collection")) {
                $game_file = $game_file -replace '.esp', ' [Collection].esp'
                Copy-Item -LiteralPath "$game_file" -Destination "$mod_file"
            } elseif ($mod_file.Contains("Enclave X-02 Black Devil Power Armor\1.21")) {
                $game_file = $game_file -replace '.esp', ' [1.21].esp'
                Copy-Item -LiteralPath "$game_file" -Destination "$mod_file"
            } elseif (-not $mod_file.Contains("MogomraPAMs\1.4")) {
                Copy-Item -Path "$game_file" -Destination "$mod_file"
            }
        } else {
            Write-Output "$mod_file does not exist in the game folder"
        }
    }
}
