# aliases and functions

alias cls=clear
alias clip='xclip -selection clipboard'
alias netcat=nc

#music() {
#    (nohup st -e cmus &) >/dev/null 2>&1
#}

alias l='ls --color=tty'
alias ls='ls --color=tty'
alias rg='rg -i'

alias nvm=fnm

# wacky aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias lsa='ls -lah'
#alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias diff='diff --color'

alias md='mkdir -p'
alias rd=rmdir


alias -- -='cd -'
alias diff='diff --color'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias globurl='noglob urlglobber '
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

alias history="history 0"
# https://wiki.archlinux.org/title/Sudo#Passing_aliases
alias sudo="sudo "

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias sizeof='du -hs'

open() {
    (nohup dolphin "${1:-.}" &) >/dev/null 2>&1
}
alias pwgensafe="pwgen --secure -1 60"
