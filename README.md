# my dotfiles

WIP

using bare dotfiles approach documented in: <https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git>

```bash
git init --bare ~/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config remote add origin https://github.com/itsjfx/dotfiles.git
config remote add origin git@github.com:itsjfx/dotfiles.git
config config status.showUntrackedFiles no
config pull origin master
```

note for me:

```bash
config config user.name x
config config user.email x
```
