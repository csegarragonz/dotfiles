# -------------------------------------------------------------------------- #
#                   CSG's Dotfiles deploy script.                            #
# Kudos to:                                                                  #
#   - Luke Smith: https://github.com/LukeSmithxyz                            #
# -------------------------------------------------------------------------- #

# TODO:
# Keybindings

## Vars
DOT_DIR=$(pwd)

## ZSH configuration
echo " -------------- zsh Configuration -------------- "
echo " - Checking if zsh is Installed ... "
if ! [ -x "$(command -v zsh)" ]; then
    echo " - Nope. Installing zsh... "
    sudo apt-get install zsh
else
    echo " - Yep. "
fi
echo " - Softlinking (force) the configuration files... "
ln -sf $DOT_DIR/zsh/.zshrc ~/.zshrc
echo " - Updating default shell... "
chsh -s $(which zsh)
echo " -------------- zsh Completed --------------\n\n "

## Neovim configuration
echo " -------------- NeoVim Configuration -------------- "
echo " - Checking if Neovim is Installed ... "
if ! [ -x "$(command -v nvim)" ]; then
    echo " - Nope. Installing Neovim... "
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install neovim
    # Python Support
    pip2 install user neovim
    pip3 install user neovim
    echo " - Also installing VimPlug as plugin manager... "
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo " - Neovim Installed!"
else
    echo " - Yep. "
fi
echo " - Softlinking (force) the configuration files... "
mkdir -p .config/nvim/
ln -sf $DOT_DIR/nvim/init.vim ~/.config/nvim/init.vim
ln -sf $DOT_DIR/nvim/after ~/.config/nvim/
ln -sf $DOT_DIR/nvim/syntax ~/.config/nvim/
echo " - Installing and updating plugins... "
nvim +PlugInstall +qa
nvim +PlugUpdate +qa
echo " -------------- NeoVim Completed --------------\n\n "


## Tmux configuration
echo " -------------- Tmux Configuration -------------- "
echo " - Checking if Tmux is Installed ... "
if ! [ -x "$(command -v tmux)" ]; then
    echo " - Nope. Installing Tmux... "
    sudo apt-get install tmux
else
    echo " - Yep. "
fi
echo " - Softlinking (force) the configuration files... "
ln -s $DOT_DIR/.tmux.conf ~/.tmux.conf
ln -s $DOT_DIR/.tmux ~/.tmux
echo " - Installing tmux plugin manager"
if ! [ -x "$(command -v git)" ]; then
    sudo apt-get install git
fi
ln -sf $DOT_DIR/tmux/tmux.conf ~/.tmux.conf
ln -sf $DOT_DIR/tmux/.tmux ~/.tmux
git clone https://github.com/tmux-plugins/tpm ~/config_files/.tmux/plugins/tpm
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/scripts/install_plugins.sh
echo " -------------- Tmux Completed --------------\n\n "
