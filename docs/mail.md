# EMail Config

This document is a cheatsheet for email usage with `mutt`.

To-Do:
* Key to rotate through mailboxes in sidebar
* GMail authorization automatic

## Quick Start

To get up and running quickly:

```bash
inv mail.authorize --mailbox=gmail
inv mail.sync
neomutt
inv mai.sync --push
```

## Fetching Emails

Fetching emails is done using `mbsync`. To fetch all emails, just run:

```bash
inv mail.sync [--mailbox <>]
```

to propagate the changes you make locally, you just need to push them:

```bash
inv mail.sync --push [--mailbox <>]
```

## Navigating `mutt`

We use `neomutt` so just type:

```bash
neomutt
```

### Deleting emails

To delete emails, just press `d` over an existing email. This will mark it with
a `D`.

To undo the deletion, navigate to the email holding the SHIFT key.

To commit the deletion (i.e. sync with the server), either close `mutt` or
press the `$` key.

### Opening URLs

More often than not, emails contain URLs. To follow one, do:

```bash
,u

# Will open `urlview`
# Navigate URLs with regular keys
# Press enter to open URL in $BROWSER
```

### Selecting multiple emails to save to the same folder

You can apply a tag to any email in the Inbox using the `t` key.

Once you are done, run `;` + your command of choice (e.g. `s`) to apply the
same command to all tagged emails.

### Changing mailboxes

To change between different mailboxes, press Fn+F2/F3.
