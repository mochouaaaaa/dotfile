
autoload -U compaudit compinit
autoload -Uz compinit && compinit

PWD_PATH=$HOME/.config/zsh
PLUGIN_PATH=$PWD_PATH/plugins

for i ($PLUGIN_PATH/*.zsh) {
        source $i
}

