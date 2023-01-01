$mod_directory = $args[0]
$game_directory = $args[1]


if ([string]::IsNullOrWhiteSpace($game_directory)) {
    $game_directory = Read-Host -Prompt "Enter the absolute path to your Fallout 4 install directory"
}

$xwma_encoder = "$game_directory\Tools\Audio\xwmaencode.exe"

Set-Location -Path "$mod_directory"
$content_files = Get-ChildItem "Content" -Recurse -File

foreach ($f in $content_files) {
    if ($f.Extension -eq ".wav") {
        # Convert the audio
        $input_file = $f.FullName
        $output_file = $f.FullName -replace '\.wav', '.xwm'
        Start-Process -FilePath "$xwma_encoder" -Wait -ArgumentList "`"$input_file`" `"$output_file`""

        # Take only the part of the path starting with Sound, since that directory structure needs to be preserved in the Assets
        $relative_path = $f.FullName -replace '^.*\\Sound\\', "Sound\"
        $relative_directory = $relative_path -replace '[\w\b]*?\.wav', ''

        # Create the directory in the Assets directory in case it doesn't exist
        $move_destination = "$mod_directory\Assets\$relative_directory\"
        if ( -not (Test-Path "$move_destination" -PathType Container) ) {
            New-Item -Path "$move_destination" -ItemType Directory
        }

        Move-Item -Path "$input_file" -Destination "$move_destination"
    }
}
