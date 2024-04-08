# brew install goenv

# goenv
eval "$(goenv init -)"

export GOPATH=/Volumes/Code/Projects/golang
export PATH="$PATH:$GOPATH:$GOPATH/bin"
export GOPROXY=https://goproxy.cn,direct
export GOSUMDB=sum.golang.google.cn

export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT="/Volumes/Code/tools/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
export PATH="$GOROOT/bin:$PATH"
