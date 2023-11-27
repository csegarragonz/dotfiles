from os.path import dirname, join, realpath

PROJ_ROOT = dirname(dirname(dirname(realpath(__file__))))
MAIL_ROOT = join(PROJ_ROOT, "mail")
MUTT_ROOT = join(MAIL_ROOT, "mutt")
HOST_BIN_DIR = "/usr/bin"


def get_version():
    with open(join(PROJ_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


DOTFILES_CTR_NAME = "dotfiles-workon"
DOTFILES_CTR_IMAGE = "csegarragonz/dotfiles:{}".format(get_version())
