import sys

# ndf_parse can't currently parse `unnamed TGameplayTerrainsRegistration( Terrains = [ TGameplayTerrain(), TGameplayTerrain(), TGameplayTerrain() ] )` as far as I can tell, so I need to extract the list of `TGameplayTerrain()`'s from a string :/
def extract(text) -> str | None:
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
