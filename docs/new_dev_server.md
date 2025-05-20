# Instructions to set up new machine

Before you start, update and upgrade:

```bash
sudo apt update && sudo apt upgrade -y
```

## Dev. environment set-up

Clone this repository and build the dotfiles image:

```
export DOTFILES_DIR=<path>

sudo apt install -y git
git clone https://github.com/csegarragonz/dotfiles ${DOTFILES_DIR}
cd ${DOTFILES_DIR}

source ./bin/workon.sh
inv dotfiles.build
```

then you may install all dependencies using:

```
inv dotfiles.install [--clean]
```

or a specific one with:

```bash
inv dotfiles.install --target [bash,git,nvim,tmux]
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

## Configure `pass` password store

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
git remote add origin csg-paris:csg-pass
git pull origin master
```
