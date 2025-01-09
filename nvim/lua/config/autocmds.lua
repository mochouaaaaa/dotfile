local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Automatic save
-- require("util.autosave").setup()

-- Terminal option
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	callback = function()
		vim.b.minianimate_disable = true
		vim.b.miniindentscope_disable = true
		vim.opt_local.spell = false
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
	desc = "Set terminal buffer options",
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
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
	callback = function(args)
		-- the buffer where the lsp attached
		---@type number
		local buffer = args.buf

		-- create the autocmd to show diagnostics
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
			buffer = buffer,
			callback = function()
				vim.diagnostic.open_float(nil, { focus = false })
			end,
		})
	end,
})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.hl", "hypr*.conf" },
	callback = function(event)
		vim.lsp.start({
			name = "hyprlang",
			cmd = { "hyprls" },
			root_dir = vim.fn.getcwd(),
		})
	end,
})
