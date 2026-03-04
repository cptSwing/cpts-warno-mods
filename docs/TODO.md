# Scope

### Mods

[x] Double Supply - Increases Supply in Vehicles & FOB
[x] Triple Supply - see above

[ ] YIMBY - Buffs Building Tiles for better Concealment & Damage Resistance

[-] Harder To Spot Infantry - Adds 0.5 UnitConcealmentBonus to Infantry Units, needs more changes in UI?

### Pipeline / Deployment

##### Goals

1. Run Batch/Psh script that displays menu, input numbers 1-X to choose which mod to update (for testing, or when game updates)
2. Script passing relevant variables (mod name),

[ ] Write Batch script waiting for input
[ ] Batch script should check if .env variables are set
[ ] Batch script should check if "source mod" needs updating before continuing
[ ] Execute modding changes, passing variables to python scripts (mod dir, source mod, dry_run or not)
[ ] If successful Batch script offers to upload mod to Steam
[ ] Optionally: Run for all mods
