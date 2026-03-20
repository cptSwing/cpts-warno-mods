import sys
import ndf_parse as ndf
import extract_terrains_list

source_mod_folder = sys.argv[1]
destination_mod_folder = sys.argv[2]
debug_mode = sys.argv[3] == "ON"

# "The concealment of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`"
additional_concealment_bonus = 0.25

# "This would represent a 30% damage reduction on a specific terrain: (DamageFamily_he, MAP [(ResistanceFamily_infanterie, 0.7)])"
# "A 0.7 means it would multiply by 0.7 any matching damage for matching resistance on this terrain. In other words, a 30% reduction."
subtracted_damage = 0.05

try: 
    mod = ndf.Mod(source_mod_folder, destination_mod_folder)

    replacement_object = ndf.model.Object(type='unnamed TGameplayTerrainsRegistration')

    print("\n+ ndf_parse: Modifying Building Concealment & DamageModifiers")
    with mod.edit(r"GameData/Gameplay/Terrains/Terrains.ndf", not debug_mode) as root_List:
        gameplay_terrains_registration_ListRow = root_List[0]

        # convert ndf string to ndf_parse MemberRow I can iterate over, 
        terrains_List = extract_terrains_list.extract(gameplay_terrains_registration_ListRow.value)
        if terrains_List is None:
            raise Exception("+ ndf_parse Error (extract_terrains_list.py): No results")
        
        replacement_object.add(ndf.model.MemberRow.from_ndf(terrains_List))

        for t_gameplay_terrain_ListRow in replacement_object.by_member("Terrains").value:
            t_gameplay_terrain_Object = t_gameplay_terrain_ListRow.value
            t_gameplay_terrain_name = t_gameplay_terrain_Object.by_member("Name").value

            if (t_gameplay_terrain_name == "'PetitBatiment'" or t_gameplay_terrain_name == "'Batiment'" or t_gameplay_terrain_name == "'Ruin'"):
                concealment_bonus_MemberRow = t_gameplay_terrain_Object.by_member("ConcealmentBonus")
                original_concealment_bonus_value = float(concealment_bonus_MemberRow.value)
                new_concealment_bonus_value = original_concealment_bonus_value + additional_concealment_bonus
                concealment_bonus_MemberRow.edit(value=str(new_concealment_bonus_value))
                print(f"+ ndf_parse: {t_gameplay_terrain_name} - ConcealmentBonus {original_concealment_bonus_value} --> {new_concealment_bonus_value}")

                for damage_modifier_MapRow in t_gameplay_terrain_Object.by_member("DamageModifierPerFamilyAndResistance").value:
                    damage_modifier_resistance_family_infantry_MapRow = damage_modifier_MapRow.value[0]
                    original_damage_modifier_value = float(damage_modifier_resistance_family_infantry_MapRow.value)
                    new_damage_modifier_value = max(original_damage_modifier_value - subtracted_damage, 0.01)
                    damage_modifier_resistance_family_infantry_MapRow.edit(value=str(new_damage_modifier_value))
                print(f"+ ndf_parse: {t_gameplay_terrain_name} - DamageModifierPerFamilyAndResistance -{subtracted_damage}")
        
        # replace original row's content with my replacement Object:
        gameplay_terrains_registration_ListRow.edit(value=replacement_object)

    print("+ ndf_parse: Buildings DONE!\n")
    sys.exit(0)
except Exception as err:
    print("+ ndf_parse Error (modify_values.py):", err)
    sys.exit(1) 
