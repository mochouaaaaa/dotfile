# Config

# Branch

- master use telescope search
- fzf use fzf-lua search

## Rules

- 该文件夹是全局规则

## Kitty/Wezterm(Tmux) Termianl keymap

| 功能               | 快捷键               |  Kitty   | Wezterm  |   Tmux   |
| :----------------- | :------------------- | :------: | :------: | :------: |
| 横向分屏           | ctrl+cmd+(h/l)       | &#10004; | &#10004; | &#10004; |
| 竖向分屏           | ctrl+cmd+(j/k)       | &#10004; | &#10004; | &#10004; |
| 窗口大小调整       | ctrl+shift+(j/k/h/l) | &#10004; | &#10004; | &#10004; |
| 创建窗口           | cmd+t                | &#10004; | &#10004; | &#10004; |
| 窗口跳转           | cmd+(1~6)            | &#10004; | &#10004; | &#10004; |
| 下一个Tab          | cmd+[                | &#10004; | &#10004; | &#10004; |
| 上一个Tab          | cmd+]                | &#10004; | &#10004; | &#10004; |
| 关闭当前窗口       | cmd+w                | &#10004; | &#10004; | &#10004; |
| 窗口重命名         | cmd+shift+k          | &#10004; | &#10004; | &#10004; |
| 任意窗口交换       | cmd+alt+[            | &#10004; | &#10004; | &#10008; |
| 任意窗口交换       | cmd+alt+]            | &#10004; | &#10004; | &#10008; |
| 窗口最大化         | cmd+enter            | &#10004; | &#10004; | &#10004; |
| 窗口编号快速跳转   | cmd+f                | &#10004; | &#10004; | &#10004; |
| 窗口内进行内容搜索 | cmd+shift+f          | &#10008; | &#10004; | &#10008; |
| 文件浏览器Yazi     | cmd+r                | &#10004; | &#10004; | &#10004; |

**这里的Tmux是可用是指这两个终端是否启用Tmux快捷键表现的与终端里面一致**

# QA

- 为什么zsh不配置.zshrc为什么
  因为zsh由nix接管, 如需不使用nix可以手动创建.zshrc然后创建以下内容

  ```bash
  source $HOME/.config/zsh/init.zsh
  ```

- nvim 为什么没有init.lua文件
  因为neovim由nix接管, 如需不使用nix可以手动创建init.lua然后创建以下内容

  ```lua
  require('config.lazy')
  ```

- kitty为什么没有kitty.conf文件
  因为kitty由nix接管, 如需不使用nix可以手动创建kitty.conf然后创建以下内容
  ```conf
  include init.conf
  ```
