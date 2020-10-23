### CSG Environment Set Up Script
# TODO:
# 1. Add keys to the full installation
# 2. Add other packages to the full installation
# 3. Order apt-installs lexicographically
# 4. Include zsh configuration
# 5. Can I add my key remaps here?
# - Next/before/play/pause/volume
# - CAPS LOCK -> Ctrl
# 6. Choose default terminal emulator
# 7. If directory already exists, pull
# 8. Add server mode

# Check if full installation
if [[ $* == *--full* ]];
then
    sudo apt update
    sudo apt upgrade -y
    sudo apt install \
        chromium-browser \
        xsel
fi

## If you want to update and do not have git installed you are dumb
if [[ $* == *--update* ]];
then
    if [ -d "~/dotfiles" ];
    then
        cd "~/dotfiles"
        git pull origin master
        exit 0
    else
        echo "Update but no dotfiles dir!"
        exit 2
    fi
fi

## General package installation
sudo apt-get update
sudo apt-get install -y \
    ctags \
    curl \
    git \
    python-dev \
    pyton-pip \
    python3-dev \
    pyton3-pip \
    ssh \
    sudo \
    tmux \
    zsh

## Update default shell
chsh -s $(which zsh)
# TODO link zsh things
# TODO need to reboot!

## Link .profile file
ln -s ~/dotfiles/.profile ~/.profile

## Global Gitignore
git config --global core.excludesfile ~/dotfiles/git/.gitignore_global

## Install Docker
# TODO installation steps
# Post-installation
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

## Neovim configuration
# Install Neovim
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
# Installl Neovim with python support
sudo apt-get install
pip3 install user neovim
pip3 install user neovim
# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clone the repo with the config files
cd ~
git clone git@github.com:csegarragonz/dotfiles.git

# Setting up nvim
mkdir -p .config/nvim/
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/nvim/after ~/.config/nvim/
ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/
nvim +PlugInstall +qa
nvim +PlugUpdate +qa

# Tmux configuration
 Setting up tmux
if [ -f '~/.tmux.conf'];
then
    echo "There already exists a tmux configuration file. Replace it?"
    # TODO: ask Y/N
else
    ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
    ln -s ~/dotfiles/.tmux ~/.tmux
    # Install TPM and the plugins contained in the conf file
    git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
fi

## Set up Suckless Terminal
sudo apt install libxft-dev libx11-dev
# Change dir TODO
git clone git@github.com:csegarragonz/st.git
cd st
sudo make install

## Gnome changes
# Disable the annoying notifications on the top bar
gnome-extensions disable ubuntu-appindicators@ubuntu.com
# Force alt+tab to switch only in current workspace
gsettings set org.gnome.shell.app-switcher current-workspace-only true

## Gnome Shell Extensions (use on Chrome!, chromium does not work)
# Install connector

## Custom Shortcuts (Insert Manually)
# TODO add echo and such
# Spotify
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous

### Key Configuration
## Quick way back home
#ssh-keygen -t rsa
#ssh-copy-id carlos@carlossegarra.com
#scp carlos@carlossegarra.com:csg_bup_files/config ~/.ssh/
#echo "Host csg-paris\n    HostName 164.172.155.43\n    User csg-paris" >> ~/.ssh/config

## To set up your password store
# ssh csg-paris
# gpg2 --export-secret-keys carlos@carlossegarra.com > pkey.asc
# exit
# cd ~
# mkdir .password-store
# scp csg-paris:pkey.asc .
# gpg2 --import pkey.asc
# rm pkey.asc
# git init
# git remote add origin csg-paris:git/keys/
# git pull origin master
