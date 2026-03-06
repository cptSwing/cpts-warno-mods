import ndf_parse as ndf
from pathlib import Path

# Add tools folder relative to this script
import sys

WARNO_MODS_FOLDER = sys.argv[1]
NDF_PARSE_SOURCE_MOD_NAME = sys.argv[2]
DEBUG_MODE = sys.argv[3] == "True"

print(f"Dry run: {DEBUG_MODE}")

WARNO_MODS_FOLDER = Path(WARNO_MODS_FOLDER) # automatically handles slashes in various OS's

source_mod_folder = WARNO_MODS_FOLDER / NDF_PARSE_SOURCE_MOD_NAME 
destination_mod_folder = WARNO_MODS_FOLDER / "TripleSupply"

mod = ndf.Mod(source_mod_folder, destination_mod_folder)
mod.check_if_src_is_newer()

with mod.edit(r"GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf", not DEBUG_MODE) as source:
    for obj_row in source:
        module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
        for list_row in module_descriptors_row.value.match_pattern("TSupplyModuleDescriptor()"):
            print(f"Processing {obj_row.namespace}... ")
            supply_capacity_row = list_row.value.by_member("SupplyCapacity")
            original_value_float = float(supply_capacity_row.value)
            supply_capacity_row.value = original_value_float * 3
print("Buildings DONE!")


with mod.edit(r"GameData/Generated/Gameplay/Gfx/UniteDescriptor.ndf", not DEBUG_MODE) as source:
    for obj_row in source:
        module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
        for list_row in module_descriptors_row.value.match_pattern("TSupplyModuleDescriptor()"):
            print(f"Processing {obj_row.namespace}... ")
            supply_capacity_row = list_row.value.by_member("SupplyCapacity")
            original_value_float = float(supply_capacity_row.value)
            supply_capacity_row.value = original_value_float * 3
print("Units DONE!")
