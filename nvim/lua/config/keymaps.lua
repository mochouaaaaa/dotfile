local _key = require("util.keymap")

local mode_n = { "n" }
local mode_v = { "v" }
local mode_i = { "i" }
local mode_t = { "t" }
local mode_nv = { "n", "v" }
local mode_ni = { "n", "i" }
local opt_n = { noremap = true }
local opt_ns = { noremap = true, silent = true }
local opt_nb = { noremap = true, buffer = true }

vim.g.kitty_navigator_enable_stack_layout = true
vim.g.kitty_navigator_no_mappings = 1

original_map = {}

local mappings = {

	-- disbaled insert mode
	-- { from = "<Tab>", to = "<Nop>", mode = mode_ni }, -- Will be handled in `plugins/completion.lua`
	{ from = "<Space>", to = "<Nop>", mode = mode_n },
	{ from = "<C-j>", to = "<Nop>", mode = mode_n },
	{ from = "<C-k>", to = "<Nop>", mode = mode_n },
	{ from = _key.platform_key.cmd .. "-e>", to = "<Nop>", mode = mode_i, opt = opt_n },
	{ from = _key.platform_key.cmd .. "-f>", to = "<Nop>", mode = mode_i, opt = opt_n },
	{ from = _key.platform_key.cmd .. "-F>", to = "<Nop>", mode = mode_i, opt = opt_n },
	{ from = _key.platform_key.cmd .. "-s>", to = "<Nop>", mode = mode_i, opt = opt_n },
	{ from = _key.platform_key.cmd .. "-S>", to = "<Nop>", mode = mode_i, opt = opt_n },

	-- special keys
	{ from = ";", to = ":", mode = mode_nv },

	---------- 插入模式 ---------- ---
	{ from = "jk", to = "<ESC>", mode = mode_i },

	{ from = "q", to = "<Cmd>q<CR>", mode = mode_n },
	{ from = "qq", to = "<Cmd>q!<CR>", mode = mode_n },
	{ from = "Q", to = "<Cmd>qa!<CR>", mode = mode_n },
	{ from = _key.platform_key.cmd .. "-s>", to = "<Cmd>w<CR>", mode = mode_n, desc = "save file" },
	{ from = "<C-r>", to = "<Cmd>undo<CR>", mode = mode_ni, desc = "Undo" },
	{ from = _key.platform_key.cmd .. "-S-r>", to = "<Cmd>redo<CR>", mode = mode_ni, desc = "Redo" },

	-- ------ 视图模式
	-- 单行或多行移动
	{ from = "J", to = "<Cmd>m '>+1<CR>gv=gv<CR>", mode = mode_v },
	{ from = "K", to = "<Cmd>m '<-2<CR>gv=gv<CR>", mode = mode_v },
	{ from = "H", to = "<gv", mode = mode_v },
	{ from = "L", to = ">gv", mode = mode_v },
	{ from = "<S-down>", to = "<Cmd>m '>+1<CR>gv=gv", mode = mode_v },
	{ from = "<S-up>", to = "<Cmd>m '<-2<CR>gv=gv", mode = mode_v },
	{ from = "<S-Tab>", to = "<gv", mode = mode_v },
	{ from = "<Tab>", to = ">gv", mode = mode_v },

	-- insert 模式下，跳到行首行尾
	{ from = _key.platform_key.cmd .. "-h>", to = "<ESC>I", mode = mode_i },
	{ from = _key.platform_key.cmd .. "-l>", to = "<ESC>A", mode = mode_i },
	{ from = _key.platform_key.cmd .. "-j>", to = "<C-o>j", mode = mode_i, opt = opt_ns },
	{ from = _key.platform_key.cmd .. "-k>", to = "<C-o>k", mode = mode_i, opt = opt_ns },

	-- 正常模式
	-- 窗口
	{ from = "<leader>|", to = "<C-w>v", mode = mode_n, desc = "垂直新增窗" },
	{ from = "<leader>_", to = "<C-w>s", mode = mode_n, desc = "水平新增窗" },
	{ from = "<C-w>", to = "<Cmd>BufferLineCloseOther<CR>", mode = mode_n },
	{ from = "sc", to = "<C-w>c", mode = mode_n, desc = "关闭当前窗" },
	{ from = "so", to = "<C-w>o", mode = mode_n, desc = "关闭其他窗" },
}

for _, mapping in ipairs(mappings) do
	if mapping.desc then
		if not mapping.opt then
			mapping.opt = opt_n
		end
		mapping.opt.desc = mapping.desc
	end
	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, mapping.opt or {})
end
