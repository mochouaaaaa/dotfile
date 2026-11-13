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

Kitty uses its native `--when-focus-on var:IS_NVIM` and
`--when-focus-on var:IS_TMUX` mappings. The conditions match Kitty window user
variables published with OSC 1337; they do not inspect environment variables or
the local foreground process. No Python `send_key.py` kitten is needed.

### Neovim (local and SSH)

The Neovim module in `nvim/lua/util/terminal_context.lua` publishes
`IS_NVIM` on `VimEnter`, `VimResume`, and `UIEnter`, then unsets it on
`VimLeave` and `VimSuspend`. It uses Neovim's `nvim_ui_send()` when
available and falls back to writing the escape sequence to stdout.

This works for both ordinary `ssh` and `kitten ssh`: install the same Neovim
configuration on the remote host and use an interactive SSH PTY. The remote
host does **not** need tmux. Kitty receives the OSC sequence through the SSH
terminal stream and switches to the Neovim conditional mappings.

### tmux (optional)

Only when a session uses tmux, include `tmux/tmux.conf` from the existing
tmux configuration:

```tmux
source-file ~/path/to/dotfile/tmux/tmux.conf
```

This enables DCS passthrough so Neovim's OSC 1337 state reaches the outer Kitty
window, enables extended-key reporting, and forwards focus events. It does not
replace the rest of your tmux configuration or change the existing `Ctrl+A`
prefix.

### Detecting tmux

The `wezterm/scripts/wezterm.sh` shell integration publishes `IS_TMUX` when
the current shell is inside tmux and sets it before launching tmux. Source it
from the interactive Bash/Zsh startup file on machines where you use tmux:

```sh
source /absolute/path/to/dotfile/wezterm/scripts/wezterm.sh
```

For ordinary SSH, install/source this script on the remote host only if you
also use remote tmux. The same applies to `kitten ssh`: its built-in shell
integration does not automatically load this custom script. If you do not use
tmux remotely, no remote shell integration is required for `IS_NVIM`.


## Hyprland keymap notes

The compositor deliberately leaves the terminal's unified shortcuts unbound:
- `SUPER+HJKL`: terminal/TUI navigation (for example TUIOS)
- `SUPER+CTRL+HJKL`: terminal pane splitting
- `CTRL+SHIFT+HJKL`: terminal pane resizing
- `SUPER+1..6`: terminal window selection
- `SUPER+ENTER`: terminal pane/window maximize

Hyprland uses `ALT+HJKL` for compositor focus, `SUPER+SHIFT+HJKL` for
compositor window resizing, and `SUPER+ALT+1..6` / `SUPER+ALT+SHIFT+1..6`
for workspace focus / moving a window. This avoids global compositor binds
stealing keystrokes from terminal applications.
