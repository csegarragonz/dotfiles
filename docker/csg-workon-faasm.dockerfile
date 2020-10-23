FROM csg-workon/base:0.1
FROM faasm/cli:0.5.0

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        clang-10 \
        clang-format-10 \
        clang-tidy-10 \
        ctags \
        neovim \
        python-neovim \
        python3-neovim \
        zsh

# Copy relevant files from parent image
COPY ~/dotfiles ~/dotfiles
COPY ~/.zshrc ~/.zshrc
COPY ~/.config/nvim ~/.config/nvim

RUN echo 'PS1="%B%{$fg[red]%}[%{$fg[green]%}%B$(basename $PWD)%{$fg[red]%}]%{$reset_color%}$%b "' >> ~/.zshrc
RUN echo ". /usr/local/code/faasm/bin/workon.sh" >> ~/.zshrc
