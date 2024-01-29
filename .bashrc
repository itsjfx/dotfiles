#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

__bash_prompt() {
    local code="$?"
    local GREEN="\[\e[1;32m\]"
    local RED="\[\e[1;31m\]"
    local CYAN="\[\e[0;36m\]"
    local RESET="\[\e[0m\]"
    if ! (( "$code" )); then
        PS1="${GREEN}➜ "
    else
        PS1="${RED}➜ "
    fi
    PS1+=" ${CYAN}\W${RESET}$ "
}

PROMPT_COMMAND=__bash_prompt

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

if [[ -d "$HOME"/source/fzf-tab-completion ]]; then
    source "$HOME"/source/fzf-tab-completion/bash/fzf-bash-completion.sh
    bind -x '"\t": fzf_bash_completion'
fi
