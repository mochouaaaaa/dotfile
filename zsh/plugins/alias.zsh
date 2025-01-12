source $HOME/.config/zsh/utils.zsh

hash -d desktop="$HOME/Desktop"
hash -d downloads="$HOME/Downloads"
hash -d documents="$HOME/Documents"
hash -d videos="$HOME/Videos"
hash -d music="$HOME/Music"
hash -d pictures="$HOME/Pictures"
hash -d movies="$HOME/Movies"
hash -d trash="$HOME/.Trash"


alias ..="cd .."
alias ~="cd ~"
alias -- -="cd -"

# _bat_or_cat(){
#     if [[ -f "$1" ]]; then
#         case "$(file --brief --mime-type "$1")" in
#             image/*) kitty icat "$1" ;;
#             *) bat -p "$1" ;;
#         esac
#     fi
# }

check_command_exist "neovide" "alias neovide='neovide $@ --frame buttonless --fork'"
check_command_exist "lazygit" "alias lazygit='lazygit --use-config-file=\"$HOME/.config/lazygit/config.yml\"'"

check_command_exist "bat" "alias cat='bat -p --style=plain'"

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
    alias yazi=_yazi
    if [[ -n "$YAZI_ID" ]]; then
        function _yazi_cd() {
            ya pub dds-cd --str "$PWD"
        }
        add-zsh-hook zshexit _yazi_cd
    fi
fi
