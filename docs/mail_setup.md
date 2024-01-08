# Email Configuration

TODO:
* Configure calendar (at least viewing and accepting events) for Imperial
* Configure email for Gmail
* Configure calendar for Gmail
* Configure `carlossegarra.com`
* Sign emails with PGP key

In this section we configure our terminal-based email + calendar configuration.
First, you may install all dependencies using:

```bash
inv mail.install-deps

# TODO: remvoe this
sudo apt install -y \
  isync \
  libsasl2-dev \
  sasl2-bin \
  w3m
```

you also want to make sure that your `dotfiles` docker build-on image is up
to date:

```bash
inv dotfiles.build
```

## Configure MBScync

MBSync fetches the emails from the corresponding email server:

```bash
ln -sf ~/dotfiles/mail/mbsync/mbsyncrc ~/.mbsyncrc
```

then, follow the respective instructions to configure different email accounts:
* [outlook](#oauth2-token-for-outlook) - Imperial and other Outlook accounts.
* [google](#oauth2-token-for-gmail) - personal gmail and other google accounts.

Once all the accounts are configured, you can fetch all emails by running:

```bash
inv mail.sync
```

to propagate the changes you make locally, you just need to push them:

```bash
inv mail.sync --push
```

### OAuth2 Token for Outlook

First, you will have to configure an Azure App as indicated [here](
https://www.auronsoftware.com/kb/general/miscellaneous/microsoft-oauth2-how-to-setup-a-client-id-for-use-in-desktop-software/).
If you have already done it, no need to do it again.

As a result, you should be able to authenticate using the provided script:

```bash
inv mail.authorize --mailbox imperial

# Pick
microsoft
devicecode
cs1620@ic.ac.uk
```

you can then test that authentication works by running:

```bash
cd ~/dotfiles/mail/mutt/
./mutt_oauth2.py 'cs1620@ic.ac.uk.tokens' -v -t
```

You should now be able to sync the emails using `mbsync`:

```bash
inv mail.sync --mailbox imperial
```

### OAuth2 Token for GMail

We follow the instructions in [this tutorial](
https://www.redhat.com/sysadmin/mutt-email-oauth2).

To fulfil step 2, we need to get the client ID, client secret, and redirect
URIs for a Google API app. The link to ours is [here](
https://console.cloud.google.com/apis/credentials/oauthclient/427542640905-br4t9k0l997144gu6inked5fet686gir.apps.googleusercontent.com?project=prova-145721) (will require Google log in).

In general, you may follow [these](
https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid)
instructions to get a google API ID.

Then, add this client ID in the `client_id` section in `registrations['google']`
in `./mail/mutt/mutt_oauth2.py`.

Once this is done, you should be able to generate an XOAUTH2 token by running:

```bash
cd ~/dotfiles/mail/mutt/
./mutt_oauth2.py -v -a 'carlossegarragonzalez@gmail.com.tokens'

# Pick
google
authcode
carlossegarragonzalez@gmail.com
```

when you do this, it will ask you to open a page in a browser. In the end,
the access code will be embedded in an error message as follows:

```bash
The webpage at http://localhost:1/?code=4%2F0AfJohXnSYWAye5et8UblfmYottTpV_4yqO2SLwCjX4ScTMGnL9ysSkiMfeV86MMlYa_CuA&scope=https%3A%2F%2Fmail.google.com%2F might be temporarily down or it may have moved permanently to a new web address.
```

the code is the value after the `code=` key, but make sure to replace characters
that have been escaped. In particular the code should start with `4/0A`, so in
the previous example we would have to replace `%2F` by `/` when pasting the
in the terminal.

Then you can test the token with:

```bash
cd ~/dotfiles/mail/mutt/
./mutt_oauth2.py 'carlossegarragonzalez@gmail.com.tokens' -v -t
```

You should now be able to sync the emails using `mbsync`:

```bash
mbsync gmail
```

## Mutt

Mutt is the mail viewer:

```bash
mkdir -p ~/.config/mutt
ln -sf ~/dotfiles/mail/mutt/muttrc ~/.config/mutt/muttrc
ln -sf ~/dotfiles/mail/mutt/muttrc.imperial ~/.config/mutt/muttrc.imperial
ln -sf ~/dotfiles/mail/mutt/muttrc.gmail ~/.config/mutt/muttrc.gmail
ln -sf ~/dotfiles/mail/mutt/mailcap ~/.config/mutt/mailcap
```

## Khard

Khard keeps track of the contacts/address book:

```bash
mkdir -p ~/.config/khard
mkdir -p ~/.contacts/imperial
ln -sf ~/dotfiles/mail/khard/khard.conf ~/.config/khard/khard.conf
```

when on `mutt`, you can add the sender of an email to your address book by
typing `A`.

## Calcurse

Calcurse is a terminal-based calendar.

```bash
mkdir -p ~/.config/calcurse/caldav
mkdir -p ~/.local/share/calcurse/caldav
ln -sf ~/dotfiles/mail/calcurse/caldav.config ~/.config/calcurse/caldav/config
```
