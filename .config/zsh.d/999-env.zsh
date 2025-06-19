# my scripts
export PATH="$HOME/bin:$PATH"
# sbin
if ! echo "$PATH" | grep -Fq ":$HOME/sbin:"; then
    export PATH="$HOME/sbin:$PATH"
fi
