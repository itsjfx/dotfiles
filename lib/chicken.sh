# usage: source chicken.sh
animal_counter=0
animal_prev_update=0
animals() {
#    chars=🐳🐋
#    chars=🌑🌒🌓🌔🌕🌖🌗🌘
    chars=🐣🐥
    if (( $(date +%s%N) - animal_prev_update > 1000*1000*100 )); then
        if [[ "$PROMPT" == *[$chars]' ' ]]; then
            PROMPT="${PROMPT:0:${#PROMPT}-2}"
        fi
        # PROMPT="${PROMPT}${chars[RANDOM % $#chars]} "
        PROMPT="${PROMPT}${chars[animal_counter % $#chars + 1]} "
        (( animal_counter++ ))
        animal_prev_update=$(date +%s%N)
    fi
    zle reset-prompt
}

function self-insert() {
    animals
    zle .self-insert
}

zle -N self-insert
zle -N zle-line-init animals
