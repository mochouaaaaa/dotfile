#/bin/sh

# 进入当前目录
cd $(dirname $0)

# exclude current file
files=$(ls -a | grep -vE '^\.$|^\.\.$|install.sh')

# 遍历所有文件
for file in $files
do
  # 如果是文件夹则跳过
  if [ -d $file ]; then
    continue
  fi

  # 如果是文件则创建软连接
  ln -s $PWD/$file $HOME/.$file
   echo "create link $file to $HOME/.$file"
done

