ARG FAABRIC_VERSION
FROM csegarragonz/base:0.1

FROM faasm/faabric:${FAABRIC_VERSION}

RUN apt-get update && apt-get upgrade -y

# Package installation
RUN apt-get install -y \
        clangd-10 \
        clang-format-10 \
        clang-tidy-10 \
        ctags \
        gdb \
        neovim \
        zsh

# Copy relevant files from parent image
COPY --from=0 /root/dotfiles /root/dotfiles
COPY --from=0 /root/.zshrc /root/.zshrc
COPY --from=0 /root/.bashrc /root/.bashrc
COPY --from=0 /root/.config/nvim /root/.config/nvim
COPY --from=0 /root/.local/share/nvim /root/.local/share/nvim
COPY --from=0 /root/.vim /root/.vim

RUN apt remove -y python3-greenlet
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade --force-reinstall neovim
RUN pip3 install python-language-server[all]

# Overwrite nvim config file with local version
ARG DATE
COPY ./nvim/init.vim /root/dotfiles/nvim/

RUN echo 'PS1="%B%{$fg[red]%}[%{$fg[green]%}%B%c%{$fg[red]%}]%{$reset_color%}$%b "' >> ~/.zshrc
RUN echo ". /code/faabric/bin/workon.sh" >> ~/.zshrc
