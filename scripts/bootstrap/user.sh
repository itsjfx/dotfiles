#!/usr/bin/env bash
set -eu -o pipefail

#curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

for plugin in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" "lincheney/fzf-tab-completion"; do
    git clone https://github.com/"$plugin" "$HOME"/source/"${plugin##*/}"
done

chsh -s "$(which zsh)"

kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'RememberOpenedTabs' false
kwriteconfig5 --file "$HOME"/.config/dolphinrc --group 'General' --key 'BrowseThroughArchives' true
