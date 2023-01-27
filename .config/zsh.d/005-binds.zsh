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
    # errrrrrrr is this how you do this, i want the command in the shell
    echo 'git status' >&2
    git status
    zle reset-prompt
}
zle -N _git_status
bindkey '^[g' _git_status

# TODO: probably not going to use with rofi
fzf_search() {
    bash -c 'eval $(compgen -c | fzf)'
}
zle -N fzf_search
bindkey '^[f' fzf_search
