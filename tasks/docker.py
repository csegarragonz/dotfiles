#!/usr/bin/python3
from invoke import task
import time
import sys
from os.path import dirname, realpath, join
from subprocess import run

PROJ_ROOT = dirname(dirname(realpath(__file__)))
DOCKER_ROOT = join(PROJ_ROOT, "docker")
FAASM_ROOT = "/home/csegarra/faasm"
FAABRIC_ROOT = join(FAASM_ROOT, "faabric")


def get_faasm_version():
    with open(join(FAASM_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


def get_faabric_version():
    with open(join(FAABRIC_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


def get_version():
    with open(join(PROJ_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


@task
def build(target, nocache=False, push=False):
    """
    Build work-on container
    """
    if target == "faasm":
        version = get_faasm_version()
        extra_arg = "--build-arg FAASM_VERSION={}".format(version)
        # Force re-building everytime the last two steps
        extra_arg += " --build-arg DATE={}".format(time.time())
    elif target == "faabric":
        version = get_faabric_version()
        extra_arg = "--build-arg FAABRIC_VERSION={}".format(version)
    else:
        version = get_version()
        extra_arg = ""

    tag = "csegarragonz/{}:{}".format(target, version)
    cmd = [
        "docker",
        "build",
        "--no-cache" if nocache else "",
        "-t {}".format(tag),
        "-f {}/csg-workon-{}.dockerfile".format(DOCKER_ROOT, target),
        "{}".format(extra_arg),
        ".",
    ]

    cmd = " ".join(cmd)
    print(cmd)
    run(cmd, shell=True, check=True)

    if push:
        run("docker push {}".format(tag), shell=True, check=True)


@task
def build_all(nocache=False, push=False):
    """
    Build all work-on containers
    """
    ALL_TARGETS = ["base", "faasm", "web"]
    print("Building all targets: {}".format(ALL_TARGETS))
    for target in ALL_TARGETS:
        build(target)
