
source $HOME/.config/zsh/utils.zsh

if [[ $(check_os_type) == 0 ]]; then

    # ENV
    export GOPATH=$HOME/Code/Projects/golang

    export PATH=$PATH:$HOME/.local/kitty.app/bin

    alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --new-window"

    if [[ -d "$HOME/.linuxbrew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
        export BREW_PATH="$HOME/.linuxbrew/opt"
    elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        export BREW_PATH="/home/linuxbrew/.linuxbrew/opt"
    fi

    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        alias gnome-control-center="XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
    fi
elif [[ $(check_os_type) == 1 ]]; then
    export GOPATH=/Volumes/Code/Projects/golang
    hash -d code="/Volumes/Code"

   export BREW_PATH="/usr/local/opt"
    
   export PATH="$BREW_PATH/swift/bin:$PATH" 

   # brew
   export PATH="$BREW_PATH/sqlite/bin:$PATH"
   export PATH="$BREW_PATH/tcl-tk/bin:$PATH"
   export PATH="$BREW_PATH/mysql-client/bin:$PATH"
   export PKG_CONFIG_PATH="$BREW_PATH/mysql-client/lib/pkgconfig"
fi

# brew install zoxide
eval "$(zoxide init zsh)"
alias j="z"
