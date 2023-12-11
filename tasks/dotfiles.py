from invoke import task
from subprocess import run
from tasks.util.env import DOTFILES_CTR_IMAGE, DOTFILES_CTR_NAME, PROJ_ROOT
from tasks.util.install import start_ctr, stop_ctr


@task
def build(ctx, nocache=False):
    """
    Build the `dotfiles` docker image
    """
    docker_cmd = "docker build -t {} {} .".format(
        DOTFILES_CTR_IMAGE,
        "--no-cache" if nocache else "",
    )
    run(docker_cmd, shell=True, check=True, cwd=PROJ_ROOT)


@task
def cli(ctx):
    """
    Get a shell into the `dotfiles` image
    """
    docker_cmd = "docker exec -it {} bash".format(DOTFILES_CTR_NAME)
    run(docker_cmd, shell=True, check=True)


@task
def start(ctx):
    """
    Run the `dotfiles` container in the background
    """
    start_ctr()


@task
def stop(ctx):
    """
    Stop running the `dotfiles` container in the background
    """
    stop_ctr()
