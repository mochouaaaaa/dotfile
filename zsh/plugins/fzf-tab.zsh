if (( $+commands[fzf] )) &>/dev/null; then
    source <(fzf --zsh)
fi

# build-fzf-tab-module  二进制执行
zsh-defer zinit light Aloxaf/fzf-tab
zsh-defer zinit light Freed-Wu/fzf-tab-source

# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# solving fzf border problems
export RUNEWIDTH_EASTASIAN=0
export FZF_COMPLETION_TRIGGER="**"

export FZF_DEFAULT_COMMAND="fd --hidden --follow -I --exclude={Pods,.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc 
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 
--tmux 
--height 60% 
--layout reverse 
--sort 
--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -N -C {}) 2> /dev/null | head -500' 
--preview-window right:50%:wrap 
--bind '?:toggle-preview' 
--border 
--cycle 
--select-1 --exit-0
"

# CTRL-T
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
# CLT-C
export FZF_ALT_C_OPTS="
--walker-skip .git,node_modules,target
--preview 'tree -C {} | head -200'
"

# CTRL-R
export FZF_CTRL_R_OPTS="
--layout=reverse
--no-sort
--exact
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind '?:toggle-preview'
--border
--cycle
"

# ctrl-x + ctrl+r 得到的命令直接运行
# fzf-history-widget-accept() {
#   fzf-history-widget
#   zle accept-line
# }
# zle      -N    fzf-history-widget-accept
# bindkey '^X^R' fzf-history-widget-accept

# tmux
export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-pad 30 0
zstyle ':fzf-tab:*' fzf-flags --preview-window=down:9:hidden:wrap
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':completion:*:eza' file-sort modification
zstyle ':completion:*:eza' sort false

# cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # remember to use single quote here!!!

# ps/kill
# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# show file content
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview

# env variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# Homebrew
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

# Commands
zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "${(P)word}"'

# tldr
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'
