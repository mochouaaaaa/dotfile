source $HOME/.config/zsh/utils.zsh

export BAT_THEME="Catppuccin-macchiato"

check_command_exist "btop" "alias top=btop"
check_command_exist "fd" "alias find=fd"
check_command_exist "dust" "alias du=dust"

if check_command_exist "lsd"; then
    alias ls="lsd --hyperlink=auto"
    alias ll='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
fi 

check_command_exist "procs" "alias ps=procs"

check_command_exist "rg" "alias rg='rg --hyperlink-format=kitty'"

if check_command_exist "nvim"; then
    _nvim ()
    {
        if [[ $# -gt 0  ]]; then
            nvim "$@"
        else
                nvim .
        fi
    }
    alias vim="_nvim"
    alias nvim="_nvim"
fi

if check_command_exist "yazi"; then
    function _yazi() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
    alias yazi="_yazi"
fi
