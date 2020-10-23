FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        ctags \
        curl \
        git \
        sudo \
        zsh

# Create a non-root user, and add it to the sudoer group
RUN adduser --disabled-password --gecos '' csegarra
RUN adduser csegarra sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER csegarra
WORKDIR /home/csegarra

# Clone the dotfiles repo
RUN git clone https://github.com/csegarragonz/dotfiles ~/dotfiles

# Install neovim with Python3 support
#RUN sudo apt-add-repository ppa:neovim-ppa/stable
RUN sudo apt-get update
RUN sudo apt-get install -y \
        neovim \
        python3-neovim

# Install vim plug
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Run all the symlinks
RUN mkdir -p ~/.config/nvim
RUN ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
RUN ln -s ~/dotfiles/nvim/after ~/.config/nvim/
RUN ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/
RUN ln -s ~/dotfiles/zsh/.zshrc_container ~/.zshrc
RUN nvim +PlugInstall +qa
RUN nvim +PlugUpdate +qa
ENTRYPOINT ["/bin/zsh"]
