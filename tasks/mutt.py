from invoke import task
from tasks.util.install import install_from_ctr


@task
def install(ctx):
    """
    Install the (neo)mutt email client
    """
    extra_files = [{"guest_path": "/neomutt/docs/neomuttrc", "host_path": "/etc/neomuttrc"}]
    install_from_ctr("/neomutt/neomutt", extra_files=extra_files)
