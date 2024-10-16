#/bin/bash

function check_os_type() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Mac"
    else
        echo "Unknown"
    fi
}

function check_command_exists() {
    if ! command -v "$1" &>/dev/null; then
        echo "Command $1 not found, installing..."
        $2
    fi
}

source ./packages.sh

os_type=$(check_os_type)
# 根据系统类型选择安装命令
if [[ "$os_type" == "Mac" ]]; then
    install="brew"
elif [[ "$os_type" == "Linux" ]]; then
    install="sudo apt-get"
else
    echo "Unsupported OS"
    exit 1
fi

# 循环遍历每个包
for package in "${packages[@]}"; do
    # echo "Installing $package..."

    # 显示要执行的安装命令
    # echo "$install install $package"

    # 检查命令是否存在，不存在则安装
    check_command_exists $package "$install install -y $package"
done
