
autoload -U compaudit compinit
autoload -Uz compinit && compinit

PWD_PATH=$HOME/.config/zsh
PLUGIN_PATH=$PWD_PATH/plugins

for i ($PLUGIN_PATH/*.zsh) {
    #if [ $i != "$PWD_PATH/init.zsh" ]; then
        source $i
    #fi
}

# Completion for kitty
kitty +complete setup zsh | source /dev/stdin


function restart_icloud() {
    killall bird
    killall cloudd
    echo "iCloud restarted"
}
