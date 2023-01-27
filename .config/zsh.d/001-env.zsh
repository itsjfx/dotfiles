export HISTSIZE=500000
export SAVEHIST=500000

export BROWSER=firefox

# python3
export PATH="$PATH:$HOME/.local/bin"
# my scripts
export PATH="$PATH:$HOME/bin"
# bma
export PATH="$PATH:$HOME/.bash-my-aws/bin"

export AWS_DEFAULT_REGION=ap-southeast-2
export SAM_CLI_TELEMETRY=0

export PUPPETEER_EXECUTABLE_PATH="$(which chromium-browser)"

#export PYTHONPATH=~/.aws/cli/plugins/:"$PYTHONPATH"

export GEM_HOME="$HOME/.gem"
export PAGER=less
export LESS=-R

export EDITOR='vim'
if type nvim &> /dev/null; then
#	alias vi='vim'
	export EDITOR='nvim'

	# nvim as man viewer
	#export MANPAGER='nvim +Man!'
	#export MANWIDTH=999
fi

# use bat
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#export MANROFFOPT="-c"

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
export HISTFILE
