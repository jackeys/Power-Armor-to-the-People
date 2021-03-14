# Power Armor to the People

Power Armor to the People is a Fallout 4 mod aimed at integrating other Power Armor mods into the world, making them feel like a natural part of the game. It primarily does this by:
* Making power armor available as a legendary drop
* Adding more enemies that wear power armor
* Removing the single full set typical of power armor mods

The mod is a series of ESL-flagged ESPs that patch together and enhance features from the mods it aims to integrate.

## Building a Release
A release is a zip file that includes the `fomod` directory, which contains the installer information for a FOMOD-compatible mod manager such as [Vortex](https://www.nexusmods.com/about/vortex/), and the `Content` directory, which includes the actual files that make up the mod. To create a release, simply run `release.bat`.

By default, `release.bat` will use the current date as the version. However, you may provide a parameter to include a specific version, such as `release.bat 1.0.0`. This is especially useful in combination with [FOMOD Creation Tool](https://www.nexusmods.com/fallout4/mods/6821), where you can specify a script to run after saving that uses the version included in the FOMOD installer:

```
start /d "C:\path\to\this\directory" release.bat $MODVERSION$
```

## Installing for Development
If you are installing the mod just to use it, it is **strongly recommended** that you use a release zip file and install using a FOMOD-compatible mod manager such as [Vortex](https://www.nexusmods.com/about/vortex/). For development purposes, however, this can be cumbersome, so a script `install_all.ps1` is provided. This script will symbolically link all of the files in the project to the appropriate place in the game's directory, allowing for changes made to be immediately reflected in the project directory. When running the script, which can be done by right-clicking and selecting, "Run with PowerShell," it will ask for the install path of Fallout 4 (e.g. `C:\Program Files (x86)\Steam\steamapps\common\Fallout 4`). Alternatively, this can be entered as a command-line argument:

```
install_all.ps1 "C:\Program Files (x86)\Steam\steamapps\common\Fallout 4"
```

**Important Note:** When you run this script, it will request administrator access because Windows only allows an administrator to create symbolic links.

If you add any new files to the mod, you will need to manually place those within the project directory and run this script again to link them.