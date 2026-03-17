import sys
import ndf_parse as ndf

source_mod_folder = sys.argv[1]
destination_mod_folder = sys.argv[2]
debug_mode = sys.argv[3] == "ON"

supply_multiplier = 2

try: 
    mod = ndf.Mod(source_mod_folder, destination_mod_folder)
    mod.check_if_src_is_newer()

    print("\n+ ndf_parse: Modifying Buildings")
    with mod.edit(r"GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf", not debug_mode) as source:
        for obj_row in source:
            module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
            for list_row in module_descriptors_row.value.match_pattern("TSupplyModuleDescriptor()"):
                supply_capacity = list_row.value.by_member("SupplyCapacity")
                original_value = float(supply_capacity.value)
                modified_value = original_value * supply_multiplier
                supply_capacity.value = modified_value
                print(f"+ ndf_parse: {obj_row.namespace} - SupplyCapacity {original_value} --> {modified_value}")
    print("+ ndf_parse: Supply Buildings DONE!\n")

    print("+ ndf_parse: Modifying Units")
    with mod.edit(r"GameData/Generated/Gameplay/Gfx/UniteDescriptor.ndf", not debug_mode) as source:
        for obj_row in source:
            module_descriptors_row = obj_row.value.by_member("ModulesDescriptors")
            for list_row in module_descriptors_row.value.match_pattern("TSupplyModuleDescriptor()"):
                supply_capacity = list_row.value.by_member("SupplyCapacity")
                original_value = float(supply_capacity.value)
                modified_value = original_value * supply_multiplier
                supply_capacity.value = modified_value
                print(f"+ ndf_parse: {obj_row.namespace} - SupplyCapacity {original_value} --> {modified_value}")
    print("+ ndf_parse: Supply Units DONE!\n")
    sys.exit(0)
except Exception as err:
    print("\n+ ndf_parse Error (modify_values.py):", err)
    sys.exit(1)
