import sys
from pathlib import Path
import subprocess

WARNO_MODS_FOLDER = sys.argv[1]
NDF_PARSE_SOURCE_MOD_NAME = sys.argv[2]
MOD_NAME = sys.argv[3]
DEBUG_MODE = sys.argv[4]

parse_script = Path("../../mods") / MOD_NAME / "modify_values.py"
parse_script_abs = parse_script.resolve()
warno_mods_folder_clean = Path(WARNO_MODS_FOLDER) # automatically handles slashes in various OS's
source_mod_folder = warno_mods_folder_clean / NDF_PARSE_SOURCE_MOD_NAME 
destination_mod_folder = warno_mods_folder_clean / MOD_NAME

if DEBUG_MODE == "ON":
    print(f"+ ndf_parse: Debug Mode: {DEBUG_MODE}\n")

try:
    result = subprocess.run(
        ["poetry", "run", "python", parse_script_abs, source_mod_folder, destination_mod_folder, DEBUG_MODE],
        check=True
    )
except Exception as err:
    print("\n+ ndf_parse Error (setup_parsing.py):", err)
    sys.exit(1)
sys.exit(0)
