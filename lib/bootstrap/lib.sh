_ROOT="$(realpath "$(dirname "$BASH_SOURCE")")"
export _ROOT
source /etc/os-release
# OS
# fedora
# arch

# purple
log_info() { ( set +x; printf '\e[1;35mINFO\t\e[0;35m%s\e[m\n' "$*" ) >&2; }

# yellow
log_warn() { ( set +x; printf '\e[1;33mWARN\t\e[0;33m%s\e[m\n' "$*" ) >&2; }

# red
log_error() { ( set +x; printf '\e[1;31mERROR\t\e[0;31m%s\e[m\n' "$*" ) >&2; }

pkg_refresh() { sudo pacman -Sy; }

pkg_force_refresh() { sudo pacman -Syy; }

pkg_install() { sudo pacman -S --noconfirm --needed "$@"; }

pkg_sys_upgrade() { sudo pacman -Syu; }

pip_install() { pip3 install --user --break-system-packages "$@"; }

# log_info "Executing strap: $(basename "$0")"
