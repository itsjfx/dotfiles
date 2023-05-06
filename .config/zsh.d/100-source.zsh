# essentially plugins and anything i need to source

source "$HOME"/source/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=("$HOME"/source/zsh-completions/src $fpath)

source "$HOME"/source/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
[ -d "$HOME/.bash-my-aws" ] && source "$HOME"/.bash-my-aws/bash_completion.sh

#complete -C '/usr/local/bin/aws_completer' aws

[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh

bindkey -M emacs '^F' fzf-file-widget

export PATH="$PATH:$HOME/.fnm"
eval "$(fnm env)"

#source "$HOME/repos/me/notes/notes.sh"
source "$HOME/source/zsh-tmux-smart-status-bar/zsh-tmux-smart-status-bar.sh"

