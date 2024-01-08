from invoke import task
from os import makedirs
from os.path import exists, join
from subprocess import run
from tasks.util.env import MUTT_ROOT
from tasks.util.mail import MAIL_HOME, MAILBOXES


@task
def install_deps(ctx):
    """
    Install the APT dependencies required to run the local mail set-up
    """
    apt_cmd = [
        "sudo apt install -y",
        "libsasl2-dev",
        "isync",
    ]
    apt_cmd = " ".join(apt_cmd)

    run(apt_cmd, shell=True, check=True)

    # Also configure SASL2 to get XOAUTH2 to work
    workdir = "/tmp/cyrus-sasl-xoauth2"
    git_cmd = "git clone https://github.com/moriyoshi/cyrus-sasl-xoauth2.git {}".format(workdir)
    run(git_cmd, shell=True, check=True)

    build_cmd = "./autogen.sh && ./configure"
    run(build_cmd, shell=True, check=True, cwd=workdir)

    # SASL2 libraries on Ubuntu are in /usr/lib/x86_64-linux-gnu/; modify the Makefile accordingly
    sed_cmd = [
        "sed -i 's%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/sasl2%pkglibdir",
        "= ${CYRUS_SASL_PREFIX}/lib/x86_64-linux-gnu/sasl2%'",
        "Makefile",
    ]
    sed_cmd = " ".join(sed_cmd)
    run(sed_cmd, shell=True, check=True, cwd=workdir)

    make_cmd = "make && sudo make install"
    run(make_cmd, shell=True, check=True, cwd=workdir)

    # Finally, clean-up
    run("rm -rf {}".format(workdir), shell=True, check=True)


@task
def sync(ctx, mailbox=None, push=False):
    """
    Synch with remote mailboxes using `mbsync`
    """
    # By default, sync from all mailboxes but the Gmail one, until we fix the
    # config, and unless otherwise specified
    sync_from = "imperial ionos"
    if mailbox is not None:
        if mailbox in MAILBOXES:
            sync_from = mailbox
        else:
            raise RuntimeError("Unrecognised mailbox: {}. Must be one in: {}".format(mailbox, MAILBOXES))

    if not exists(MAIL_HOME):
        makedirs(MAIL_HOME)

    for mbox in sync_from.split(" "):
        mbox_home = join(MAIL_HOME, mbox)
        if not exists(mbox_home):
            makedirs(mbox_home)

    mbsync_cmd = [
        "mbsync",
        "--push -dfn" if push else "",
        sync_from,
    ]
    mbsync_cmd = " ".join(mbsync_cmd)

    run(mbsync_cmd, shell=True, check=True)


@task
def authorize(ctx, mailbox, test=False):
    """
    Get the XOAUTH2 access token for a mailbox
    """
    # ionos mailbox does not require XOAUTH2 token
    if mailbox not in MAILBOXES:
        raise RuntimeError("Unrecognised mailbox: {}. Must be one in: {}".format(mailbox, MAILBOXES))

    mutt_oauth = join(MUTT_ROOT, "mutt_oauth2.py")
    if mailbox == "gmail":
        token = join(MUTT_ROOT, "carlossegarragonzalez@gmail.com.tokens")
    elif mailbox == "imperial":
        token = join(MUTT_ROOT, "cs1620@ic.ac.uk.tokens")

    cmd = [
        mutt_oauth,
        "-v",
        "-t" if test else "-a",
        token,
    ]
    cmd = " ".join(cmd)
    print(cmd)
    run(cmd, shell=True, check=True)
