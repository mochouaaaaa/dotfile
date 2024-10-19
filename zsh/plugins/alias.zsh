zinit snippet $HOME/.config/zsh/utils.zsh

alias ..="cd .."
alias ~="cd ~"
alias -- -="cd -"

export BAT_THEME="Catppuccin-macchiato"
check_command_exist "bat" "alias cat='bat -p'"

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

if check_command_exist "yazi"; then
    _yazi(){
        if [ -n "$YAZI_LEVEL" ]; then
            exit
        fi

        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
    # alias yazi=_yazi
    if [[ -n "$YAZI_ID" ]]; then
        function _yazi_cd() {	
            ya pub dds-cd --str "$PWD"
        }
        add-zsh-hook zshexit _yazi_cd
    fi
fi
