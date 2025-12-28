# aliases and functions

alias cls=clear
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
alias lat='la -t'
alias lah='ls -lAh'

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

alias sizeof='du -hs'

open() {
    if command -vp dolphin; then
        (nohup dolphin "${1:-.}" &) >/dev/null 2>&1
    else
        command open "$@"
    fi
}
pwgensafe() { openssl rand -base64 24 | tr '\n' -d; }
alias proxychains='proxychains4'

alias code='LD_PRELOAD= code'

alias unzipd='unzip $1 -d "${"$(basename "$1")"%.zip}"'
alias node="node -r $HOME/lib/node-custom-repl.js"
if [[ -f "$HOME"/lib/external/rl_custom_function/target/release/librl_custom_function.so ]]; then
    alias python3="LD_PRELOAD=$HOME/lib/external/rl_custom_function/target/release/librl_custom_function.so python3"
fi

alias nvimdiff="nvim -d"
alias vimdiff="nvim -d"

url-query() {
    python3 -c "import urllib.parse, json; print(json.dumps(dict(urllib.parse.parse_qsl(urllib.parse.urlsplit('$1').query))))" | jq -r .
}

mkcd() { mkdir -p -- "$@" && cd -- "$@"; }

alias mktargz="tar -czvf"
alias mkzip='zip -r'
alias mktarzst='tar --zstd -cvf'
alias countr='sort | uniq -c | sort -rn'
alias count='sort | uniq -c | sort -n'

alias dsvcountr='dsv sort | dsv uniq -c | dsv sort -rn'
alias dsvcount='dsv sort | dsv uniq -c | dsv sort -n'

# git aliases
__gcm() { cmd="$1"; shift; (( $# > 0 )) && "$cmd" commit --message "$*" || "$cmd" commit; }

gcm() { __gcm git "$@"; }
alias ga='git add'
alias gap='git add --patch'
alias gb='git branch'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias glp='gl && gp'
alias gm='git morelog'
alias cm='config morelog'
alias gco='git checkout'
alias gd='git diffmuch'
alias gds='git diff --staged'
alias .cd='config diffmuch'

ccm() { __gcm config "$@"; }
alias ca='config add'
alias cap='config add --patch'
alias cl='config pull'
# cp is taken obviously
alias .cp='config push'
alias clp='cl && .cp'

alias search='rg-bm25'
alias reload='exec zsh'
noop() { }
sshkey() { cat "$HOME"/.ssh/id_ed25519.pub; }

sumup() { awk '{s+=$1} END {print s}'; }

tmp() { mkdir -p /tmp/"$1"; cd /tmp/"$1"; }
a() { mkdir -p /a/"$1"; cd /a/"$1"; }

alias mkssh='ssh-keygen -t ed25519'

ssh_with_dynamic_prompt() {
    local SSH_COMMAND
    SSH_COMMAND=$(cat <<'EOF'
case "$SHELL" in
    *bash*) export PS1="\u@\h:\w\$ "; exec bash --login ;;
    *zsh*)  export PROMPT="%n@%m:%~\% "; exec zsh -l ;;
    *) echo "Unsupported shell: $SHELL"; exit 1 ;;
esac
EOF
    )
    ssh "$@" -t "$SSH_COMMAND"
}

alias perm='stat -c "%n %a"'
path() { readlink -f "${1-.}"; }

alias youtube-dl='yt-dlp'

own() { chown -R "$USER":"$USER" "$@"; }

alias podman-shell=docker-shell

alias rice='v ~/.config/nvim/init.lua ~/.config/nvim-old/init.vim ~/.config/i3/config ~/.config/zsh.d/*'

whenis() {
    if ! [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        date -d "$@"
    elif (( $1 > 1000000000*1000*1000 )); then
        date -d "@${1::-6}.${1:${#1}-6}" "${@:2}"
    elif (( $1 > 1000000000*1000 )); then
        date -d "@${1::-3}.${1:${#1}-3}" "${@:2}"
    else
        date -d "@$@"
    fi
}

alias nospace="tr -d ' '"
alias noline="tr -d '\n'"
secret() { unset HISTFILE; }
nohist() { unset HISTFILE; }

autoload -z edit-command-line
zle -N edit-command-line
bindkey "\ev" edit-command-line

alias epoch='date +%s'
alias epochms='date +%s%3N'

# on Mac OS, i install a lot of GNU applications to my users bin directory
# however, there are times that using the Mac/BSD/Xcode offered tooling is necessary
# for example, gcc offered by Xcode has some headers which the GNU one does not
# and some CLI tools like sed behave differently on BSD
# in these cases, we can bump the bin folders ahead of our own one
# this has duplication on PATH, but cause we generally want to target binaries in these folders, I don't think this is introduces huge performance concern
sysexec() {
    PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH" "$@"
}

datediff() {
    local val
    val=$(( "$(date +%s -d "$2")"-"$(date +%s -d "$1")"/86400 ))
    echo "$val"
}

zsh-vanilla() { env -i ZDOTDIR="$(mktemp -d)" zsh --login; }
alias v-='v -'

alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]"'
