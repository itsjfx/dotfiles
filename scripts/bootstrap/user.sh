#!/usr/bin/env bash
set -eu -o pipefail

#curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

for plugin in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" "lincheney/fzf-tab-completion"; do
    git clone https://github.com/"$plugin" "$HOME"/source/"${plugin##*/}"
done

chsh -s "$(which zsh)"

# Joplin for notes
# TO-DO: move to AUR
# https://github.com/laurent22/joplin#desktop-applications
#wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
