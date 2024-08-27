#!/bin/bash

# 解析参数
key="${1%%:*}"
mods="${1#*:}"

# 定义修饰键到修饰码的映射
declare -A mod_map
mod_map=(
    ["SHIFT"]=1
    ["ALT"]=2
    ["CTRL"]=4
    ["CMD"]=8
)

# 生成 CSI 序列的函数
get_csi_sequence() {
    local mod_code=0

    IFS='|' read -ra ADDR <<<"$mods"
    for mod in "${ADDR[@]}"; do
        if [[ -n "${mod_map[$mod]}" ]]; then
            mod_code=$((mod_code + mod_map[$mod]))
        fi
    done

    # 生成并返回 CSI 序列
    local csi_sequence
    csi_sequence=$(printf '[%d;%du' "'$key" $((mod_code + 1)))
    echo "$csi_sequence"
}

# 调用函数生成 CSI 序列
get_csi_sequence
