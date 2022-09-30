ARG FAASM_VERSION
ARG DOTFILES_VERSION
FROM csegarragonz/dotfiles:${DOTFILES_VERSION} as dotfiles
FROM faasm/cli:${FAASM_VERSION}

# Package installation
RUN apt update && apt upgrade -y && apt install -y \
    clangd-13 \
    clang-format-13 \
    clang-tidy-13 \
    gdb \
    git \
    neovim \
    zsh

# Clone the dotfiles repo
ARG DOTFILES_VERSION
RUN git clone \
    -b v${DOTFILES_VERSION} \
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

# Configure Bash
RUN ln -sf ~/dotfiles/bash/.bashrc \
    && ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile \
    && ln -sf ~/dotfiles/bash/.bash_aliases ~/.bash_aliases \
    && echo ". /usr/local/code/faasm/bin/workon.sh" >> ~/.bashrc
