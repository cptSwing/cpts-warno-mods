import ndf_parse as ndf
from pathlib import Path

# Add tools folder relative to this script
import sys
tools_path = Path(__file__).resolve().parent.parent.parent / "tools"
sys.path.insert(0, str(tools_path))
from load_env import load_env

env = load_env()

dry_run = True
print(f"Dry run: {dry_run}")

WARNO_MODS_FOLDER = Path(env["WARNO_MODS_FOLDER"]) # automatically handles slashes in various OS's
destination_mod_name = env["MY_WARNO_MOD_NAME"]

source_mod_folder = WARNO_MODS_FOLDER / "SourceModPointOfTruth" 
destination_mod_folder = WARNO_MODS_FOLDER / destination_mod_name

mod = ndf.Mod(source_mod_folder, destination_mod_folder)
mod.check_if_src_is_newer()

# .match_pattern("TGamePlayTerrain(Name = 'PetitBatiment')"

with mod.edit(r"GameData/Gameplay/Terrains/Terrains.ndf", not dry_run) as source:
    for row in source:
        print(row)

        terrain_row = row.value.by_member("TGameplayTerrainsRegistration")

    print("Print:",source[0].value)
 

print("DONE!")
