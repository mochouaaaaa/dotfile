# brew install goenv

# goenv
export GOENV_ROOT="$HOME/.config/env/goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export GOPATH=/Volumes/Code/Projects/golang
export PATH="$PATH:$GOPATH:$GOPATH/bin"
export PATH="$GOROOT/bin:$PATH"

export GOPROXY=https://goproxy.cn,direct
export GOSUMDB=sum.golang.google.cn
export GOENV_DISABLE_GOPATH=1
