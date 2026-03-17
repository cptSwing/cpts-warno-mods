import sys
import ndf_parse as ndf

source_mod_folder = sys.argv[1]
destination_mod_folder = sys.argv[2]
debug_mode = sys.argv[3] == "ON"

try: 
    mod = ndf.Mod(source_mod_folder, destination_mod_folder)
    mod.check_if_src_is_newer()

    # .match_pattern("TGamePlayTerrain(Name = 'PetitBatiment')"
    with mod.edit(r"GameData/Gameplay/Terrains/Terrains.ndf", not debug_mode) as source:
        for row in source:
            print(row)
            terrain_row = row.value.by_member("TGameplayTerrainsRegistration")

        print("+ ndf_parse Debug: ",source[0].value)
    sys.exit(0)
except Exception as err:
    print("+ ndf_parse Error (modify_values.py):", err)
    sys.exit(1)
