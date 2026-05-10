#!/usr/bin/env bash

set -eu -o pipefail

cat <<EOF
# claude
**/.claude/settings.local.json

# autogen $(date)
EOF

FILES=(
    GPG
    JetBrains
    LibreOffice
    Linux
    macOS
    mise
    Syncthing
    Vim
)

for file in "${FILES[@]}"; do
    echo ''
    echo ''
    echo "# autogen: $file"
    echo ''
    curl --fail https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Global/"$file".gitignore
done
