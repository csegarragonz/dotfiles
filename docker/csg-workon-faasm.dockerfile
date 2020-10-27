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
        python3-neovim \
        zsh

# Copy relevant files from parent image
COPY --from=0 /root/dotfiles /root/dotfiles
COPY --from=0 /root/.zshrc /root/.zshrc
COPY --from=0 /root/.config/nvim /root/.config/nvim
COPY --from=0 /root/.local/share/nvim /root/.local/share/nvim
COPY --from=0 /root/.vim /root/.vim

# Looks as though we need to reinstall some pythond dependencies
# TODO why?
RUN pip3 install wheel
RUN pip3 install -r faasmcli/requirements.txt

RUN echo 'PS1="%B%{$fg[red]%}[%{$fg[green]%}%B%c%{$fg[red]%}]%{$reset_color%}$%b "' >> ~/.zshrc
RUN echo ". /usr/local/code/faasm/bin/workon.sh" >> ~/.zshrc
