# vim: ft=zsh

for file in "$HOME"/.config/zsh.d/*.zsh; do
    source "$file"
done
