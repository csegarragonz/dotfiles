# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/spark/bin
export PATH=$PATH:/usr/local/kafka/bin
export PATH=$PATH:/usr/local/mvn/bin
export PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-linux
export EDITOR=/usr/bin/nvim

# Path to your oh-my-zsh installation.
export ZSH="/$HOME/config_files/zsh/oh-my-zsh"
myZSH="/$HOME/config_files/zsh"

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
alias texSpell="hunspell -l -t -i utf-8"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi="nvim"
alias vim="nvim"
alias kill-docker-containers="docker ps -q -a | xargs docker rm"
alias cdl="cd $(ls -lart | tail -2 | head -1 | awk '{print $9}')"
