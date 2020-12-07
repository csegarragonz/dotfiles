#!/usr/bin/python3

import sys
from os.path import join
from subprocess import run

def get_faasm_version():
    with open("/home/csegarra/faasm/VERSION", "r") as fh:
        version = fh.read()
        version = version.strip()
    return version

def get_version():
    with open("VERSION", "r") as fh:
        version = fh.read()
        version = version.strip()
    return version

def build(target, no_cache=False):
    if target in ["faasm", "faabric"]:
        version = get_faasm_version()
        extra_arg = "--build-arg FAASM_VERSION={}".format(version)
    else:
        version = get_version()
        extra_arg = ""
    cmd = [
        "docker",
        "build",
        "--no-cache",
        f"-t csg-workon/{target}:{version}",
        f"-f csg-workon-{target}.dockerfile",
        f"{extra_arg}",
        ".",
    ]
    cmd = " ".join(cmd)
    print(cmd)
    run(cmd, shell=True, check=True)

def build_all():
    ALL_TARGETS = ["base", "faasm", "web"]
    print("Building all targets: {}".format(ALL_TARGETS))
    for target in ALL_TARGETS:
        build(target)

if __name__ == "__main__":
    argc = len(sys.argv)
    if argc == 1:
        print("Usage:")
        print("./build_container.py <target_name>")
        print("Where target: all, base, faasm, web")
        exit(1)
    else:
        target = sys.argv[1]
        print(f"Building docker image with target {target}")
    build(target)
