vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local g = vim.g
local o = vim.o

opt.conceallevel = 0
-- opt.list = true
-- opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
opt.updatetime = 100

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

g.max_file = { size = 100 * 1024 * 1024, lines = 10000 }
g.ui_notifications_enabled = true
g.git_worktrees = nil

-- 防止包裹
opt.wrap = true

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")
-- 系统剪切板
opt.clipboard:append("unnamedplus")

-- 默认新窗口由和下
opt.splitright = true
opt.splitbelow = true

-- 搜索大小写不敏感，除非包含大写
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"

opt.showmode = false

-- 当文件被外部程序修改时，自动加载
opt.autoread = true
vim.bo.autoread = true

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- 添加编码支持
opt.fileencodings = "utf-8,gbk,gb18030,gb2312,ucs-bom,cp936,big5,euc-jp,euc-kr"

-- 取消回车自动添加注释
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- UI

vim.opt.fillchars = {
    diff = "╱",
    eob = " ",
    stl = " ",
    stlnc = " ",
    wbr = " ",
    horiz = "─",
    horizup = "┴",
    horizdown = "┬",
    vert = "│",
    vertleft = "┤",
    vertright = "├",
    verthoriz = "┼",
}

o.winblend = 0
o.pumblend = 0
o.pumheight = 15

o.showmode = false
o.showcmd = false
o.cmdheight = 0
o.laststatus = 3

o.ruler = false
o.signcolumn = "yes"
o.shortmess = "fimnxsTAIcF"

-- Cache/Log file
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("$HOME/.cache/nvim/undo")
opt.backupdir = vim.fn.expand("$HOME/.cache/nvim/backup")
opt.viewdir = vim.fn.expand("$HOME/.cache/nvim/view")
vim.lsp.set_log_level("info")

-- Misc
opt.history = 1000
opt.wildignorecase = true

o.timeout = true
o.timeoutlen = 500

-- g.loaded_gzip = 1
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
-- g.loaded_matchparen = 1
-- g.loaded_tar = 1
-- g.loaded_tarPlugin = 1
-- g.loaded_zip = 1
-- g.loaded_zipPlugin = 1

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

opt.smoothscroll = true

-- folding
o.foldlevel = 99
o.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
