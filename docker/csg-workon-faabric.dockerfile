FROM csg-workon/base:0.1

FROM faasm/faabric-cli:0.0.13

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        clang-10 \
        clang-format-10 \
        clang-tidy-10 \
        ctags \
        neovim \
        python3-neovim \
        zsh

# Copy relevant files from parent image
COPY --from=0 /root/dotfiles /root/dotfiles
COPY --from=0 /root/.zshrc /root/.zshrc
COPY --from=0 /root/.config/nvim /root/.config/nvim
COPY --from=0 /root/.local/share/nvim /root/.local/share/nvim
COPY --from=0 /root/.vim /root/.vim

RUN echo 'alias faasm="cd /usr/local/code/faasm"' >> ~/.zshrc
RUN echo 'alias exp="cd /usr/local/code/faasm-experiments"' >> ~/.zshrc
RUN echo 'PS1="%B%{$fg[red]%}[%{$fg[green]%}%B%c%{$fg[red]%}]%{$reset_color%}$%b "' >> ~/.zshrc
RUN echo ". /code/faabric/bin/workon.sh" >> ~/.zshrc
