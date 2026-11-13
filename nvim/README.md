# neovim

**Tree-sitter 插件与 parser 由 Nix 安装；LSP、formatter 等外部工具在非 Nix 环境下由 Mason 管理。设置 `IS_NIX=1` 后禁用 Mason。Lazy/LazyVim 不负责安装或更新 Tree-sitter。**

## Nix 集成

在 Home Manager / NixOS 的 Neovim 插件列表中安装 Tree-sitter 与所需 grammar（使用与 Neovim 相同的 nixpkgs）：

```nix
programs.neovim.plugins = with pkgs.vimPlugins; [
  (nvim-treesitter.withPlugins (p: with p; [
    bash
    c
    cpp
    css
    go
    html
    javascript
    json
    lua
    markdown
    markdown_inline
    nix
    python
    rust
    toml
    typescript
    vim
    vimdoc
    yaml
  ]))
];
```

也可以将 `nvim-treesitter.withPlugins (...)` 替换为 `nvim-treesitter.withAllGrammars` 安装全部可用 grammar。Lazy 配置会保留 Nix 的 `packpath` 并执行 `packloadall`，使 Nix 安装的 start plugin 正常加载。

### Lsp

| 功能              | 快捷键        |
| ----------------- | ------------- |
| 中断输入          | \<CMD-e>      |
| 代码联想选择      | CMD-(jk/上下) |
| 查看函数/方法说明 | K             |
| 查看函数定义      | \<leader>df   |
| 查看函数大纲      | \<leader>dg   |
| 函数改名          | \<leader>rn   |
| 错误诊断          | \<leader>ca   |
| 跳转到下一个诊断  | \<leader>c[   |
| 跳转到上一个诊断  | \<leader>c]   |

### 目录导航

| 功能               | 快捷键        |
| :----------------- | :------------ |
| 打开侧边目录       | \<CMD+e>      |
| 打开当前目录       | CR/L/H        |
| 目录和文件之间跳转 | <CMD-HL/左右> |
| 竖向分屏           | \<leader>\|   |
| 横向分屏           | \<leader>\_   |

### 快捷功能

| 功能                 | 快捷键          |
| :------------------- | --------------- |
| 注释(单行多行)       | \<CMD>+/        |
| 单行或者多行上下移动 | (J/K)/(S-上/下) |
| 单行或者多行前后移动 | (H/L)/(S-前/后) |
| 当前目录搜索文件     | \<CMD-f>        |
| 当前目录搜索文件内容 | \<CMD-S-f>      |
| 函数选择             | S               |

### 窗口操作

| 功能     | 快捷键              |
| -------- | ------------------- |
| 竖向切割 | \<leader>\|         |
| 横向切割 | \<leader>\_         |
| 窗口跳转 | CMD+(HJKL/上下左右) |

### Buffeline

| 功能               | 快捷键       |
| ------------------ | ------------ |
| 关闭当前buffer     | \<CMD>-w     |
| 关闭其他buffer     | \<leader>-bo |
| bufferline左右切换 | S-(HL/左右)  |

### LazyGit

| 功能         | 快捷键      |
| :----------- | ----------- |
| 打开git      | \<leader>gg |
| 单个文件缓存 | 空格        |
| 所有文件缓存 | a           |
| 提交本次缓存 | c           |
| 提交到远程   | P           |
| 拉取远程     | p           |

### Gitsigns

| 功能               | 快捷键           |
| :----------------- | ---------------- |
| 选中代码块add      | v -> \<leader>ga |
| 选中代码块回退     | v -> \<leader>gr |
| 查看代码块变动详细 | \<leader>gp      |
| 当前文件回退       | \<leader>gr      |
