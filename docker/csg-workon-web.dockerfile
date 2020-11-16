FROM csg-workon/base:0.1

FROM csg-web/cli:0.1

RUN apt-get update && apt-get upgrade -y

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Package installation
RUN apt-get install -y \
        neovim \
        python3-neovim \
        zsh

# Install Node modules
RUN npm install npx

# Copy relevant files from parent image
COPY --from=0 /root/dotfiles /root/dotfiles
COPY --from=0 /root/.zshrc /root/.zshrc
COPY --from=0 /root/.config/nvim /root/.config/nvim
COPY --from=0 /root/.local/share/nvim /root/.local/share/nvim
COPY --from=0 /root/.vim /root/.vim

RUN echo 'alias faasm="cd /usr/local/code/faasm"' >> ~/.zshrc
RUN echo 'alias exp="cd /usr/local/code/faasm-experiments"' >> ~/.zshrc
RUN echo 'PS1="(web) %B%{$fg[red]%}[%{$fg[green]%}%B%c%{$fg[red]%}]%{$reset_color%}$%b "' >> ~/.zshrc

WORKDIR /web
