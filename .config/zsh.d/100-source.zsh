# essentially plugins and anything i need to source

source "$HOME"/source/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=("$HOME"/source/zsh-completions/src $fpath)

source "$HOME"/source/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion

complete -C '/usr/local/bin/aws_completer' aws

source /usr/share/fzf/key-bindings.zsh
bindkey -M emacs '^F' fzf-file-widget

export PATH="$PATH:$HOME/.fnm"
eval "$(fnm env)"

source "$HOME/repos/me/notes/notes.sh"
source "$HOME/source/zsh-tmux-smart-status-bar/zsh-tmux-smart-status-bar.sh"

