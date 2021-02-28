# Power Armor to the People

Power Armor to the People is a mod aimed at integrating other Power Armor mods into the world, making them feel like a natural part of the game. It primarily does this by:
* Making power armor available as a legendary drop
* Adding more enemies that wear power armor
* Removing the single full set typical of power armor mods

The mod is a series of ESL-flagged ESPs that patch together and enhance features from the mods it aims to integrate.

## Adding a New Set of Power Armor
For most sets of power armor, each of the following should be done to fully integrate it. Each step should be in its own ESL-flagged ESP with a name following this general convention:

`<Set Name> <Feature>.esp`

### Adding a Legendary Power Armor Mod
The basic premise behind building a legendary power armor mod is to create a master leveled item list that refers to a series of other leveled items for each of the linings your power armor can drop with, and inject that list into the two provided by the `Legendary PA Pieces` mod. Detailed instructions are as follows:

1. Create an ESL-flagged ESP that with `Legendary PA Pieces` and the power armor set mod as its masters
1. Create a Leveled Item that can return any piece of the power armor with no level restrictions, filter keywords, or epic loot chance: `LL_Armor_Power_<Set_Name>_Any_Piece`
1. Create a Leveled Item for each lining level of power armor that can drop as a legendary item (typically A-F) with no level restrictions: `LL_Armor_Power_<Set_Name>_Any_A`
   * Add the first Leveled Item, which can return any piece of the power armor, as the only item on the leveled list
   * Set the filter keyword to the corresponding lining (e.g. if_tmp_PA_Lining_A) with 100% chance
   * Set the epic loot chance to `LL_EpicChance_Standard`
1. Create a Leveled Item to act as the entry point that ties together each of the lining level items with the level at which they should show up: `LL_Armor_Power_<Set_Name>_Any`
   * Calculate From All Levels <= Player flag should be set
   * The lowest level item should always be 1, since this list will be injected with an appropriate level later and you don't want a mismatch between those two levels
   * Typically, each lining should be 4 levels higher than the last, so you might have a sequence like 1, 84, 88, 92, 96, 100 if you plan for this power armor to start dropping at level 80
1. Create a quest that runs on start and uses the `LegendaryPowerArmor_InjectLegendaries` script
   * Inject your entry point list (`LL_Armor_Power_<Set_Name>_Any`) into both `LGND_PossibleLegendaryItemBaseLists_PowerArmorGroupHigh` and `LGND_PossibleLegendaryItemBaseLists_PowerArmorGroupLow` from `Legendary PA Pieces`
   * The `level` property indicates the level that the armor should start to drop, and the `listToInject` property indicates which entry point list should be added
   * The utility ESP `Inject Legendaries Template.esp` can be used as an example of this script

# Power Armor Sets
## Ultracite
### Compatibility Notes
* Brotherhood of Steel integration overrides the T-60 Sentinel vendor list from the base game