
autoload -U compaudit compinit
autoload -Uz compinit && compinit

PWD_PATH=$HOME/.config/zsh
PLUGIN_PATH=$PWD_PATH/plugins

for i ($PLUGIN_PATH/*.zsh) {
    #if [ $i != "$PWD_PATH/init.zsh" ]; then
        source $i
    #fi
}

function restart_icloud() {
    killall bird
    killall cloudd
    echo "iCloud restarted"
}
