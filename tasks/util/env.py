from os.path import dirname, expanduser, join, realpath

PROJ_ROOT = dirname(dirname(dirname(realpath(__file__))))
MAIL_ROOT = join(PROJ_ROOT, "mail")
MUTT_ROOT = join(MAIL_ROOT, "mutt")
KHARD_ROOT = join(MAIL_ROOT, "khard")
HOST_BIN_DIR = "/usr/bin"

CONFIG_HOME = expanduser("~/.config")
MUTT_CONFIG_DIR = join(CONFIG_HOME, "mutt")
KHARD_CONFIG_DIR = join(CONFIG_HOME, "khard")
KHARD_CONTACT_HOME = join(expanduser("~"), ".contacts")
KHARD_CONTACT_DIRS = [
    join(KHARD_CONTACT_HOME, "imperial"),
]


def get_version():
    with open(join(PROJ_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version


DOTFILES_CTR_NAME = "dotfiles-workon"
DOTFILES_CTR_IMAGE = "csegarragonz/dotfiles:{}".format(get_version())
