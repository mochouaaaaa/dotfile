zinit light Aloxaf/fzf-tab
zinit light Freed-Wu/fzf-tab-source
zinit snippet OMZL::git.zsh

if ! command -v fzf >/dev/null 2>&1; then
    echo "exec 'brew install fzf'"
else
    source <(fzf --zsh)
fi
# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# solving fzf border problems
export RUNEWIDTH_EASTASIAN=0
export FZF_COMPLETION_TRIGGER="**"

export FZF_DEFAULT_COMMAND="fd --hidden --follow -I --exclude={Pods,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"
# export FZF_DEFAULT_OPTS="--height=45% --layout=reverse --info=inline --border --margin=1 --padding=1"
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--tmux \
--height 60% \
--layout reverse \
--sort \
--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -N -C {}) 2> /dev/null | head -500' \
--preview-window right:50%:wrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"

# CTRL-T
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
# CLT-C
export FZF_CTRL_E_OPTS="--preview 'tree -C {} | head -200'"

# CTRL-R
export FZF_CTRL_R_OPTS="
--layout=reverse
--sort
--exact
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind '?:toggle-preview'
--border
--cycle
"

# ctrl-x + ctrl+r 得到的命令直接运行
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle -N fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# tmux
export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 30 0
zstyle ':fzf-tab:*' fzf-flags --preview-window=down:3:hidden:wrap
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false

# cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath' # remember to use single quote here!!!

# ps/kill
# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# show file content
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
export LESSOPEN='|~/.lessfilter %s'
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview


# env variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# fzfp() {
#   fzf --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always{} || rougify {}  || highlight -O ansi -l {} || coderay {} || cat {}) 2> /dev/null | head -500'
# }
#
# #文件查找
# alias fzf.w="fzf --height 40% --layout reverse --info inline --border \
#     --preview 'file {}' --preview-window down:1:noborder \
#     --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
#
# #文件预览
# alias fzf.p="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
# alias f="fzf.p"
#
# Homebrew
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

# Commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# tldr
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

