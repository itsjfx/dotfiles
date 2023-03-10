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
_git_status() {
    # using magic from https://github.com/junegunn/fzf/blob/0f4af384571aaf6bcf9146c345feb5c6916c6790/shell/key-bindings.zsh#L83-L89
    zle push-line # clear buffer
    BUFFER=" $@ status"
    zle accept-line
    local ret=$?
    zle reset-prompt
    # i'm not sure this $ret stuff is needed
    return $ret
}
_git_status_git() { _git_status git }
_git_status_config() { _git_status config }
# TODO surely this can be done better?
zle -N _git_status_git
zle -N _git_status_config
bindkey '^[g' '_git_status_git'
bindkey '^[^g' '_git_status_config'

# TODO: probably not going to use with rofi
fzf_search() {
    bash -c 'eval $(compgen -c | fzf)'
}
zle -N fzf_search
bindkey '^[f' fzf_search
