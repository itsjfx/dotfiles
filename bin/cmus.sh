#!/usr/bin/env bash

set -eu -o pipefail

artist=
title=
file=
while read -r line; do
    case "$line" in
        file*)
            if [[ -n "$artist" ]] && [[ -n "$title" ]]; then
                name="$artist - $title"
                # https://github.com/lincheney/fzf-tab-completion/blob/11122590127ab62c51dd4bbfd0d432cee30f9984/zsh/fzf-zsh-completion.sh#L344C50-L344C57
                printf '%s\t\x1b[37m%s\x1b[0m\n' "$name" "$file"
                # reset
                artist=
                title=
            fi
            file="${line#file }"
        ;;
        'tag artist '*) artist="${line#tag artist }" ;; # TODO albumartist
        'tag title '*) title="${line#tag title }" ;;
esac
done < <(cmus-remote -C 'save -e -l -') | \
fzf -d $'\t' --ansi --with-nth=1,2 --nth=1 | \
while IFS=$'\t' read -r track file; do
    echo "Now Playing: $track $file" >&2
    #cmus-remote -C "add -q $file"
    #cmus-remote -l -f "$file"

    cmus-remote -C "live-filter ~f \"$file\""
    cmus-remote -C "win-activate"
    # this seems to clear the live filter
    cmus-remote -C "li"
done
