from os.path import basename, join
from subprocess import run
from tasks.util.env import DOTFILES_CTR_IMAGE, DOTFILES_CTR_NAME, HOST_BIN_DIR


def start_ctr():
    docker_cmd = [
        "docker run",
        "-t -d",
        "--name {}".format(DOTFILES_CTR_NAME),
        DOTFILES_CTR_IMAGE,
    ]
    docker_cmd = " ".join(docker_cmd)
    run(docker_cmd, shell=True, check=True)


def stop_ctr():
    run("docker rm -f {}".format(DOTFILES_CTR_NAME), shell=True, check=True)


def install_from_ctr(bin_path, extra_files=None):
    start_ctr()

    host_path = join(HOST_BIN_DIR, basename(bin_path))
    cp_cmd = "sudo docker cp {}:{} {}"
    run(cp_cmd.format(DOTFILES_CTR_NAME, bin_path, host_path), shell=True, check=True)

    if extra_files is not None:
        for extra_file in extra_files:
            guest_path = extra_file["guest_path"]
            host_path = extra_file["host_path"]
            run(cp_cmd.format(DOTFILES_CTR_NAME, guest_path, host_path), shell=True, check=True)

    stop_ctr()

