from pathlib import Path

def load_env(path_param=".env"):
    env_vars = {}
    path = Path(path_param)
    if not path.exists():
        raise FileNotFoundError(f"{path} not found")

    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            if "=" in line:
                key, value = line.strip().split("=", 1)
                env_vars[key] = value.strip('"')
    return env_vars
