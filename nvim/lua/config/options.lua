vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local g = vim.g
local o = vim.o

opt.conceallevel = 0
g.lazyredraw = true
opt.clipboard = "unnamedplus"
opt.updatetime = 200

if vim.env.SSH_TTY then
	local function paste()
		return {
			vim.split(vim.fn.getreg(""), "\n"),
			vim.fn.getregtype(""),
		}
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
	}
end

-- 行号
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.list = false
-- opt.list = true
-- opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"

g.max_file = { size = 100 * 1024 * 1024, lines = 10000 }
g.ui_notifications_enabled = true
g.git_worktrees = nil

-- 防止包裹
opt.wrap = true

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

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

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- 添加编码支持
opt.fileencodings = "utf-8,gbk,gb18030,gb2312,ucs-bom,cp936,big5,euc-jp,euc-kr"

o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- UI

opt.wildoptions = "pum"
opt.winborder = "rounded"

opt.fillchars = {
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
o.shortmess = "fimnxsTAIcF"

-- 增强搜索
opt.inccommand = "split"

-- ================== 性能与行为 ==================
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Cache/Log file
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("$HOME/.cache/nvim/undo")
opt.backupdir = vim.fn.expand("$HOME/.cache/nvim/backup")
opt.viewdir = vim.fn.expand("$HOME/.cache/nvim/view")

-- Misc
opt.history = 1000
opt.wildignorecase = true

o.timeout = true
o.ttimeoutlen = 50
o.timeoutlen = 100

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0

opt.smoothscroll = true

-- folding
o.foldlevel = 99

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
