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
alias lat='la -t'

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
    (nohup dolphin "${1:-.}" &) >/dev/null 2>&1
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
alias countr='sort | uniq -c | sort -rn'
alias count='sort | uniq -c | sort -n'

# git aliases
__gcm() { cmd="$1"; shift; (( $# > 0 )) && "$cmd" commit --message "$*" || "$cmd" commit; }

gcm() { __gcm git "$@"; }
alias ga='git add'
alias gap='git add --patch'
alias gb='git branch'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gm='git morelog'
alias cm='config morelog'
alias gco='git checkout'

ccm() { __gcm config "$@"; }
alias ca='config add'
alias cap='config add --patch'
alias cl='config pull'
# cp is taken obviously
alias .cp='config push'

alias search='rg-bm25'
alias reload='exec zsh'
noop() { }
sshkey() { cat "$HOME"/.ssh/id_ed25519.pub; }

sumup() { awk '{s+=$1} END {print s}'; }

gotmp() { mkdir -p /tmp/"$1"; cd /tmp/"$1"; }

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
