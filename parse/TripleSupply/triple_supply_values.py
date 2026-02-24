import ndf_parse as ndf
from pathlib import Path

# Add tools folder relative to this script
import sys
tools_path = Path(__file__).resolve().parent.parent.parent / "tools"
sys.path.insert(0, str(tools_path))
from load_env import load_env

env = load_env()

dry_run = False
print(f"Dry run: {dry_run}")

warno_mods_folder = Path(env["WARNO_MODS_FOLDER"]) # automatically handles slashes in various OS's
destination_mod_name = env["MY_WARNO_MOD_NAME"]

source_mod_folder = warno_mods_folder / "SourceModPointOfTruth" 
destination_mod_folder = warno_mods_folder / destination_mod_name

mod = ndf.Mod(source_mod_folder, destination_mod_folder)
mod.check_if_src_is_newer()

with mod.edit(r"GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf", not dry_run) as source:
    for obj_row in source:
        # each time we get here it means that we've got ammunition of matching caliber
        print(f"Processing {obj_row.namespace}... ")
        module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
        for list_row in module_descriptors_row.value.match_pattern("TSupplyModuleDescriptor()"):
            supply_capacity_row = list_row.value.by_member("SupplyCapacity")
            original_value_float = float(supply_capacity_row.value)
            supply_capacity_row.value = original_value_float * 3
print("DONE!")
