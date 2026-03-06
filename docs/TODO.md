# Scope

### Mods

[x] Double Supply - Increases Supply in Vehicles & FOB
[x] Triple Supply - see above

[ ] YIMBY - Buffs Building Tiles for better Concealment & Damage Resistance

[-] Harder To Spot Infantry - Adds 0.5 UnitConcealmentBonus to Infantry Units, needs more changes in UI?

### Pipeline / Deployment

##### Goals


[x] Batch script should check if .env variables are set
[ ] Batch script should check if "source mod" needs updating before continuing
[x] Display Menu 1-X and handle input
[x] Execute respective modding script, passing variables to python scripts (mod dir, source mod, dry_run or not)
[ ] Increment "Version" number in Config file (integer)
[ ] If successful Batch script offers to generate mod, or update??
[ ] If successful Batch script offers to upload mod to Steam
[ ] Optionally: Run for all mods

##### Questions 

- ~~How are variables passed to .py~~ ?
- ~~How are errors caught and handled between .py and .bat~~ ?
- Can config files used by the steam uploader be located elsewhere than in the C:\Users\... directory?
- How to get version number of game? How to compare with mod version

##### Gotchas

- "If you made changes related to your mod gameplay, you must increase your mod version number
before uploading. Every files related to the gameplay are located inside GameData/Gameplay folder."
