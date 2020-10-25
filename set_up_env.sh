#!/bin/bash

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

## Vars
DOT_DIR="$HOME/dotfiles/"
OUT_FILE="${DOT_DIR}/next_steps.txt"

## Helper functions
function nice_log {
    echo "--------------------------------------------------------------------------------"
    echo "\t\t $1"
    echo "--------------------------------------------------------------------------------"
}

function log_and_do {
    echo $1
    $1
}

# TODO update via submodule update init
## If you want to update and do not have git installed you are dumb
#if [[ $* == *--update* ]];
#then
#    if [ -d "~/dotfiles" ];
#    then
#        cd "~/dotfiles"
#        git pull origin master
#        exit 0
#    else
#        echo "Update but no dotfiles dir!"
#        exit 2
#    fi
#fi

## General package installation
nice_log "Install general package dependencies..."
sudo apt update
sudo apt upgrade
sudo apt install -y \
    apt-transport-https \
    ctags \
    curl \
    dmenu \
    git \
    gnupg2 \
    gnupg-agent \
    python-dev \
    pyton-pip \
    python3-dev \
    pyton3-pip \
    software-properties-common \
    ssh \
    sudo \
    tmux \
    wget \
    xsel \
    zsh

## Clone the dotfiles repo
nice_log "Cloning dotfiles repo..."
git clone git@github.com:csegarragonz/dotfiles.git ${DOT_DIR}
git submodule update --init
cd ${DOT_DIR}

## External dependencies (not tracked)
# dmenu - suckless tools
nice_log "Installing suckless tools..."
sudo apt install -y \
    libx11-dev \
    libxft-dev \
    libxinerama1 \
    libxinerama-dev
pushd ${DOT_DIR}/third-party >> /dev/null
wget https://dl.suckless.org/tools/dmenu-5.0.tar.gz
tar -xzvf dmenu-5.0.tar.gz
rm dmenu-5.0.tar.gz; cd dmenu-5.0
sudo make clean install
popd >> /dev/null
# st - suckless terminal
pushd  ${DOT_DIR}/third-party/st/ >> /dev/null
sudo make install
popd >> /dev/null

## Update default shell
chsh -s $(which zsh)
ln -s ${DOT_DIR}/zsh/.zshrc ~/.zshrc
source ~/.zshrc
# TODO need to reboot!

## Git config
# Create ssh public key
nice_log "Create ssh public key"
ssh-keygen -t rsa
# Global Gitignore
nice_log "Git configuration"
git config --global user.name "Carlos Segarra"
git config --global user.email "carlos@carlossegarra.com"
git config --global core.excludesfile ${DOT_DIR}/git/.gitignore_global
echo "Install the new public key in Github"
cat ~/.ssh/id_rsa.pub >> ${OUT_FILE}

## Install Docker
nice_log "Install docker"
sudo apt remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
# Post-installation
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

## Neovim configuration
# Install Neovim
nice_log "Installing neovim...."
sudo apt-get install neovim python3 neovim
# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Setting up nvim
mkdir -p .config/nvim/
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/nvim/after ~/.config/nvim/
ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/
nvim +PlugInstall +qa
nvim +PlugUpdate +qa

## Tmux configuration
nice_log "Setting up tmux..."
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.tmux ~/.tmux

## Gnome changes
nice_log "Setting up gnome specific things..."
sudo apt install gnome-tweaks
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
