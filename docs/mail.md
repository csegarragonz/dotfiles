# EMail Config

This document is a cheatsheet for email usage with `mutt`.

## Fetching Emails

Fetching emails is done using `mbsync`. To fetch all emails, just run:

```bash
mbsync -a
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

### Changing mailboxes

To change between different mailboxes, press Fn+F2/F3.
