local Terminal = require("toggleterm.terminal").Terminal

local terminal = Terminal:new {
	open_mapping = [[<C-\>]],
	size = function(term)
		return ({
			horizontal = vim.o.lines * 0.3,
			vertical = vim.o.columns * 0.35,
		})[term.direction]
	end,
	start_in_insert = true,
	persist_mode = false,
	autochdir = true,
	persistent = true,
	colse_on_exit = true,
	auto_scroll = true,
	direction = "float", --[[ 'vertical' | 'horizontal' | 'tab' | 'float', ]]
	float_opts = {
		border = "rounded",
	},

	-- function to run on opening the terminal
	on_open = function(term)
		vim.cmd("set mouse=")
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		vim.cmd("set mouse=a")
		vim.cmd("startinsert!")
	end,
}

function _terminal_toggle() terminal:toggle() end

vim.api.nvim_set_keymap(
	"n",
	"<C-\\>",
	"<cmd>lua _terminal_toggle()<CR>",
	{ noremap = true, silent = true, desc = "terminal" }
)
