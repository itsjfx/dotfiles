# vim: ft=zsh

source "$HOME"/source/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=("$HOME"/source/zsh-completions/src $fpath)

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#
# stolen from oh-my-zsh
# TODO: should put links in
# or replace with zinit + OMZ fast loading
#
export HISTSIZE=500000
export SAVEHIST=500000

setopt auto_cd
setopt promptsubst

autoload -U colors && colors
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Take advantage of $LS_COLORS for completion as well.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

alias cls=clear
alias BROWSER=firefox
#alias netcat=nc
#ln -s /usr/bin/nc ~/.local/bin/netcat
alias clip='xclip -selection clipboard'
export EDITOR='nvim'

#music() {
#    nohup st -e cmus >/dev/null 2>&1 &
#}

# python3 likes to install here
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"

source ~/source/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion

fzf_search() {
    bash -c 'eval $(compgen -c | fzf)'
}
zle -N fzf_search
bindkey '^[f' fzf_search

# export PATH="$PATH:$HOME/.bash-my-aws/bin"
# source ~/.bash-my-aws/aliases
# source ~/.bash-my-aws/bash_completion.sh

export AWS_DEFAULT_REGION=ap-southeast-2
# complete -C '/usr/local/bin/aws_completer' aws

#export PATH=$PATH:/usr/local/go/bin
#export GOPATH=$(go env GOPATH)
#export PATH=$PATH:$GOPATH/bin

export PUPPETEER_EXECUTABLE_PATH="$(which chromium-browser)"

source /usr/share/fzf/key-bindings.zsh
export PATH=/home/jfx/.meteor:$PATH

alias l='ls --color=tty'
alias ls='ls --color=tty'
alias rg='rg -i'
export PYTHONPATH=~/.aws/cli/plugins/:"$PYTHONPATH"

export PATH="/home/jfx/.fnm/:$PATH"
eval "$(fnm env)"

# basic file preview for ls (you can replace with something more sophisticated than head)
zstyle ':completion::*:ls::*' fzf-completion-opts --preview='eval head {1}'

# preview when completing env vars (note: only works for exported variables)
# eval twice, first to unescape the string, second to expand the $variable
zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}'

# preview a `git status` when completing git add
zstyle ':completion::*:git::git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'

# if other subcommand to git is given, show a git diff or git log
zstyle ':completion::*:git::*,[a-z]*' fzf-completion-opts --preview='
eval set -- {+1}
for arg in "$@"; do
    { git diff --color=always -- "$arg" || git log --color=always "$arg" } 2>/dev/null
done'
export GEM_HOME="$HOME/.gem"
export PAGER=less
export LESS=-R


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

bindkey -e # emacs bindings

bindkey ' ' magic-space                               # [Space] - don't do history expansion
bindkey '^H' backward-kill-word

# more of this stuff stolen from OMZ

bindkey -M emacs '^?' backward-delete-char    
# [Ctrl-Delete] - delete whole forward-word    
bindkey -M emacs '^[[3;5~' kill-word    
# [Ctrl-RightArrow] - move forward one word    
bindkey -M emacs '^[[1;5C' forward-word    
# [Ctrl-LeftArrow] - move backward one word    
bindkey -M emacs '^[[1;5D' backward-word    

# Delete key
# thanks https://github.com/chrisduerr/dotfiles/blob/master/files/zsh/keys.zsh
bindkey "${terminfo[kdch1]}" delete-char

## History file configuration    
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"    
    
## History command configuration    
setopt extended_history       # record timestamp of command in HISTFILE    
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE    
setopt hist_ignore_dups       # ignore duplicated commands history list    
setopt hist_ignore_space      # ignore commands that start with space    
setopt hist_verify            # show command with history expansion to user before running it    
setopt share_history          # share command history data

alias history="history 0"
# https://wiki.archlinux.org/title/Sudo#Passing_aliases
alias sudo="sudo "

# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
# but no git_prompt_info
# TODO: basic prompt but it works pretty well for me
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} '

source "$HOME/repos/me/notes/notes.sh"
source "$HOME/source/zsh-tmux-smart-status-bar/zsh-tmux-smart-status-bar.sh"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
