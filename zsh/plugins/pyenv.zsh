# brew install pyenv

# pyenv
export PYENV_ROOT="$HOME/.config/env/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# alias pyenv="env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv"
