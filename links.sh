#/bin/sh

# 进入当前目录
cd $(dirname $0)

# exclude current file
files=$(ls | grep -vE '\*')

# 遍历所有文件
for file in $files; do
    # 如果是不文件夹则跳过
    if [ -d $file ]; then
        ln -sf $PWD/$file $HOME/.config/$file
        echo "create link $file to $HOME/.config/$file"
    fi
done
