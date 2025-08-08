# make style file last just in case something modifies my prompt

# one liner hack to get completions up for git custom commands
# see: https://github.com/zsh-users/zsh/blob/d6e4ddd4d48b6ac9c0a29b95e0e2fc0e6012d725/Completion/Unix/Command/_git#L16C54-L16C90
zstyle ':completion:*:*:git:*' user-commands ${${${(M)${(k)commands}:#git-*}/git-/}/%/:(custom)}

# i think this is from oh-my-zsh
# Take advantage of $LS_COLORS for completion as well.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# show Loading... text
zstyle ':completion:*' show-completer 'true'

# below from: https://github.com/lincheney/fzf-tab-completion#specifying-custom-fzf-options

# basic file preview for ls (you can replace with something more sophisticated than head)
zstyle ':completion::*:ls::*' fzf-completion-opts --preview='eval head {1}'

# preview when completing env vars (note: only works for exported variables)
# eval twice, first to unescape the string, second to expand the $variable
zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}'

# preview a `git status` when completing git add
zstyle ':completion::*:git::git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'

# if other subcommand to git is given, show a git diff or git log
zstyle ':completion::*:git::*,[a-z]*' fzf-completion-opts --preview='
eval set -- {+1}
for arg in "$@"; do
    { git diff --color=always -- "$arg" || git log --color=always "$arg" } 2>/dev/null
done'

# https://github.com/lincheney/fzf-tab-completion/commit/337deb9fcfc20557fec5cdbd6fd1b3a99d349417
#
# press ctrl-r to repeat completion *without* accepting i.e. reload the completion
# press right to accept the completion and retrigger it
# press alt-enter to accept the completion and run it
keys=(
    ctrl-r:'repeat-fzf-completion'
    alt-enter:accept:'zle accept-line'
)

zstyle ':completion:*' fzf-completion-keybindings "${keys[@]}"
# also accept and retrigger completion when pressing / when completing cd
zstyle ':completion::*:cd:*' fzf-completion-keybindings "${keys[@]}" /:accept:'repeat-fzf-completion'




# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
# but no git_prompt_info
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
if [[ -n "$SSH_CONNECTION" ]]; then
    PROMPT+=' %{$fg[green]%}%n@%m' # magenta
fi
PROMPT+=' %{$fg[cyan]%}%c %{$reset_color%}'
if [ -d "$HOME"/lib/external/live-preview.zsh ]; then
    PROMPT+='${live_preview_vars[active]:+"%F{10}%B (live)%f%b"}'
fi
export PROMPT
