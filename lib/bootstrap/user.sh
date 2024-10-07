#!/usr/bin/env bash
set -eu -o pipefail

add_to_group() {
    if ! id -nGz "$USER" | grep -qzxF "$1"; then
        echo "Requesting sudo to add $USER to $1 group" >&2
        sudo usermod -a -G "$1" "$USER"
    fi
}

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
    'itsjfx/cmus-fzf' \
    'bash-my-aws/bash-my-aws' \
    'lincheney/snr' \
    'alacritty/alacritty-theme' \
    'lincheney/rg-bm25' \
    'lincheney/i3-automark' \
    'lincheney/dsv' \
    'lincheney/live-preview.zsh' \
    'laktak/extrakto' \
    'wfxr/tmux-fzf-url' \
; do
    plugin_name="${plugin##*/}"
    plugin_path="$HOME/lib/external/$plugin_name"

    if cd "$plugin_path" 2>/dev/null; then
        echo "Fetching $plugin_name" >&2
        git pull --ff-only --no-rebase
    else
        echo "Cloning $plugin_name" >&2
        git clone https://github.com/"$plugin" "$plugin_path"
    fi
done

if ! command -vp zsh &>/dev/null; then
    echo 'Not changing shell: missing zsh' >&2
elif [[ "$(basename "$(grep "^${USER}" /etc/passwd | cut -f7 -d:)")" != 'zsh' ]]; then
    chsh -s "$(which zsh)"
else
    echo 'Not changing shell: shell is zsh' >&2
fi

add_to_group video
add_to_group optical

if command -vp extman &>/dev/null && command -vp code &>/dev/null; then
    extman install
else
    echo 'code not installed, skipping extman' >&2
fi

#if [[ -f "$HOME"/.completions/_wormhole ]]; then
curl -fL https://raw.githubusercontent.com/magic-wormhole/magic-wormhole/master/wormhole_complete.zsh >"$HOME"/.completions/_wormhole
#fi

kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'RememberOpenedTabs' false
kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'BrowseThroughArchives' true

( unset BROWSER; xdg-settings set default-web-browser firefox.desktop )

# symlinks

mkdir -p media/Pictures media/Music repos

systemctl enable --now --user ssh-agent.service xdg-desktop-portal.service plasma-xdg-desktop-portal-kde.service
