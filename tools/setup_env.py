import os
from pathlib import Path

ENV_FILE = Path(".env")

def prompt_path(prompt_text):
    while True:
        path = input(f"{prompt_text}: ").strip().strip('"')

        if not path:
            print("Path cannot be empty.")
            continue

        p = Path(path)

        if not p.exists():
            print("Path does not exist. Please try again.")
            continue

        return str(p.resolve())


def write_env(warno_mods_folder, my_warno_mod_name):
    with open(ENV_FILE, "w", encoding="utf-8") as f:
        f.write(f'WARNO_MODS_FOLDER="{warno_mods_folder}"\n')
        f.write(f'MY_WARNO_MOD_NAME="{my_warno_mod_name}"\n')

    print(f"\nSaved to {ENV_FILE.resolve()}")


def main():
    print("=== WARNO Environment Setup ===\n")

    warno_mods_folder = prompt_path("Enter WARNO Mods Folder path (.../steamapps/common/WARNO/Mods")
    my_warno_mod_name = prompt_path("Enter My WARNO Mod name (name of directory)")

    write_env(warno_mods_folder, my_warno_mod_name)


if __name__ == "__main__":
    main()
