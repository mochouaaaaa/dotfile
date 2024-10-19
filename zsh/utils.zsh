# 判断操作系统类型的函数
check_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # 如果是 macOS，返回 1
        return 1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 如果是 Linux，返回 0
        return 0
    else
        # 其他操作系统
        echo "Unknown OS"
        return 2
    fi
}


# check_command_exist() {
#     if command -v "$1" &> /dev/null; then
#         if [[ -n "$2" ]]; then
#             if ! type "$2" &> /dev/null; then
#                 eval "$2"
#             fi 
#         fi
#         return 0
#     else
#         return 1
#     fi
# }


check_command_exist() {
    if (( $+commands[$1] )); then
        if [[ -n "$2" ]]; then
            if ! type "$2" &> /dev/null; then
                eval "$2"
            fi 
        fi
        return 0
    else
        return 1
    fi
}


