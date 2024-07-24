#!/usr/bin/env bash

set -eu -o pipefail

SEP=$'\u00a0'

artist=
title=
file=
tracknumber=
while read -r line; do
    case "$line" in
        file*)
            if [[ -n "$artist" ]] && [[ -n "$title" ]] && [[ -n "$tracknumber" ]]; then
                name="$artist - $title"
                # https://github.com/lincheney/fzf-tab-completion/blob/11122590127ab62c51dd4bbfd0d432cee30f9984/zsh/fzf-zsh-completion.sh#L344C50-L344C57
                printf "%s$SEP- %s.$SEP%s$SEP\x1b[37m%s\x1b[0m\n" "$artist" "${tracknumber#0}" "$title" "$file"
                # reset
                artist=
                title=
                tracknumber=
            fi
            file="${line#file }"
        ;;
        'tag artist '*) artist="${line#tag artist }" ;; # TODO albumartist
        'tag title '*) title="${line#tag title }" ;;
        'tag tracknumber '*) tracknumber="${line#tag tracknumber }" ;;
esac
done < <(cmus-remote -C 'save -e -L -') | \
fzf -d "[$SEP]" --ansi --with-nth=1,2,3,4 --nth=1,3 | \
while IFS="$SEP" read -r artist _ track file; do
    echo "Now Playing: $file" >&2
    #cmus-remote -C "add -q $file"
    #cmus-remote -l -f "$file"

    cmus-remote -C "live-filter ~f \"$file\""
    cmus-remote -C "win-activate"
    # this seems to clear the live filter
    cmus-remote -C "li"
done
