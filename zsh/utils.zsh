# 判断操作系统类型的函数
check_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # 如果是 macOS，返回 1
        echo 1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 如果是 Linux，返回 0
        echo 0
    else
        # 其他操作系统
        echo "Unknown OS"
        echo 2
    fi
}

check_command_exist() {
    if (( $+commands[$1] )); then
        if [[ -n "$2" ]] && ! type "$2" &>/dev/null; then
            eval "$2"
        fi
        return 0
    else
        return 1
    fi
}

_lazyload_add_command() {
    eval "$1() { \
        unfunction $1; \
        _sukka_lazyload_command_$1; \
        $1 \$@; \
    }"
}

_lazyload_add_completion() {
    local comp_name="_sukka_lazyload__compfunc_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _sukka_lazyload_completion_$1; \
    }"
    compdef $comp_name $1
}
