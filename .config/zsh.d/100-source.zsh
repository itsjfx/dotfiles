# essentially plugins and anything i need to source

source "$HOME"/lib/hi.sh
source "$HOME"/lib/external/zsh-autosuggestions/zsh-autosuggestions.zsh
# fpath in 000-opts

source "$HOME"/lib/external/fzf-tab-completion/zsh/fzf-zsh-completion.sh
bindkey '^I' fzf_completion
export FZF_COMPLETION_OPTS='--tiebreak=chunk'

[ -d "$HOME/lib/external/bash-my-aws" ] && source "$HOME"/lib/external/bash-my-aws/bash_completion.sh

source "$HOME"/lib/external/live-preview.zsh/live-preview.zsh
bindkey '\ep' live_preview.toggle
bindkey '\es' live_preview.save

#complete -C '/usr/local/bin/aws_completer' aws

[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f "$HOME"/.nix-profile/share/fzf/key-bindings.zsh ]] && source "$HOME"/.nix-profile/share/fzf/key-bindings.zsh

# Ctrl + F instead of Ctrl + T
bindkey -M emacs '^F' fzf-file-widget
# basically a Ctrl + T with git files
# Alt + F to activate
fzf_git_search() {
	FZF_CTRL_T_COMMAND='git ls-files 2>/dev/null' fzf-file-widget
}
zle -N fzf_git_search
bindkey '^[f' fzf_git_search

if command -v fnm &>/dev/null; then
    eval "$(fnm env)"
elif [[ -d "$HOME/.fnm" ]]; then
    export PATH="$PATH:$HOME/.fnm"
    eval "$(fnm env)"
fi

#source "$HOME/repos/me/notes/notes.sh"
source "$HOME/lib/external/zsh-tmux-smart-status-bar/zsh-tmux-smart-status-bar.sh"

# mac
if [[ -d /opt/homebrew ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    # fpath added in opts
    export PATH="/opt/homebrew/bin:$PATH"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

# promote to top
# leave at bottom
if [[ -d /nix ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi
