export EDITOR=/usr/bin/vim

# Prompt Colors
#export PS1="\[\033[38;5;160m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
test -s ~/.alias && . ~/.alias || true

#Alias
# Server Logins
alias loginCarlos='ssh carlos@163.172.155.43'
# Useful Scripts

alias wxparaver="~/sof/wxparaver-4.7.2-Linux_x86_64/bin/wxparaver"
alias loginMN="ssh -X bsc19685@mn3.bsc.es"
alias ..="cd .."
alias ll="ls --color=auto -lah"
alias ls="ls --color=auto"
alias diskspace="du -S | sort -n -r | more"
alias goDBSCAN="cd ~/DBSCAN/"

#Exctracting script
extract () {
    if [ -f $1  ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Enable Bash Completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
