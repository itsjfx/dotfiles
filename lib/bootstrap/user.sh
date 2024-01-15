#!/usr/bin/env bash
set -eu -o pipefail

# done via AUR for now ...
#curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# bash-my-aws TODO
# TODO, lincheney readline
for plugin in \
    'zsh-users/zsh-autosuggestions' \
    'zsh-users/zsh-completions' \
    'lincheney/fzf-tab-completion' \
    'itsjfx/zsh-tmux-smart-status-bar' \
    'bash-my-aws/bash-my-aws' \
    'lincheney/snr' \
    'alacritty/alacritty-theme' \
    'lincheney/rg-bm25' \
    'lincheney/i3-automark' \
    'laktak/extrakto' \
    'wfxr/tmux-fzf-url' \
; do
    plugin_name="${plugin##*/}"
    plugin_path="$HOME/source/$plugin_name"

    if cd "$plugin_path" 2>/dev/null; then
        echo "Fetching $plugin_name" >&2
        git pull --ff-only
    else
        echo "Cloning $plugin_name" >&2
        git clone https://github.com/"$plugin" "$HOME"/lib/external/"${plugin##*/}"
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

if command -vp code &>/dev/null; then
    extman install
else
    echo 'code not installed, skipping extman' >&2
fi

#if [[ -f "$HOME"/.completions/_wormhole ]]; then
curl -fL https://raw.githubusercontent.com/magic-wormhole/magic-wormhole/master/wormhole_complete.zsh >"$HOME"/.completions/_wormhole
#fi

kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'RememberOpenedTabs' false
kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'BrowseThroughArchives' true
