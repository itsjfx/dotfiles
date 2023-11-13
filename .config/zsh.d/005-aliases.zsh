# aliases and functions

alias cls=clear
alias clip='xclip -selection clipboard'
alias netcat=nc

#music() {
#    (nohup st -e cmus &) >/dev/null 2>&1
#}

alias l='ls --color=tty'
alias ls='ls --color=tty'
alias rg='rg --smart-case'

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

alias md='mkdir -p'
alias rd=rmdir


alias -- -='cd -'
alias diff='delta'
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
alias proxychains='proxychains4'

alias code='LD_PRELOAD= code'

alias unzipd='unzip $1 -d "${"$(basename "$1")"%.zip}"'
alias node="node -r $HOME/lib/node-custom-repl.js"
if [[ -f "$HOME"/source/rl_custom_function/target/release/librl_custom_function.so ]]; then
    alias python3="LD_PRELOAD=$HOME/source/rl_custom_function/target/release/librl_custom_function.so python3"
fi

alias nvimdiff="nvim -d"
alias vimdiff="nvim -d"

url-query() {
    python3 -c "import urllib.parse, json; print(json.dumps(dict(urllib.parse.parse_qsl(urllib.parse.urlsplit('$1').query))))" | jq -r .
}

mkcd() { mkdir -p -- "$@" && cd -- "$@" }

alias mktargz="tar -czvf"
alias count='sort | uniq -c | sort -rn'

# git aliases
alias ga='git add'
alias gap='git add --patch'
alias cap='config add --patch'
alias gb='git branch'
alias gs='git status'
gcm() { git commit --message "$*" }
alias gl='git log --stat --patch'
alias gl='git pull'
alias gp='git push'

alias search='rg-bm25'
alias reload='exec zsh'
noop() { }
sshkey() { cat "$HOME"/.ssh/id_ed25519.pub; }
