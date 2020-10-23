FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        curl \
        git \
        neovim \
        python3-neovim \
        python3-pip \
        zsh

# Clone the dotfiles repo
RUN git clone https://github.com/csegarragonz/dotfiles ~/dotfiles

# Install vim plug
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run all the symlinks
RUN mkdir -p ~/.config/nvim
RUN ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
RUN ln -s ~/dotfiles/nvim/after ~/.config/nvim/
RUN ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/
RUN ln -s ~/dotfiles/zsh/.zshrc_container ~/.zshrc
RUN pip3 install black
RUN nvim +PlugInstall +qa
RUN nvim +PlugUpdate +qa
