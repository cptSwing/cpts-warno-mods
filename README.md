# cpts-warno-mods

Repo for several small mods of mine, for RTS game WARNO. Mods are created by modifying files using [ndf-parse](https://github.com/Ulibos/ndf-parse) in python. Includes a wrapper to call the python scripts, and to further deal with WARNOs modding tools.

### Installation, Configuration

Requirements: Windows, python, [poetry](https://python-poetry.org/) (a dependancy manager for python)

1. run `poetry install` in your cloned repo's root folder
2. Edit your `config.env` file to the paths relevant on your system

   ```
   WARNO_MODS_FOLDER=C:\YOUR_STEAM_FOLDER\steamapps\common\WARNO\Mods
   NDF_PARSE_SOURCE_MOD_NAME="Your Desired Source Mod Name"
   USER_MOD_CONFIG_FOLDER=C:\Users\YOUR_WINDOWS_USER_NAME\Saved Games\EugenSystems\WARNO\mod
   ```

   `NDF_PARSE_SOURCE_MOD_NAME` will be the name of your "Source Mod" - ndf_parse needs this to build the mods from, and the wrapper will create it for you.

3. Double click/execute `lib\main.bat`

Generally, every time WARNO is updated you want to re-generate your Source Mod, and once that is done re-generate the various mods. Along the way you'll be asked if you'd like to upload the mod to Steam, or to launch WARNO with the mod enabled (in devmode).

### Mods

##### DoubleSupply

[Double the Amount of Supply of Logistics Vehicles and FOB Bases (DoubleSupply Readme)](/mods/DoubleSupply/README.md)

##### TripleSupply

[Triple the Amount of Supply of Logistics Vehicles and FOB Bases (TripleSupply Readme)](/mods/TripleSupply/README.md)

##### YIMBY\*

[Better Protection and Stealth for Infantry in  Large Buildings / Small Buildings / Ruins (YIMBY Readme)](/mods/YIMBY/README.md)

\*_Yes In My BackYard_

##### Entrench (WIP)

Let Engineer units (? All infantry?) dig in after a certain while, giving them defense and stealth bonusses
