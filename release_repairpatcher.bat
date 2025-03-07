IF "%~1" == "" (set VERSION="%date%") ELSE (set VERSION="%1")

powershell Compress-Archive -Path 'Patchers/Repair Requirements/Data/*' -DestinationPath 'Releases/PARTS Visible Requirements-%VERSION%.zip' -Force
powershell Compress-Archive -Path 'Patchers/Repair Requirements/FO4Edit/*' -DestinationPath 'Releases/PARTS Patcher-%VERSION%.zip' -Force