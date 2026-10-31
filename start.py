from pathlib import Path
import subprocess
import sys

project = Path(__file__).resolve().parent / "lipjani-business" / "start.py"

if not project.is_file():
    print(f"Nuk u gjet nisësi i projektit: {project}")
    input("Shtyp Enter për ta mbyllur...")
    raise SystemExit(1)

raise SystemExit(subprocess.call([sys.executable, str(project)], cwd=str(project.parent)))

