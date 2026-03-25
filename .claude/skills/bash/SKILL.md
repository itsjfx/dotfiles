---
name: bash
description: Style guide for writing bash scripts matching the user's personal conventions. Use when writing, reviewing, or modifying bash/shell scripts.
---

Write bash scripts following these conventions:

## Boilerplate

- Shebang: `#!/usr/bin/env bash` (always use `env`, never direct paths)
- Safety: `set -eu -o pipefail` at the top of every non-trivial script

## Variables

- Local/script variables: `lowercase_snake` (e.g., `tmpfile`, `file1`, `response`)
- Exported/environment variables: `UPPER_CASE` (e.g., `MITMWRAP_HOST`)
- Boolean flags: use `0`/`1` integers (e.g., `proxychains=0`)
- Evaluate boolean flags with `(( ))`, in an `if` or `&&` or `||` when suitable
- Use `local` inside functions when writing a "library" or a script which is sourced

## Quoting & Expansion

- Double-quote all variable expansions: `"$var"`, `"${arr[@]}"`
- Use parameter expansion liberally: `${var##prefix}`, `${var%%suffix}`, `${var:-default}`
- Prefer here-strings `<<<"$var"` over `echo "$var" | cmd`
- Use `"$(...)"` for command substitution, never backticks
- Multi-variable assignment from structured output: `read -r a b c < <(<<<"$json" jq -re '[...] | @tsv')`

## Arguments & Options

- Parse with `while`/`case` loops over `"$@"`, not `getopts`
- Safe shift: `shift || true`
- Default args: `"${1:-}"` or `"${1-default}"`
- When needed, build commands as arrays: `cmd=(command); cmd+=(--flag); "${cmd[@]}"`
- Support `--` as argument terminator where appropriate

## Current working directory

- Avoid doing `(cd && pwd)`
- If possible, run scripts inside the current working directory when needed (manipulating files in dir, etc). Use `cd "$(dirname "$0")"` or append `../` when needed to move out of a `bin/` directory
  - This results in more readable scripts
- If the current working directory should not be changed for the script (UX, etc), use `"$(dirname "$(readlink -f "$0")")"`

## Conditionals

- Prefer `[[ ]]` over `[ ]`
- Use `(( ))` for arithmetic conditions (e.g., `(( $# ))` to check for args)
- Regex matching: `[[ "$str" =~ ^pattern$ ]]`
- Use `case` extensively over `if` for a single variable. Handle bad cases with `*)`, write to stderr and exit/return appropriately

## Functions

- Define as `name() { ... }` (no `function` keyword)
- Call with `main "$@"` at end of script when using main-function pattern
- For simple wrappers/one-liners, skip functions entirely

## Error Handling & Cleanup

- Use `mktemp` to make temp files or temp dirs
- Trap temp files: `trap 'rm -- "$tmpfile"' EXIT`
- When using lots of temp files, use a tmpdir instead, and delete with a trap
- Preserve exit codes in traps: `trap 'code="$?"; rm -f -- "$file"; exit "$code"' EXIT`

## Output & Logging

- Informational/status messages go to stderr: `echo "..." >&2`
- Stdout is for data/results only
- Help text goes to stderr

## External Tools

- Use `jq` everywhere for JSON - use `-nce` for making JSON (never do inline), and do `-re` for reading values
- Prefer GNU tools
- Prefer `sed`, `cut`, `grep` over `awk` unless performance is needed, and `awk` is trivial
- Pipe chains for data transformation (`jq`, `sed`, `awk`, `cut`, `grep`)
- Check command availability: `command -v tool &>/dev/null`
- Fork out to Python 3 if needed for specific stdlib functions (e.g. URL parsing, XML decoding, boto3, etc) — use `python3 -c $'...'` for inline snippets
- Use `date` for dates if possible
- Detect stdin vs TTY with `[ -t 0 ]` to support piped input
- For structured/tabular output: use `pretty` (~/bin/pretty) or `column`, or conditionally format for TTY:
  `if [ -t 1 ]; then command; else cat; fi`

## Exit Codes

- Increment from `1`
- Let `set -e` handle most failures implicitly - no need to validate every single condition in a script, only do so if its absolutely necessary for UX

## Style

- Comments are sparse -- only for non-obvious logic or TODOs
- No formal header blocks or docstrings
- Keep simple scripts simple (one-liners are fine)
