if [[ $TERM_PROGRAM == "Kitty" ]]; then
    if command -v kitty >/dev/null 2>&1; then
        # Completion for kitty
        kitty +complete setup zsh | source /dev/stdin

        alias ssh="kitty +kitten ssh"
    fi
fi

if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
    # export IS_WEZTERM="1"
    # printf "\033]1337;SetUserVar=IS_WEZTERM=MQ==\007"
    # source $HOME/.config/wezterm/scripts/wezterm.sh
    alias ssh="wezterm ssh"
fi

