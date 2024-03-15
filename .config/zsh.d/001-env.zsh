# BROWSER set in .xprofile

export HISTSIZE=500000
export SAVEHIST=500000
export NODE_REPL_HISTORY_SIZE=500000
export NODE_REPL_MODE=strict

export BROWSER="${BROWSER-firefox}"
# python3
export PATH="$PATH:$HOME/.local/bin"
# my scripts
export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.meteor" ] && export PATH="$PATH:$HOME/.meteor"

if [ -d "$HOME"/Android/Sdk ]; then
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
    export ANDROID_HOME="$ANDROID_SDK_ROOT"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
fi

# bma
if [ -d "$HOME"/lib/external/bash-my-aws ]; then
	export BMA_HOME="$HOME"/lib/external/bash-my-aws
	export PATH="$PATH:$BMA_HOME/bin"
	export BMA_COLUMNISE_ONLY_WHEN_TERMINAL_PRESENT=true
fi

export AWS_DEFAULT_REGION=ap-southeast-2
export SAM_CLI_TELEMETRY=0
export AWS_PAGER=''
export SLS_TELEMETRY_DISABLED=1
export AWS_EC2_METADATA_DISABLED=true
export GOTELEMETRY=off
export AZURE_CORE_COLLECT_TELEMETRY=False
export DO_NOT_TRACK=1


# monokai without backgrounding
export FZF_DEFAULT_OPTS='--color=spinner:#E6DB74,hl:#F92672,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672 --multi'

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

if type bat &>/dev/null; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	export MANROFFOPT="-c"
fi
export PODMAN_USERNS=keep-id
