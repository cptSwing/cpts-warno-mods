import sys

WARNO_MODS_FOLDER = sys.argv[1]
NDF_PARSE_SOURCE_MOD_NAME = sys.argv[2]
DEBUG_MODE = sys.argv[3] == "True"

print("Python: WARNO Mods Folder:", WARNO_MODS_FOLDER)
print("Python: ndf_parse Source Mod Name:", NDF_PARSE_SOURCE_MOD_NAME)
print("Python: Debug Mode:", DEBUG_MODE)


sys.exit(0)
