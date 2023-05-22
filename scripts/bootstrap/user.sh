#!/usr/bin/env bash
set -eu -o pipefail

#curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# bash-my-aws TODO
for plugin in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" "lincheney/fzf-tab-completion" "itsjfx/zsh-tmux-smart-status-bar" "bash-my-aws/bash-my-aws"; do
    plugin_name="${plugin##*/}"
    plugin_path="$HOME/source/$plugin_name"

    if cd "$plugin_path" 2>/dev/null; then
        echo "Fetching $plugin_name" >&2
        git fetch
    else
        echo "Cloning $plugin_name" >&2
        git clone https://github.com/"$plugin" "$HOME"/source/"${plugin##*/}"
    fi
done

if [[ "$(basename "$(grep "^${USER}" /etc/passwd | cut -f7 -d:)")" != 'zsh' ]]; then
    chsh -s "$(which zsh)"
else
    echo 'Not changing shell' >&2
fi

if ! id -nGz "$USER" | grep -qzxF video; then
    echo "Requesting sudo to add $USER to video group" >&2
    sudo usermod -a -G video "$USER"
fi

kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'RememberOpenedTabs' false
kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'BrowseThroughArchives' true
