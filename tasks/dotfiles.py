from invoke import task
from os.path import dirname, exists, expanduser, join
from subprocess import run
from sys import exit
from tasks.util.env import DOTFILES_CTR_IMAGE, DOTFILES_CTR_NAME, PROJ_ROOT
from tasks.util.install import start_ctr, stop_ctr


def copy_from_dotfiles_image(ctr_paths, host_paths, requires_sudo=False):
    tmp_ctr_name = "tmp-build-ctr"
    result = run(
        f"docker create --name {tmp_ctr_name} {DOTFILES_CTR_IMAGE}",
        shell=True,
        capture_output=True,
    )
    assert result.returncode == 0, print(result.stderr.decode("utf-8").strip())

    def cleanup():
        result = run(f"docker rm -f {tmp_ctr_name}", shell=True, capture_output=True)
        assert result.returncode == 0

    for ctr_path, host_path in zip(ctr_paths, host_paths):
        host_dir = dirname(host_path)
        if not exists(host_dir):
            mkdir = "sudo mkdir" if requires_sudo else "mkdir"
            result = run(f"{mkdir} -p {host_dir}", shell=True, capture_output=True)
            assert result.returncode == 0

        try:
            prefix = "sudo " if requires_sudo else ""
            result = run(
                f"{prefix}docker cp {tmp_ctr_name}:{ctr_path} {host_path}",
                shell=True,
                capture_output=True,
            )
            assert result.returncode == 0
        except AssertionError:
            stderr = result.stderr.decode("utf-8").strip()
            print(f"Error copying {DOTFILES_CTR_IMAGE}:{ctr_path} to {host_path}: {stderr}")
            cleanup()
            raise RuntimeError("Error copying from container!")

    cleanup()


@task
def build(ctx, nocache=False, push=False):
    """
    Build the `dotfiles` docker image
    """
    docker_cmd = "docker build -t {} {} .".format(
        DOTFILES_CTR_IMAGE,
        "--no-cache" if nocache else "",
    )
    run(docker_cmd, shell=True, check=True, cwd=PROJ_ROOT)

    if push:
        run(f"docker push {DOTFILES_CTR_IMAGE}", shell=True, check=True)


@task
def cli(ctx):
    """
    Get a shell into the `dotfiles` image
    """
    docker_cmd = "docker exec -it {} bash".format(DOTFILES_CTR_NAME)
    run(docker_cmd, shell=True, check=True)


@task
def install(ctx, target=None, clean=False):
    """
    Install
    """
    targets = ["bash", "git", "nvim"]
    if target is not None:
        if target in targets:
            targets = [target]
        else:
            print(f"ERROR: unrecognised target: {target}")
            print(f"ERROR: mus be one in: {targets}")
            exit(1)

    for target in targets:
        if target == "bash":
            src_dir = join(PROJ_ROOT, "bash")
            dst_dir = expanduser("~")
            for file in [".bashrc", ".bash_profile", ".bash_aliases"]:
                src_path = join(src_dir, file)
                dst_path = join(dst_dir, file)
                run(f"ln -sf {src_path} {dst_path}", shell=True, check=True)

        if target == "git":
            configs = [
                'user.name "Carlos Segarra"',
                'user.email "carlos@carlossegarra.com"',
                'code.excludesfile {PROJ_ROOT}/git/.gitignore_global',
                'alias.commit "commit -s"',
            ]
            for config in configs:
                run(f"git config --global {config}", shell=True, check=True)

        if target == "nvim":
            if clean:
                run("sudo rm -rf /usr/local/share/nvim", shell=True, check=True)

            copy_from_dotfiles_image(
                ["/neovim/build/bin/nvim", "/usr/local/share/nvim"],
                ["/usr/bin/nvim", "/usr/local/share/nvim"],
                requires_sudo=True,
            )

            nvim_config_dir = expanduser("~/.config/nvim")
            if clean:
                run(f"rm -rf {nvim_config_dir}", shell=True, check=True)

            plug_cmd =  (
                "curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "
                "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
            )
            run(plug_cmd, shell=True, check=True)
            run(f"mkdir -p {nvim_config_dir}", shell=True, check=True)

            nvim_src_dir = join(PROJ_ROOT, "nvim")
            run(f"ln -sf {nvim_src_dir}/init.vim {nvim_config_dir}/init.vim", shell=True, check=True)
            for nvim_target in ["after", "ftdetect", "syntax"]:
                run(f"ln -sf {nvim_src_dir}/{nvim_target} {nvim_config_dir}", shell=True, check=True)


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
