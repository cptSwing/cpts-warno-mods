import sys
import ndf_parse as ndf

source_mod_folder = sys.argv[1]
destination_mod_folder = sys.argv[2]
debug_mode = sys.argv[3] == "ON"

additional_concealment_bonus = 0.25
subtracted_damage = 0.05

# ndf_parse can't currently parse `unnamed TGameplayTerrainsRegistration( Terrains = [ TGameplayTerrain(), TGameplayTerrain(), TGameplayTerrain() ] )` as far as I can tell, so I need to extract the list of `TGameplayTerrain()`'s from a string :/
def extract_terrains_list(text) -> str | None:
    key = "TGameplayTerrainsRegistration"
    start = text.find(key)
    if start == -1:
        return None

    start = text.find('(', start)
    if start == -1:
        return None

    bracket_count = 0
    for i in range(start, len(text)):
        if text[i] == '(':
            bracket_count += 1
        elif text[i] == ')':
            bracket_count -= 1
            if bracket_count == 0:
                #  returns W/OUT the outer brackets:
                return text[start + 1:i]

    return None


try: 
    mod = ndf.Mod(source_mod_folder, destination_mod_folder)

    replacement_object = ndf.model.Object(type='unnamed TGameplayTerrainsRegistration')

    print("\n+ ndf_parse: Modifying Building Concealment & DamageModifiers")
    with mod.edit(r"GameData/Gameplay/Terrains/Terrains.ndf", not debug_mode) as root_List:
        gameplay_terrains_registration_ListRow = root_List[0]

        # convert ndf string to ndf parse object I can iterate over
        terrains_List = extract_terrains_list(gameplay_terrains_registration_ListRow.value)
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
                    new_damage_modifier_value = original_damage_modifier_value - subtracted_damage
                    damage_modifier_resistance_family_infantry_MapRow.edit(value=str(new_damage_modifier_value))
                print(f"+ ndf_parse: {t_gameplay_terrain_name} - DamageModifierPerFamilyAndResistance -{subtracted_damage}")
        
        gameplay_terrains_registration_ListRow.edit(value=replacement_object)

    print("+ ndf_parse: Buildings DONE!\n")
    sys.exit(0)
except Exception as err:
    print("+ ndf_parse Error (modify_values.py):", err)
    sys.exit(1) 
