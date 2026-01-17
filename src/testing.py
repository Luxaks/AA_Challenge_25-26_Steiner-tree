import os
import subprocess

TESTS_ROOT = "../tests/cosmin_tests"
OUTPUT_ROOT = "output"
PROGRAM = "DP_Fuchs.py"

def get_test_info(test_path):
    with open(test_path, "r") as f:
        first_line = f.readline().strip()
        n, k = first_line.split()
        return n, k


for root, dirs, files in os.walk(TESTS_ROOT):
    for file in files:
        test_path = os.path.join(root, file)

        try:
            n, k = get_test_info(test_path)
        except Exception:
            print(f"[SKIP] {test_path} (format invalid)")
            continue

        # numele directorului de test (ex: small, medium, large)
        test_dir_name = os.path.basename(root)

        # director output corespunzator
        output_dir = os.path.join(OUTPUT_ROOT, test_dir_name)
        os.makedirs(output_dir, exist_ok=True)

        test_name = os.path.splitext(file)[0]
        output_file = f"{test_name}_{n}_{k}.txt"
        output_path = os.path.join(output_dir, output_file)

        print(f"[RUN] {test_path} -> {output_path}")

        with open(test_path, "r") as infile, open(output_path, "w") as outfile:
            subprocess.run(
                ["python3", PROGRAM],
                stdin=infile,
                stdout=outfile,
                stderr=subprocess.STDOUT
            )

print("✔️ Toate testele au fost rulate cu succes.")
