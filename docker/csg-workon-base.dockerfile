FROM ubuntu:20.0

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        curl \
        git \
        python3-apt \
        python3-distutils \
        python3-pip \
        python3-venv \
        zsh

# Clone the dotfiles repo
RUN git clone https://github.com/csegarragonz/dotfiles ~/dotfiles

# Install Neovim
WORKDIR ~/dotfiles/nvim/
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN pip3 install black

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
