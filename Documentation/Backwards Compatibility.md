# Backwards Compatibility

With Power Armor to the People 2.0, a major rework was done that merged together all of the separate feature patches and put the configuration in-game instead. As such, the majority of the patches were removed and are no longer needed, adding things to the game that were transient and no longer used. There are, however, a few plugins that added persistent elements to the game and cannot be removed. These plugins are meant to be inert, meaning that they keep the persistent elements in your game but will no longer be used to add enemies or change what is visible in the world.

## Plugin Replacements

### T-65 Redistribution
This plugin originally changed what power armor frame was placed near The Castle. It remains so that if the cell has been spawned, you won't lose the frame.

### Institute Power Armor - Power Armored Enemies
This plugin added new enemy types and a power armor frame for them. It remains in case any of these NPCs are currently spawned, or in case a mod was used to allow retrieval of the power armor frame from a corpse.

### Institute Power Armor - Power Armored Enemies - Institute Heavy Weaponry
This plugin added an Institute Gatling Laser. It remains to ensure that weapon is not removed from the game.

### UltracitePA - Power Armored Enemies
This plugin added new enemy types and a power armor frame for them. It remains in case any of these NPCs are currently spawned, or in case a mod was used to allow retrieval of the power armor frame from a corpse.

## Previous Dependencies

### SweXavier05's Power Armored Enemies (EMEncounters1)
This mod is likely not safe to remove from a game in progress since it adds enemies (including some statically placed in the world) and power armor frames, so these items can end up disappearing from the world. As such, it is still recommended to keep this installed. 

It should be higher in the load order than Power Armor to the People so its changes don't override this mod. An optional patch has been included that also gives the unique placed enemies from this mod the wider variety of power armor sets provided by Power Armor to the People. If you use LOOT or a mod manager that can automatically sort your mods, this plugin should also make sure the load order is correct between the two.

### Legendary Power Armor Pieces
This mod and its Far Harbor patch have been completely replaced and should no longer be necessary in your game. My testing indicates that there are no adverse effects to removing it mid-game, but if you want to be safe, just make sure it is higher in your load order than Power Armor to the People so its changes don't override this mod.
