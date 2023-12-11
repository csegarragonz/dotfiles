from invoke import Collection

from . import docker
from . import dotfiles
from . import mail
from . import mutt

ns = Collection(
    docker,
    dotfiles,
    mail,
    mutt,
)
