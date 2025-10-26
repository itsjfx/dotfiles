#!/usr/bin/env bash
set -eu -o pipefail

is_mac=0
if [ "$(uname)" == "Darwin" ]; then
    is_mac=1
fi

add_to_group() {
    if ! getent group "$1" &>/dev/null; then
        echo "Group: $1 does not exist" >&2
        return
    fi
    if ! id -nGz "$USER" | grep -qzxF "$1"; then
        echo "Requesting sudo to add $USER to $1 group" >&2
        sudo usermod -a -G "$1" "$USER"
    fi
}

# done via AUR for now ...
#curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# neovim
#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# bash-my-aws TODO
# TODO, lincheney readline
for plugin in \
    'zsh-users/zsh-autosuggestions' \
    'zsh-users/zsh-completions' \
    'lincheney/fzf-tab-completion' \
    'lincheney/rl_custom_isearch' \
    'itsjfx/zsh-tmux-smart-status-bar' \
    'itsjfx/cmus-fzf' \
    'itsjfx/csi' \
    'bash-my-aws/bash-my-aws' \
    'lincheney/snr' \
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

ln -srf "$HOME"/lib/external/dsv/completions/dsv.zsh "$HOME"/.completions/_dsv
ln -srf "$HOME"/lib/external/csi/completions/csi.zsh "$HOME"/.completions/_csi
ln -srf "$HOME"/lib/external/csi/bin/csi "$HOME"/bin/csi

if [[ -d /a/ ]]; then
    ln -srf "$HOME"/.aws/cli/plugins /a/.aws-plugins
fi

if ! command -vp zsh &>/dev/null; then
    echo 'Not changing shell: missing zsh' >&2
elif (( is_mac )); then
    echo 'Not changing shell: on Mac' >&2
elif [[ "$(basename "$(grep "^${USER}" /etc/passwd | cut -f7 -d:)")" != 'zsh' ]]; then
    chsh -s "$(which zsh)"
else
    echo 'Not changing shell: shell is zsh' >&2
fi

add_to_group video
add_to_group optical
add_to_group uucp
add_to_group games

if command -vp extman &>/dev/null && command -vp code &>/dev/null; then
    extman install
else
    echo 'code not installed, skipping extman' >&2
fi

#if [[ -f "$HOME"/.completions/_wormhole ]]; then
curl -fL https://raw.githubusercontent.com/magic-wormhole/magic-wormhole/master/wormhole_complete.zsh >"$HOME"/.completions/_wormhole
#fi

if (( ! is_mac )); then
    # default settings in Dolphin
    kwriteconfig6 --file "$HOME"/.config/dolphinrc --group 'General' --key 'RememberOpenedTabs' false
    kwriteconfig6 --file "$HOME"/.config/dolphinrc --group 'General' --key 'BrowseThroughArchives' true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    ( unset BROWSER; xdg-settings set default-web-browser firefox.desktop || true )

    # mac has no systemd
    systemctl enable --now --user ssh-agent.service xdg-desktop-portal.service plasma-xdg-desktop-portal-kde.service

    if systemctl --user cat batsignal.service &>/dev/null; then
        systemctl --user enable batsignal.service --now
    fi

    systemctl --user enable --now yubikey-touch-detector.service
fi

# symlinks

mkdir -p media/Pictures media/Music repos

# rekot

curl -fL https://github.com/darthorimar/rekot/releases/download/0.1.4/rekot-0.1.4.jar > "$HOME"/lib/external/rekot.jar
