# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/spark/bin
export PATH=$PATH:/usr/local/kafka/bin
export PATH=$PATH:/usr/local/mvn/bin
export PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-linux
export PATH=$PATH:~/bin
export EDITOR=/usr/bin/nvim

# Path to your oh-my-zsh installation.
export ZSH="/$HOME/config_files/zsh/oh-my-zsh"
myZSH="/$HOME/config_files/zsh"

# Jekyll Config
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

ZSH_THEME="mh"

plugins=(
  git
  vi-mode
)

[ -z "$TMUX" ] && export TERM=xterm-256color

source $ZSH/oh-my-zsh.sh
source $myZSH/z.sh

#bindkey "^R" history-incremental-search-backward

# Aliases
alias ll="ls -la"
alias vi="nvim"
alias vim="nvim"
alias mqt-tz="/home/cse/Work/CSEM/ARM-TZ/mqtt-tz/code/mosquitto/src/mosquitto"
alias kill-docker-containers="docker ps -q -a | xargs docker rm"
alias texSpell="hunspell -l -t -i utf-8"
alias cdl="cd $(ls -lart | tail -2 | head -1 | awk '{print $9}')"
