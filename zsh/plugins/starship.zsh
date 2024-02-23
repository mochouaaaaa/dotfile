# brew install starship

# git plugin
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure


export STARSHIP_CONFIG=$HOME/.config/zsh/config/starship.toml

eval "$(starship init zsh)"


