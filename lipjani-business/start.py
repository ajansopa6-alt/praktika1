from __future__ import annotations

import os
import re
import socket
import subprocess
import sys
import time
import webbrowser
from pathlib import Path

ROOT = Path(__file__).resolve().parent
XAMPP = Path(os.environ.get("XAMPP_HOME", r"C:\xampp"))
HOST = "127.0.0.1"
PORTS = range(8000, 8010)


def fail(message: str) -> None:
    print(f"\nGabim: {message}")
    input("\nShtyp Enter për ta mbyllur...")
    raise SystemExit(1)


def wait_for_mysql(process: subprocess.Popen | None) -> bool:
    for _ in range(45):
        if process is not None and process.poll() is not None:
            return False
        try:
            with socket.create_connection((HOST, 3306), timeout=1):
                return True
        except OSError:
            time.sleep(1)
    return False


def config_values() -> dict[str, str]:
    config = ROOT / "config.php"
    example = ROOT / "config.example.php"
    if not config.exists():
        config.write_text(example.read_text(encoding="utf-8"), encoding="utf-8")
        print("U krijua config.php me cilësimet fillestare të XAMPP-it.")
    source = config.read_text(encoding="utf-8")
    values = {}
    for key in ("db_host", "db_name", "db_user", "db_pass"):
        match = re.search(r"['\"]" + key + r"['\"]\s*=>\s*['\"]([^'\"]*)['\"]", source)
        if not match:
            fail("Nuk arrita t'i lexoj cilësimet e databazës nga config.php.")
        values[key] = match.group(1)
    return values


def main() -> None:
    php = XAMPP / "php" / "php.exe"
    mysql = XAMPP / "mysql" / "bin" / "mysql.exe"
    mysqld = XAMPP / "mysql" / "bin" / "mysqld.exe"
    my_ini = XAMPP / "mysql" / "bin" / "my.ini"
    if not all(path.exists() for path in (php, mysql, mysqld, my_ini)):
        fail(f"Nuk e gjeta XAMPP-in te {XAMPP}. Cakto variablën XAMPP_HOME nëse është instaluar diku tjetër.")
    modules = subprocess.run([str(php), "-m"], capture_output=True, text=True)
    if "pdo_mysql" not in modules.stdout.lower():
        fail("XAMPP PHP nuk e ka aktiv PDO MySQL. Kontrollo php.ini dhe aktivizo extension=pdo_mysql.")

    mysql_process = None
    if not wait_for_mysql(None):
        flags = getattr(subprocess, "CREATE_NO_WINDOW", 0)
        mysql_process = subprocess.Popen(
            [str(mysqld), f"--defaults-file={my_ini}", "--standalone"],
            cwd=XAMPP,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            creationflags=flags,
        )
        if not wait_for_mysql(mysql_process):
            fail("MySQL nuk u nis. Kontrollo nëse porti 3306 është i zënë ose nise MySQL nga XAMPP Control Panel.")

    cfg = config_values()
    schema = (ROOT / "database" / "schema.sql").read_text(encoding="utf-8")
    schema += "\n" + (ROOT / "database" / "seed_businesses.sql").read_text(encoding="utf-8")
    command = [str(mysql), "--default-character-set=utf8mb4", "-h", cfg["db_host"], "-u", cfg["db_user"]]
    if cfg["db_pass"]:
        command.append("--password=" + cfg["db_pass"])
    imported = subprocess.run(command, input=schema, text=True, encoding="utf-8", capture_output=True, cwd=XAMPP)
    if imported.returncode:
        fail("Nuk u lidh databaza. Kontrollo përdoruesin/fjalëkalimin te config.php.\n" + imported.stderr.strip())

    initialized = subprocess.run([str(php), str(ROOT / "install.php")], capture_output=True, text=True, cwd=ROOT)
    if initialized.returncode:
        fail("Nuk u krijua llogaria e administratorit.\n" + initialized.stderr.strip())
    print(initialized.stdout.strip())

    port = next((p for p in PORTS if port_available(p)), None)
    if port is None:
        fail("Portet 8000–8009 janë të zëna. Mbylli programet që i përdorin dhe provo përsëri.")
    server = subprocess.Popen(
        [str(php), "-S", f"{HOST}:{port}", "-t", str(ROOT)],
        cwd=ROOT,
    )
    url = f"http://{HOST}:{port}"
    print(f"Projekti është hapur te {url}")
    print("Mbaje këtë dritare hapur. Shtyp Ctrl+C për ta ndalur serverin PHP.")
    time.sleep(1.5)
    webbrowser.open(url)
    try:
        server.wait()
    except KeyboardInterrupt:
        print("\nDuke ndalur serverin...")
        server.terminate()
        server.wait(timeout=5)
    finally:
        if mysql_process is not None and mysql_process.poll() is None:
            mysql_process.terminate()
            try:
                mysql_process.wait(timeout=8)
            except subprocess.TimeoutExpired:
                mysql_process.kill()


def port_available(port: int) -> bool:
    with socket.socket() as sock:
        return sock.connect_ex((HOST, port)) != 0


if __name__ == "__main__":
    main()

