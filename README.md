# Config

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

# FAQ

- Q: ZSH, NVIM, KITTY缺少入口文件

```bash
cat $HOME/.zshrc << EOF
source $HOME/.config/zsh/init.zsh
EOF

cat $HOME/.config/nvim/init.lua << EOF
require('config.lazy')
EOF

cat $HOME/.config/kitty/kitty.conf << EOF
include init.conf
EOF
```


## Unified Kitty / tmux / Neovim keymap context

The Kitty keymap files use the terminal user variables `IS_TMUX` and
`IS_NVIM` to decide whether a shortcut belongs to Kitty, tmux, or Neovim.
The foreground process seen by Kitty is only `ssh` during an SSH session, so
process-name detection cannot reliably identify programs running on the remote
host.

### Shell integration (local and remote)

Source the existing shell integration script from the interactive shell
startup file on **both the local machine and each SSH host**:

```sh
source /absolute/path/to/dotfile/wezterm/scripts/wezterm.sh
```

The script supports interactive Bash and Zsh. It preserves the existing
`WEZTERM_IN_TMUX` variable and also publishes `IS_TMUX` for Kitty. When tmux
starts, the flag is set before control enters tmux; the next prompt hook clears
it after returning to the parent shell.

For ordinary `ssh`, install the dotfiles on the remote host and source the
script from that host's shell startup file. SSH transports the terminal escape
sequences through its PTY.

For `kitten ssh`, Kitty's SSH kitten can copy the script to the remote host.
Add a host-specific rule to `~/.config/kitty/ssh.conf` (replace the local path
with the actual checkout path):

```conf
hostname *
copy --dest .config/dotfile/wezterm.sh /absolute/path/to/dotfile/wezterm/scripts/wezterm.sh
```

Then source `$HOME/.config/dotfile/wezterm.sh` from the remote shell startup
file. The SSH kitten installs Kitty shell integration automatically, but
custom dotfiles still need to be copied and sourced.

### tmux

Include `tmux/tmux.conf` from the existing tmux configuration:

```tmux
source-file ~/path/to/dotfile/tmux/tmux.conf
```

The snippet enables tmux passthrough for OSC 1337 context updates and enables
extended-key reporting. It does not replace the rest of your tmux configuration
or change the existing `Ctrl+A` prefix.

### Neovim

Neovim publishes `IS_NVIM` on `VimEnter` and removes it on `VimLeavePre`.
The sequence is wrapped in tmux's DCS passthrough format when Neovim runs inside
tmux, so the outer Kitty window can switch to the Neovim keymap and restore the
tmux/shell keymap after Neovim exits.
