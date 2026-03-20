## Bugs

#### Wrapper

###### Get Gameversion w/o 'generating' SourceMod

- WARNO.exe ?
- Steam somehow?
- One of the other Modding Tools?
- Compare last generated with current game version

###### Why "generate" without parsing at outset?

Unsure of this one, basically only need this to get version number of source mod, and display version + modgenversion of my mods

###### ~~"Source Mod" referenced at Mod creation~~ [FIXED]

~~When generating mods, they reference the Source Mod in some of their newly generated files~~
~~See `WARNO\Mods\MOD_NAME\Gen\UsedFiles.txt` or `Saved Games\EugenSystems\WARNO\mod\MOD_NAME\Gen\DeclaredFiles.txt` for instance.~~

~~"Bug" in `check_if_src_is_newer()`, too much stuff gets copied from source to destination~~

~~"Must be used before any edits are applied otherwise they will be overwritten by data from source." (copies directories instead of just running 'CreateNewMod', weirdly enough: https://github.com/Ulibos/ndf-parse/blob/91ba26fea199ed0413e8f17d4656a3c5cfefac6b/ndf_parse/__init__.py#L224)~~

- ~~Either get version numbers from sourcemod somehow else, or~~
- ✅ Do not use `check_if_src_is_newer()` (though it seems sensible)

#### YIMBY

###### Are values even working?

- In-Game map hints show default values for concealment etc
- Either these are hard-coded (where?)
- Or things are not working as expected
- Testing with insanely high values to see.

## Ideas

#### Wrapper

###### "Build Mod"

Instead of having differing processes of "generate mod" (just the actual mod tool command at start of main.bat), "(re-)generate mod" (parse ndf and then generate), "re-generate source mod" (delete sourcemod directory, create new sourcemod) - always delete/create (using create.bat) then parse. Optional regenerate after parsing as before

###### Ditch Batch and move to fully python-based wrapper?

Some people do play on linux.
how do the mod tools work on linux, do they exist?? --> replacing would be less important, if there are no mod devs on linux anyway

#### Python

Rewrite existing scripts to use typing!
