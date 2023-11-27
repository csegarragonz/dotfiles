## Instructions to set up new machine

Before you start, update and upgrade:

```bash
sudo apt update && sudo apt upgrade -y
```

### Manual configuration of Ubuntu

TODO

### Extra Ubuntu Tweaks that need a shell

Switch to a workspace directly by number:

```bash
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['<Primary><Alt>1']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-2 "['<Primary><Alt>2']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-3 "['<Primary><Alt>3']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-4 "['<Primary><Alt>4']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Primary><Alt>5']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-6 "['<Primary><Alt>6']"
```


### Get the dotfiles repo

```
sudo apt install -y git
git clone https://github.com/csegarragonz/dotfiles ~/dotfiles
cd ~/dotfiles
```

### Git config

Configure git:

```bash
git config --global user.name "Carlos Segarra"
git config --global user.email "carlos@carlossegarra.com"
git config --global core.excludesfile ~/dotfiles/git/.gitignore_global
```

### Bash configuration

```
ln -sf ~/dotfiles/bash/.bashrc
ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/bash/.bash_aliases ~/.bash_aliases
```

### Docker installation

First, install the package:

```bash
sudo apt install -y
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Lastly, do the post-config steps:

```bash
sudo groupadd docker
sudo usermod -aG $USER
newgrp docker
```

### TMUX installation

```bash
sudo apt install -y tmux
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/dotiles/tmux ~/.tmux
```

### Build dotfiles image

```bash
./build.sh
```

### NVIM Installation

First, run the dorfiles image:

```bash
./run.sh
```

Second, copy the corresponding nvim files:

```bash
sudo docker cp dotfiles:/neovim/build/bin/nvim /usr/bin/nvim
sudo docker cp dotfiles:/usr/local/share/nvim /usr/local/share/nvim
```

Lastly, soft-link the config files and install `vim-plug`:

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p .config/nvim/
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/nvim/after ~/.config/nvim/
ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/
nvim +PlugInstall +qa
nvim +PlugUpdate +qa
```

### ST Installation

First, run the dotfiles image if it's not running:

```bash
./run.sh
```

Second, copy the binary from the image and register the terminal:

```bash
sudo docker cp dotfiles:/st/st /usr/bin/st
sudo docker cp dotfiles:/st/st-copyout /usr/bin/st-copyout
sudo docker cp dotfiles:/st/st-urlhandler /usr/bin/st-urlhandler
docker cp dotfiles:/st/st.info /tmp/st.info
sudo tic -sx /tmp/st.info
```

Third, make `st` the default terminal:

```bash
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/st 50
sudo update-alternatives --config x-terminal-emulator
```

Lastly, for proper emoji support, you will have to install the `fonts-symbola`
package in _all_ servers you access to:

```bash
sudo apt install -y fonts-symbola
```

### Configure `pass` password store

First, configure credentials to access git server:

```bash
ssh-copy-id carlos@carlossegarra.com
echo -e "Host csg-paris\n    HostName 163.172.155.43\n    User carlos\n    IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
```

Second configure the password store:

```
sudo apt install -y gnupg2 pass wl-clipboard
ssh csg-paris
gpg2 --export-secret-keys carlos@carlossegarra.com > pkey.asc
exit
cd ~
mkdir .password-store
scp csg-paris:pkey.asc /tmp
gpg2 --import /tmp/pkey.asc
rm /tmp/pkey.asc
cd ~/.password-store
git init
git remote add origin csg-paris:git/keys/
git pull origin master
```

### Email Configuration

TODO:
* Configure calendar (at least viewing and accepting events) for Imperial
* Configure email for Gmail
* Configure calendar for Gmail
* Configure `carlossegarra.com`
* Sign emails with PGP key

In this section we configure our terminal-based email + calendar configuration.
First, you may install all dependencies using:

```bash
sudo apt install -y \
  isync \
  libsasl2-dev \
  mutt \
  sasl2-bin \
  w3m
```

#### Configure MBScync

MBSync fetches the emails from the corresponding email server:

```bash
ln -sf ~/dotfiles/mail/mbsync/mbsyncrc ~/.mbsyncrc
```

you may need to do some further config to get `XOAUTH2` to work:

```bash
# Copied from:
# https://unix.stackexchange.com/questions/625637/configuring-mbsync-with-authmech-xoauth2
# Clone the Cyrus SASL OAuth2 sources.
git clone https://github.com/moriyoshi/cyrus-sasl-xoauth2.git

# Configure and make.
cd cyrus-sasl-xoauth2
./autogen.sh
./configure

# SASL2 libraries on Ubuntu are in /usr/lib/x86_64-linux-gnu/; modify the Makefile accordingly
sed -i 's%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/sasl2%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/x86_64-linux-gnu/sasl2%' Makefile

make
sudo make install

# Verify XOAUTH2 is known to SASL.
saslpluginviewer | grep XOAUTH2
```

then, follow the respective instructions to configure different email accounts:
* [outlook](#oauth2-token-for-outlook) - Imperial and other Outlook accounts.
* [google](#oauth2-token-for-gmail) - personal gmail and other google accounts.

Once all the accounts are configured, you can fetch all emails by running:

```bash
mbsync -a
```

to propagate the changes you make locally, you just need to push them:

```bash
mbsync -a --push -dfn
```

##### OAuth2 Token for Outlook

First, you will have to configure an Azure App as indicated [here](
https://www.auronsoftware.com/kb/general/miscellaneous/microsoft-oauth2-how-to-setup-a-client-id-for-use-in-desktop-software/).
If you have already done it, no need to do it again.

As a result, you should be able to authenticate using the provided script:

```bash
cd ~/dotfiles/mail/mutt/
./mutt_oauth2.py -v -a 'cs1620@ic.ac.uk.tokens'

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
mbsync imperial
```

##### OAuth2 Token for GMail

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

#### Mutt

Mutt is the mail viewer:

```bash
mkdir -p ~/.config/mutt
ln -sf ~/dotfiles/mail/mutt/muttrc ~/.config/mutt/muttrc
ln -sf ~/dotfiles/mail/mutt/muttrc.imperial ~/.config/mutt/muttrc.imperial
ln -sf ~/dotfiles/mail/mutt/muttrc.gmail ~/.config/mutt/muttrc.gmail
ln -sf ~/dotfiles/mail/mutt/mailcap ~/.config/mutt/mailcap
```

#### Khard

Khard keeps track of the contacts/address book:

```bash
mkdir -p ~/.config/khard
mkdir -p ~/.contacts/imperial
ln -sf ~/dotfiles/mail/khard/khard.conf ~/.config/khard/khard.conf
```

when on `mutt`, you can add the sender of an email to your address book by
typing `A`.

### Clean up

Once you are done, stop the builder docker image:

```bash
docker rm -f dotfiles
```
