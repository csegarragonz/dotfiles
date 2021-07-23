#!/bin/bash

mkdir -p ~/.config/nvim

sudo apt update && sudo apt upgrade -y
sudo apt-get install -y \
    neovim \
    python3-neovim \
    python3-pip \
pip3 install --user pynvim
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

