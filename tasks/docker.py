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
WAVM_ROOT = "/home/csegarra/sof/WAVM"


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


def get_wavm_version():
    with open(join(WAVM_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


def get_dotfiles_version():
    with open(join(PROJ_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


@task
def build(ctx, target, version=None, nocache=False, push=False):
    """
    Build work-on container: inv docker.build <container> [code-version]
    """
    extra_arg = []
    if target == "faasm" or target == "faasm-sgx":
        _version = version if version else get_faasm_version()
        base_name = "cli" if "sgx" not in target else "faasm-sgx-sim"
        source_dir = "/usr/local/code/faasm"
    elif target == "faabric":
        _version = version if version else get_faabric_version()
        base_name = target
        source_dir = "/code/faabric"
    elif target == "wasm":
        _version = version if version else get_wavm_version()
        extra_arg = "--build-arg WAVM_VERSION={}".format(_version)
        # Force re-building everytime the last two steps
    else:
        _version = get_dotfiles_version()
    extra_arg.append("--build-arg IMAGE_BASE_NAME={}".format(base_name))
    extra_arg.append("--build-arg IMAGE_SOURCE_DIR={}".format(source_dir))
    extra_arg.append("--build-arg IMAGE_VERSION={}".format(_version))
    extra_arg.append(" --build-arg DOTFILES_VERSION={}".format(get_dotfiles_version()))

    tag = "csegarragonz/{}:{}".format(target, _version)
    cmd = [
        "docker",
        "build",
        "--no-cache" if nocache else "",
        "-t {}".format(tag),
        "-f {}/csg-workon-faasm.dockerfile".format(DOCKER_ROOT),
        " ".join(extra_arg),
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
    ALL_TARGETS = ["base", "faasm", "web", "faasm-sgx", "faabric"]
    print("Building all targets: {}".format(ALL_TARGETS))
    for target in ALL_TARGETS:
        build(target)
