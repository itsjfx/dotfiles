refresh() { sudo pacman -Sy; }

force_refresh() { sudo pacman -Syy; }

install() { sudo pacman -S --noconfirm --needed "$@"; }


