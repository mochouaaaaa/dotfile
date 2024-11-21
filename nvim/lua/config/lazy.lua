vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 0.9 版本开始自带缓存加速
vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- Set border style
local enable_border = not vim.g.neovide
vim.g.border = {
    enabled = enable_border,
    style = enable_border and "rounded" or { " " },
    borderchars = enable_border and { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
        or { " ", " ", " ", " ", " ", " ", " ", " " },
}

require("lazy").setup({
    spec = {
        { "nvim-lua/plenary.nvim" },
        -- 添加 LazyVim 并且导入它的其他插件
        { "LazyVim/LazyVim" },
        { import = "plugins" },
    },
    ui = {
        border = vim.g.border.style,
        backdrop = 100,
    },
    defaults = {
        -- 默认情况下，只有 LazyVim 插件会被懒加载。 您的自定义插件将在启动过程中加载。
        -- 如果你知道你在做什么，你可以将它设置为 `true` 来默认懒加载你所有的自定义插件。
        lazy = false,
        -- 建议现在先远离 version=false，因为许多支持版本的插件已经
        -- 过时了，这可能会破坏您的NeoVim安装。
        version = false, -- 永远使用最新的 git commit 版本
    },
    install = { colortscheme = { "mocha" } },
    checker = { enabled = false }, -- 自动检查插件更新
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

require("config.init")
