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