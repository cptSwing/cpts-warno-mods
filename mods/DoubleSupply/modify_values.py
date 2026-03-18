import sys
import ndf_parse as ndf

source_mod_folder = sys.argv[1]
destination_mod_folder = sys.argv[2]
debug_mode = sys.argv[3] == "ON"

supply_multiplier = 2

try: 
    mod = ndf.Mod(source_mod_folder, destination_mod_folder)

    print("+ ndf_parse: Loading Buildings")
    building_descriptors_src = mod.edit(r"GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf", not debug_mode).current_tree

    print("+ ndf_parse: Loading Units")
    unit_descriptors_src = mod.edit(r"GameData/Generated/Gameplay/Gfx/UniteDescriptor.ndf", not debug_mode).current_tree

    print("+ ndf_parse: Parsing...\n")
    descriptors = [("Buildings", building_descriptors_src), ("Units", unit_descriptors_src)]
    for descriptor_tuple in descriptors:
        descriptor_name = descriptor_tuple[0]
        descriptor_List = descriptor_tuple[1]
        
        for t_entity_descriptor_ListRow in descriptor_List:
            t_entity_descriptor_Object = t_entity_descriptor_ListRow.value
            modules_descriptors_List = t_entity_descriptor_Object.by_member("ModulesDescriptors")

            for modules_descriptors_ListRow in modules_descriptors_List.value.match_pattern("TSupplyModuleDescriptor()"):
                t_supply_module_descriptor_Object = modules_descriptors_ListRow.value
                supply_capacity_MemberRow = t_supply_module_descriptor_Object.by_member("SupplyCapacity")
                original_supply_capacity_value = float(supply_capacity_MemberRow.value)
                new_supply_capacity_value = original_supply_capacity_value * supply_multiplier
                supply_capacity_MemberRow.edit(value=str(new_supply_capacity_value))
                print(f"+ ndf_parse: {t_entity_descriptor_ListRow.namespace} - SupplyCapacity {original_supply_capacity_value} --> {new_supply_capacity_value}")

        print(f"+ ndf_parse: Supply {descriptor_name} DONE!\n")

    for edit in mod.edits:
        mod.write_edit(edit, False)

    sys.exit(0)
except Exception as err:
    print("\n+ ndf_parse Error (modify_values.py):", err)
    sys.exit(1)
