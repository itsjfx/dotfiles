# essentially plugins and anything i need to source

source "$HOME"/lib/hi.sh
source "$HOME"/lib/external/zsh-autosuggestions/zsh-autosuggestions.zsh
# fpath in 000-opts

source "$HOME"/lib/external/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
[ -d "$HOME/lib/external/bash-my-aws" ] && source "$HOME"/lib/external/bash-my-aws/bash_completion.sh

#complete -C '/usr/local/bin/aws_completer' aws

[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh

# Ctrl + F instead of Ctrl + T
bindkey -M emacs '^F' fzf-file-widget
# basically a Ctrl + T with git files
# Alt + F to activate
fzf_git_search() {
	FZF_CTRL_T_COMMAND='git ls-files 2>/dev/null' fzf-file-widget
}
zle -N fzf_git_search
bindkey '^[f' fzf_git_search

if command -vp fnm &>/dev/null; then
    eval "$(fnm env)"    
elif [[ -d "$HOME/.fnm" ]]; then
    export PATH="$PATH:$HOME/.fnm"
    eval "$(fnm env)"
fi

#source "$HOME/repos/me/notes/notes.sh"
source "$HOME/lib/external/zsh-tmux-smart-status-bar/zsh-tmux-smart-status-bar.sh"

