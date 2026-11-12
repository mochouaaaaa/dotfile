local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt

-- 取消回车自动添加注释
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Restore cursor position when opening a file -- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") or ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})

-- Keep Kitty's conditional keymaps in sync with the active Neovim process.
local terminal_context = require("util.terminal_context")
local terminal_context_group = augroup("terminal_context", { clear = true })

autocmd("VimEnter", {
	group = terminal_context_group,
	callback = terminal_context.enter,
})

autocmd("VimLeavePre", {
	group = terminal_context_group,
	callback = terminal_context.leave,
})
