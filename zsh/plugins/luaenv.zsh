
export LUAENV_ROOT="/Volumes/Code/tools/.luaenv"

# git clone https://github.com/cehoffman/luaenv.git $LUAENV_ROOT
# git clone https://github.com/cehoffman/lua-build.git $LUAENV_ROOT/plugins/lua-build
# git clone https://github.com/xpol/luaenv-luarocks.git $LUAENV_ROOT/plugins/luaenv-luarocks

command -v luaenv >/dev/null || export PATH="$LUAENV_ROOT/bin:$PATH"
eval "$(luaenv init -)"

export MACOSX_DEPLOYMENT_TARGET=12.7
# export LUAENV_VERSION=5.2.4
