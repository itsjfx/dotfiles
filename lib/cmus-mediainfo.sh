#!/usr/bin/env bash

set -eu -o pipefail

track="$(cmus-remote -C 'echo {}')"
cmus-remote -C 'echo x'
export _FORCE=1
mediainfo "$track" | sed 's/ \+: /: /' | sed 's/: /\t/' | "$HOME"/bin/columnise_pretty | bat
