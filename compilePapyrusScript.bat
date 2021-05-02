set compilerPath=%2
set gameDirectory=%~3
 
%compilerPath% %1 -f="%gameDirectory%\Data\Scripts\Source\Base\Institute_Papyrus_Flags.flg" -i="%gameDirectory%\Data\Scripts\Source\User;%gameDirectory%\Data\Scripts\Source\Base" -o="%gameDirectory%\Data\Scripts"