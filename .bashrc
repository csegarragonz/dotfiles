export EDITOR=/usr/bin/vim

# Prompt Colors
export PS1="\[\033[38;5;160m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]:\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
test -s ~/.alias && . ~/.alias || true

#Alias
# Server Logins
alias loginCarlos='ssh carlos@163.172.155.43'
alias loginNord="ssh -X bsc19685@nord3.bsc.es"
alias loginSSF="ssh -X csegarra@ssflogin.bsc.es"
# Useful Scripts
alias matacompss="~/utils/matacompss"
alias syncGitlab="~/utils/sync_command.sh"
alias wxparaver="~/sof/wxparaver-4.7.2-Linux_x86_64/bin/wxparaver"
alias loginMN="ssh -X bsc19685@mn3.bsc.es"
alias ..="cd .."
alias ll="ls --color=auto -lah"
alias ls="ls --color=auto"
alias diskspace="du -S | sort -n -r | more"
alias goDBSCAN="cd ~/DBSCAN/"

# export JAVA_HOME=/usr/lib64/jvm/java-1.8.0-openjdk/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export COMPSS_HOME=/opt/COMPSs
export MPI_HOME=/usr/lib/openmpi
export LD_LIBRARY_PATH=/usr/lib/openmpi/lib
export PATH=/opt/maven/bin:$PATH
export HDF5_CXX=/usr/bin/mpicxx
export myMN=bsc19685@mn1.bsc.es

#Deploy COMPSs at SC:

#Nord
alias deployNord="pushd ~/svn/compss/framework/trunk/builders/scs/nord/;./buildNord bsc19685 /home/bsc19/bsc19685/tmpCOMPSs/ /gpfs/apps/MN3/COMPSs/Trunk/;popd"
alias deployNordcustom="pushd ~/svn/compss/framework/trunk/builders/scs/nord/;./buildNord bsc19685 /home/bsc19/bsc19685/tmpCOMPSs/ /gpfs/apps/MN3/COMPSs/TrunkCarlos/;popd"

#MN
alias deployMN="pushd ~/svn/compss/framework/trunk/builders/scs/mn/;./buildMN bsc19685 /home/bsc19/bsc19685/tmpCOMPSs/ /gpfs/apps/MN4/COMPSs/Trunk/;popd"
alias deployMNcustom="pushd ~/gitlab/framework/builders/scs/mn/;./buildMN bsc19685 /home/bsc19/bsc19685/tmpCOMPSs/ /gpfs/apps/MN4/COMPSs/TrunkCarlos/;popd"

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
