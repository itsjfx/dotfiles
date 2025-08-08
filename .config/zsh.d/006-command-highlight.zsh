# Command execution highlighting
# Highlights commands in purple before execution for better visual separation in history

# Custom accept-line widget that highlights the command before execution
_highlight_command_and_execute() {
    local current_buffer="$BUFFER"

    # Only highlight if there's actually a command to execute
    if [[ -n "$current_buffer" && "$current_buffer" =~ [^[:space:]] ]]; then
        # Move to beginning of line and clear it
        printf '\r\033[2K'

        # Apply dark gray background with pink text to entire line (prompt + command)
        printf '\033[100m\033[35m'  # Start dark gray background with pink text
        print -nP "$PROMPT"  # Prompt with original colors on dark gray background
        printf '\033[100m\033[35m%s\033[0m' "$current_buffer"  # Command with dark gray background and pink text
    fi

    # Execute the original accept-line
    zle .accept-line
}

# Register the widget
zle -N accept-line _highlight_command_and_execute
