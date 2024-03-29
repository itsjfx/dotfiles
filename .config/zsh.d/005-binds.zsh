# below stolen from oh-my-zsh
bindkey -e # emacs bindings

bindkey ' ' magic-space                               # [Space] - don't do history expansion
bindkey '^H' backward-kill-word

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

# control e == go to end of line
# control u == delete everything till start of line
# control m == press enter
#bindkey -s '\eg' '\C-e\C-u git status\C-m'
_no_history_eval() {
    # using magic from https://github.com/junegunn/fzf/blob/0f4af384571aaf6bcf9146c345feb5c6916c6790/shell/key-bindings.zsh#L83-L89
    zle push-line # clear buffer
    BUFFER=" $@"
    zle accept-line
    local ret=$?
    zle reset-prompt
    # i'm not sure this $ret stuff is needed
    return $ret
}
_bind_git_status_git() { _no_history_eval 'git status' }
_bind_git_status_config() { _no_history_eval 'config status' }
_bind_git_diff() { git rev-parse --is-inside-work-tree &>/dev/null && git diff }
# TODO surely this can be done better?
zle -N _bind_git_status_git
zle -N _bind_git_status_config
zle -N _bind_git_diff
# Alt + g
bindkey '^[g' '_bind_git_status_git'
# ALt + Shift + g
bindkey '^[^g' '_bind_git_status_config'
# Alt + d
bindkey '^[d' '_bind_git_diff'

# TODO show prompt afterward
_bind_full_clear_buffer() {
    clear && printf '\e[3J'
}
zle -N _bind_full_clear_buffer
# Alt + l
# TODO would love CTRL + Shift + L, not sure if possible
bindkey '^[l' '_bind_full_clear_buffer'

# TODO: probably not going to use with rofi
fzf_search() {
    bash -c 'eval $(compgen -c | fzf)'
}
zle -N fzf_search

# Ctrl + k
# https://unix.stackexchange.com/a/11982
# clear buffer, then restore on next prompt
bindkey '^K' push-line

# Ctrl + u
# kill everything from start to cursor. like in bash
bindkey '^U' backward-kill-line
