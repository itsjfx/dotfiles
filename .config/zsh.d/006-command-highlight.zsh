# Command execution highlighting
# Highlights commands in purple before execution for better visual separation in history

# Custom accept-line widget that highlights the command before execution
_highlight_command_and_execute() {
    local HIGHLIGHT_BG_COLOR='\033[48;5;234m' # or 235
    local HIGHLIGHT_TEXT_COLOR='\033[38;5;207m'
    # local HIGHLIGHT_BG_COLOR='\033[38;5;206;48;5;57m'
    # local HIGHLIGHT_BG_COLOR='\033[38;5;206;48;5;236m'
    local HIGHLIGHT_RESET='\033[0m'         # Reset all colors

    local current_buffer="$BUFFER"

    # Early return if buffer is empty or only whitespace - no highlighting needed
    if [[ -z "$current_buffer" ]] || [[ ! "$current_buffer" =~ [^[:space:]] ]]; then
        zle .accept-line
        return
    fi

    # Highlight the command since we know it contains actual content
    # Move to beginning of line and clear it
    printf '\r\033[2K'

    # Apply background with purple text to entire terminal line
    printf "${HIGHLIGHT_BG_COLOR}${HIGHLIGHT_TEXT_COLOR}"  # Start background with purple text
    print -nP "$PROMPT"  # Prompt with original colors on background
    printf "${HIGHLIGHT_BG_COLOR}${HIGHLIGHT_TEXT_COLOR}%s" "$current_buffer"  # Command with background and purple text

    # Use a simpler approach - just fill to the end regardless of calculation
    # This ensures we always get full terminal width coverage
    printf "${HIGHLIGHT_BG_COLOR}\033[K"  # Fill to end of line with current background color
    printf "${HIGHLIGHT_RESET}"  # Reset colors

    # Execute the original accept-line
    zle .accept-line
}

# Register the widget
zle -N accept-line _highlight_command_and_execute
