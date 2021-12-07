# Power Armor to the People

Power Armor to the People is a Fallout 4 mod aimed at integrating other Power Armor mods into the world, making them feel like a natural part of the game. It primarily does this by:
* Making power armor available as a legendary drop
* Adding more enemies that wear power armor
* Removing the single full set typical of power armor mods

The mod is a series of ESL-flagged ESPs that patch together and enhance features from the mods it aims to integrate, tied together into an installer that auto-detects which supported mods are already active.

Check the [wiki](https://github.com/jackeys/Power-Armor-to-the-People/wiki) for complete details, including where you can find all of the content added by the mod, how to install it, and credits for the mods that Power Armor to the People is dependent on.

## Using the Mod

It is highly recommended that you download the latest release from [NexusMods](https://www.nexusmods.com/fallout4/mods/50819). You can also see screenshots of the mod in action, post comments, and file any issues you encounter there.

## Building a Release
A release is a zip file that includes the `fomod` directory, which contains the installer information for a FOMOD-compatible mod manager such as [Vortex](https://www.nexusmods.com/about/vortex/), and the `Content` directory, which includes the actual files that make up the mod. To create a release, simply run `release.bat`.

By default, `release.bat` will use the current date as the version. However, you may provide a parameter to include a specific version, such as `release.bat 1.0.0`. This is especially useful in combination with [FOMOD Creation Tool](https://www.nexusmods.com/fallout4/mods/6821), where you can specify a script to run after saving that uses the version included in the FOMOD installer:

```
start /d "C:\path\to\this\directory" release.bat $MODVERSION$
```

## Installing for Development
For development purposes, a script `install_all.ps1` is provided that will symbolically link all of the files in the project to the appropriate place in the game's directory, allowing for changes made to be immediately reflected in the project directory. Note that this does not work for plugin files (.esp) themselves because tools like xEdit make copies and overwrite the files, clobbering the symbolic link instead of updating the targets they point to.

When running the script, which can be done by right-clicking and selecting, "Run with PowerShell," it will ask for the install path of Fallout 4 (e.g. `C:\Program Files (x86)\Steam\steamapps\common\Fallout 4`). Alternatively, this can be entered as a command-line argument:

```
install_all.ps1 "C:\Program Files (x86)\Steam\steamapps\common\Fallout 4"
```

**Important Note:** When you run this script, it will request administrator access because Windows only allows an administrator to create symbolic links. Use with caution, as this will overwrite any files with the same names already in your game folder.

If you add any new files to the mod, you will need to manually place those within the project directory and run this script again to link them.

## Patchers

Patchers go through a load order and use a script to create a new plugin with overwrites for records in the load order. They have the following prerequisites:

* [FO4Edit](https://www.nexusmods.com/fallout4/mods/2737)
* [MXPF](https://www.nexusmods.com/skyrim/mods/68617/)

With the prerequisites installed, copy the contents of the patcher to the directory containing the `FO4Edit.exe` and `Edit Scripts` directory. Then, simply run the `bat` file from that directory.