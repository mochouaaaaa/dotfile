
PWD_PATH=$HOME/.config/zsh
PLUGIN_PATH=$PWD_PATH/plugins

source $PLUGIN_PATH/system.zsh
for i ($PLUGIN_PATH/*.zsh) {
    # zinit snippet "$i"
    source "$i"
}

