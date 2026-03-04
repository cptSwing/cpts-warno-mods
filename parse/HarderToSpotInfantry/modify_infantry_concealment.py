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

warno_mods_folder = Path(env["WARNO_MODS_FOLDER"]) # automatically handles slashes in various OS's
destination_mod_name = env["MY_WARNO_MOD_NAME"]

source_mod_folder = warno_mods_folder / "SourceModPointOfTruth" 
destination_mod_folder = warno_mods_folder / destination_mod_name

mod = ndf.Mod(source_mod_folder, destination_mod_folder)
mod.check_if_src_is_newer()

with mod.edit(r"GameData/Generated/Gameplay/Gfx/UniteDescriptor.ndf", not dry_run) as source:
    for obj_row in source:
        module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
        
        # if "TInfantrySquadModuleDescriptor()" in module_descriptors_row.v:
        infantry_results = module_descriptors_row.value.match_pattern("TInfantrySquadModuleDescriptor()")
        for result in infantry_results:
             for concealed in module_descriptors_row.value.match_pattern("TVisibilityModuleDescriptor()"):
                print(f"Processing {obj_row.namespace}... ")
                concealed_row = concealed.value.by_member("UnitConcealmentBonus")
                original_value_float = float(concealed_row.value)
                concealed_row.value = original_value_float + 0.5
                ndf.printer.print(concealed)        
print("DONE!")
