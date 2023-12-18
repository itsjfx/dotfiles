# My dotfiles

WIP everyday

## Looks

![neovim+cmus](https://user-images.githubusercontent.com/13778935/215322103-ea4a3b29-99c4-4b25-b6a5-ad493c00d458.png)
![neofetch](https://user-images.githubusercontent.com/13778935/215322109-f126fd08-4383-4305-9f3c-93be0c255215.png)
![neovim+rofi](https://user-images.githubusercontent.com/13778935/215322634-a0ca1d25-4b28-463d-9fa3-32c8501ece6a.png)

## Non-complete list of things I run

Running the following:
* `zsh`
* `alacritty` with `tmux`
* `i3-wm` with gaps
* `polybar`
* `picom` (when not gaming)
* `rofi`
* `dunst`
* `neovim` or `code`
* `cmus` or `spotify`
* `dolphin`
* `alttab`

## Setup

Using bare dotfiles approach documented in: <https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git>

```bash
git init --bare ~/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# this
config remote add origin https://github.com/itsjfx/dotfiles.git
# or this
config remote add origin git@github.com:itsjfx/dotfiles.git

config config status.showUntrackedFiles no
config pull origin master
```

or
```bash
curl -fL https://raw.githubusercontent.com/itsjfx/dotfiles/master/scripts/bootstrap/run_bootstrap.sh | bash
```

Note for me:

```bash
config config user.name x
config config user.email x
```
