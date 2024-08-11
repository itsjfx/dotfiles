# this is a hacky way of playing nice with zsh-autosuggestions
# TODO: play nice with zsh-autosuggestions if completing gcm or ccm
# TODO dont count quotes in arg length
_GCM=0
gcm_highlight() {
    local command cmd args
    command=${BUFFER%% *}  # Extract the command from the buffer

    if [[ "$command" == "gcm" ]]; then
        cmd="${BUFFER#gcm}"
    elif [[ "$command" == "ccm" ]]; then
        cmd="${BUFFER#ccm}"
    else
        if (( _GCM )); then
            region_highlight=()
            _GCM=0
        fi
        return
    fi
    region_highlight=()
    if [[ "${#cmd}" -gt 73 ]]; then # 72 + 1
        region_highlight+=( "4 $((${#BUFFER})) fg=red" )
    else
        region_highlight+=( "4 $((${#BUFFER})) fg=green" )
    fi
    _GCM=1
}

# Bind the function to zsh's pre-execution hook
zle -N zle-line-pre-redraw gcm_highlight
