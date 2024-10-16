#!/bin/bash

source $HOME/.config/zsh/scripts/utils.sh

ENV=$HOME/.config/env
if [[ ! -d "$ENV" ]]; then
    mkdir $ENV
fi

if [[ ! -d "$ENV/luaenv" ]]; then
    cd $ENV
    echo "Installing lua and luarocks... Enviroment"
    git clone https://github.com/cehoffman/luaenv.git
    git clone https://github.com/cehoffman/lua-build.git $LUAENV_ROOT/plugins/lua-build
    git clone https://github.com/xpol/luaenv-luarocks.git $LUAENV_ROOT/plugins/luaenv-luarocks
fi

if [[ ! -d "$ENV/nodenv" ]]; then
    cd $ENV
    echo "Installing node and npm... Enviroment"
    git clone https://github.com/nodenv/nodenv.git
    cd $ENV/nodenv && src/configure && make -C src
    cd $ENV
    git clone https://github.com/nodenv/node-build.git "$NODENV_ROOT"/plugins/node-build
    git clone https://github.com/nodenv/nodenv-vars.git "$NODENV_ROOT"/plugins/nodenv-vars
    git clone https://github.com/nodenv/nodenv-aliases.git $NODENV_ROOT/plugins/nodenv-aliases
fi

if [[ ! -d "$ENV/goenv" ]]; then
    cd $ENV
    echo "Installing go... Enviroment"
    cd $ENV
    git clone https://github.com/go-nv/goenv.git
fi

if [[ ! -d "$ENV/pyenv" ]]; then
    if [[ $(check_os_type) == 1 ]]; then
        brew install openssl readline sqlite3 xz zlib tcl-tk ccache
    fi
    cd $ENV
    echo "Installing python... Enviroment"
    git clone https://github.com/pyenv/pyenv.git
    cd pyenv && src/configure && make -C src
    cd $ENV
    git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv
    git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $PYENV_ROOT/plugins/pyenv-virtualenvwrapper
    git clone https://github.com/pyenv/pyenv-pip-migrate.git $PYENV_ROOT/plugins/pyenv-pip-migrate
    git clone https://github.com/pyenv/pyenv-update.git $PYENV_ROOT/plugins/pyenv-update
    git clone https://github.com/pyenv/pyenv-ccache.git $PYENV_ROOT/plugins/pyenv-ccache
    git clone https://github.com/jawshooah/pyenv-default-packages.git $PYENV_ROOT/plugins/pyenv-default-packages
    git clone https://github.com/s1341/pyenv-alias.git $PYENV_ROOT/plugins/pyenv-alias
    git clone https://github.com/sprout42/pyenv-fix-version.git $PYENV_ROOT/plugins/pyenv-fix-version
    git clone https://github.com/real-yfprojects/pyenv-link.git $PYENV_ROOT/plugins/pyenv-link
    git clone https://github.com/concordusapps/pyenv-implict.git $PYENV_ROOT/plugins/pyenv-implict
fi
