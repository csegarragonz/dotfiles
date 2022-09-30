FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        curl \
        git \
        neovim \
        python3-pip

# Clone the dotfiles repo
RUN git clone \
        -b v0.2.0 \
        https://github.com/csegarragonz/dotfiles ~/dotfiles

# Configure Neovim
COPY --from=dotfiles /neovim/build/bin/nvim /usr/bin/nvim
COPY --from=dotfiles /usr/local/share/nvim /usr/local/share/nvim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p .config/nvim/ \
    && ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim \
    && ln -s ~/dotfiles/nvim/after ~/.config/nvim/ \
    && ln -s ~/dotfiles/nvim/syntax ~/.config/nvim/ \
    && nvim +PlugInstall +qa \
    && nvim +PlugUpdate +qa
