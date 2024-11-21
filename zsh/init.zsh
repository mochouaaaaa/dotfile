
PWD_PATH=$HOME/.config/zsh
PLUGIN_PATH=$PWD_PATH/plugins

for i ($PLUGIN_PATH/*.zsh) {
    # zinit snippet "$i"
    source "$i"
}

