from invoke import Collection

from . import docker
from . import mail
from . import mutt

ns = Collection(
    docker,
    mail,
    mutt,
)
