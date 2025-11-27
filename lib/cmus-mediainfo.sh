#!/usr/bin/env bash

set -eu -o pipefail

track="$(cmus-remote -C 'echo {}')"
cmus-remote -C 'echo x'
mediainfo "$track" | sed 's/ \+: /: /' | sed 's/: /\t/' | "$HOME"/bin/pretty --columnize=always --color=always | bat --paging=always
