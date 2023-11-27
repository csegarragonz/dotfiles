from invoke import task
from os.path import join
from subprocess import run
from tasks.util.env import MUTT_ROOT
from tasks.util.mail import MAILBOXES


@task
def sync(ctx, mailbox=None, push=False):
    """
    Synch with remote mailboxes using `mbsync`
    """
    # By default, sync from all mailboxes unless otherwise specified
    sync_from = "-a"
    if mailbox is not None:
        if mailbox in MAILBOXES:
            sync_from = mailbox
        else:
            raise RuntimeError("Unrecognised mailbox: {}. Must be one in: {}".format(mailbox, MAILBOXES))

    mbsync_cmd = [
        "mbsync",
        sync_from,
        "--push -dfn" if push else ""
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
