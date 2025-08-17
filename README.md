# My dotfiles

WIP everyday

## Looks

![neofetch](https://github.com/itsjfx/dotfiles/assets/13778935/76a84b1c-4dcd-413a-9db4-980dc5a24e84)
![2024-01-12_01-15_1](https://github.com/itsjfx/dotfiles/assets/13778935/c0cb6444-686d-4b31-bfb3-4c41fdb22ac6)
![2024-01-12_01-26_1](https://github.com/itsjfx/dotfiles/assets/13778935/fc85ae12-ee0b-42bb-ad22-fb1cb33209cd)
![2024-01-12_01-14_1](https://github.com/itsjfx/dotfiles/assets/13778935/2c2ffd13-7692-4dc4-8d36-f1520e417a73)
![2024-01-12_01-20](https://github.com/itsjfx/dotfiles/assets/13778935/b82ae57e-3f5d-468d-9469-ca8c9e94c5a4)

## Incomplete list of things I use

* `zsh`
* `alacritty`
    * `tmux`
    * [zsh-tmux-smart-status-bar](https://github.com/itsjfx/zsh-tmux-smart-status-bar) for tmux status bar
    * [fzf-tab-completion](https://github.com/lincheney/fzf-tab-completion) for tab completion with fzf
* `i3-wm`
    * gaps (sometimes)
    * [i3-automark](https://github.com/lincheney/i3-automark) to automark windows
    * [alttab](https://github.com/sagb/alttab) to alt tab
* `polybar`
    * with custom scripts
* `picom` (when not gaming)
* `rofi`
    * `dmenu`-like switcher on `Mod+d`
    * Firefox profile switcher on `Mod+Shift+f`
    * Power menu on `Mod+Shift+p`
    * VS Code workspace opener on `Mod+Shift+c`
* `dunst`
* `neovim` or `code`
* `cmus` or `spotify`
* `dolphin`
* and many other programs (mostly KDE)

## Setup

* Using bare dotfiles approach documented in: <https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git>
* I've modified the approach to be a [script](bin/config) and have a [custom completer](.completions/_config) to fix some issues with the completer on the alias

**WARNING: This will run my highly opinionated bootstrap script. This is for myself. I suggest not doing this:**

```bash
curl -fL https://raw.githubusercontent.com/itsjfx/dotfiles/master/lib/bootstrap/run_bootstrap.sh | bash
```

or (alias to get started)

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

Note for me:

```bash
config config user.name x
config config user.email x
```

## LICENSE

This is MIT licensed as a restrictive license seemed inappropriate.

```
Copyright (c) 2025 Thomas

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
