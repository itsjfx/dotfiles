# stolen from oh-my-zsh
# TODO: should put links in
# or replace with zinit + OMZ fast loading
#
setopt no_case_glob
setopt auto_cd
setopt promptsubst
setopt interactivecomments

autoload -U colors && colors
# BEFORE compinit
fpath=("$HOME"/completions $fpath)
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
