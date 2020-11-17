## -------------------------------------------------------------------------- #
##                           CSG's zsh config file.
## Kudos to:
##   - Luke Smith: https://github.com/LukeSmithxyz
## -------------------------------------------------------------------------- #

## Some exports
export TERM="st"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-linux
export PATH=$PATH:~/bin
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;32:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

ZSH_HOME="$HOME/dotfiles/zsh"

## Aliases
# General
alias vi="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"
alias ls="ls --color=auto"
alias ll="ls -la"
alias ..="cd .."
# Naviagtion
alias pwdc="pwd | tr -d '\n' | xsel --clipboard"
alias faasm="cd /home/csegarra/faasm"
alias faabric="cd /home/csegarra/faabric"
alias exp="cd /home/csegarra/faasm-experiments"
# Git tooling
alias git-wip-all="git add -A && git commit -m 'wip' && git push origin master"
function git-commit-all () {
    git add -A && git commit -m "$1" && git push origin $2
}
# TODO automatize
alias workon-faasm="cd /home/csegarra/faasm/; ./bin/cli.sh csg-workon/faasm:0.1"
alias workon-faabric="cd /home/csegarra/faabric/; ./bin/cli.sh csg-workon/faabric:0.1"

# List Directory at every CD
function chpwd() {
    emulate -L zsh
    ls -la
}

[ -z "$TMUX" ] && export TERM=xterm-256color

# Prompt Colors
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%B%c%{$fg[red]%}]%{$reset_color%}$%b "
## prompt
##PROMPT='[%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[yellow]%}%B%30<...<%~%<<%{$reset_color%}]%b%(!.#.$) '
#RPROMPT='$(git_super_status)'
## git theming
#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}(%{$fg_no_bold[yellow]%}%B"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%})%{$reset_color%} "
#ZSH_THEME_GIT_PROMPT_CLEAN=""
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"
#
## History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
# Zsh to use the same colors as ls
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# VI Mode Configuration
bindkey -v
export KEYTIMEOUT=1
# Use vi navigation keys to move around the menuselect
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap 
    echo -ne "\e[5 q"
}
zle -N zle-line-init
# Use beam shape cursor on startup.
echo -ne '\e[5 q' 
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;} 
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

function up_widget() {
		BUFFER="cd .."
		zle accept-line
	}
zle -N up_widget
bindkey "^k" up_widget

# TODO move from here
setxkbmap -layout us -option ctrl:nocaps

# Source Plugins
source $ZSH_HOME/z.sh
source $ZSH_HOME/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null
#zprof
