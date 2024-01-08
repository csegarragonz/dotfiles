from invoke import task
from os import makedirs
from os.path import exists, join
from subprocess import run
from tasks.util.env import (
    KHARD_CONFIG_DIR,
    KHARD_CONTACT_DIRS,
    KHARD_CONTACT_HOME,
    KHARD_ROOT,
    MUTT_CONFIG_DIR,
    MUTT_ROOT,
)
from tasks.util.install import install_from_ctr


@task
def install(ctx):
    """
    Install the (neo)mutt email client
    """
    extra_files = [{"guest_path": "/neomutt/docs/neomuttrc", "host_path": "/etc/neomuttrc"}]
    install_from_ctr("/neomutt/neomutt", extra_files=extra_files)

    # Soft-link
    if not exists(MUTT_CONFIG_DIR):
        makedirs(MUTT_CONFIG_DIR)

    files_to_link = [
        "muttrc",
        "muttrc.colors",
        "mailcap",
        "muttrc.sidebar",
        "muttrc.imperial",
        "muttrc.ionos",
        "muttrc.gmail",
    ]

    for file in files_to_link:
        src_path = join(MUTT_ROOT, file)
        dst_path = join(MUTT_CONFIG_DIR, file)
        ln_cmd = "ln -sf {} {}".format(src_path, dst_path)
        run(ln_cmd, shell=True, check=True)

    # Also configure Khard
    if not exists(KHARD_CONFIG_DIR):
        makedirs(KHARD_CONFIG_DIR)

    ln_cmd = "ln -sf {} {}".format(join(KHARD_ROOT, "khard.conf"), join(KHARD_CONFIG_DIR, "khard.conf"))
    run(ln_cmd, shell=True, check=True)

    if not exists(KHARD_CONTACT_HOME):
        makedirs(KHARD_CONTACT_HOME)

    for contact_dir in KHARD_CONTACT_DIRS:
        if not exists(contact_dir):
            makedirs(contact_dir)
