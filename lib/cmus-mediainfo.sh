#!/usr/bin/env bash

set -eu -o pipefail

track="$(cmus-remote -C 'echo {}')"
cmus-remote -C 'echo x'
mediainfo "$track" | less
