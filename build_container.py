import sys
from os.path import join
from subprocess import run

def get_version():
    with open("VERSION", "r") as fh:
        version = fh.read()
        version = version.strip()
    return version

def build(target):
    version = get_version()
    cmd = [
        "docker",
        "build",
        f"-t csg-workon/{target}:{version}",
        f"-f docker/csg-workon-{target}.dockerfile",
        ".",
    ]
    cmd = " ".join(cmd)
    print(cmd)
    run(cmd, shell=True, check=True)

if __name__ == "__main__":
    argc = len(sys.argv)
    if argc == 1:
        print("Must provide a valid target")
        exit(1)
    else:
        target = sys.argv[1]
        print(f"Building docker image with target {target}")
    build(target)
