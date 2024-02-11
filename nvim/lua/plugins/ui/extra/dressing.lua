local M = {
	"stevearc/dressing.nvim",
	lazy = true,
	init = function()
		vim.ui.select = function(...)
			require("lazy").load { plugins = { "dressing.nvim" } }
			return vim.ui.select(...)
		end
		vim.ui.input = function(...)
			require("lazy").load { plugins = { "dressing.nvim" } }
			return vim.ui.input(...)
		end
	end,
}

M.opts = {
	input = {
		insert_only = false,
		win_options = { winblend = 0 },
		mappings = {
			n = {
				["<Esc>"] = "Close",
				["<CR>"] = "Confirm",
			},
			i = {
				["<CR>"] = "Confirm",
				["<C-u>"] = "HistoryPrev",
				["<C-e>"] = "HistoryNext",
			},
		},
	},
	select = {
		backend = {
			"telescope",
			"builtin",
			"nui",
		},
		-- get_config = function(opts)
		-- if opts.kind == "codeaction" then
		-- 	return {
		-- 		backend = "telescope",
		-- 		-- telescope = require("telescope.themes").get_cursor {
		-- 		-- 	-- initial_mode = "normal",
		-- 		-- 	layout_config = { height = 15 },
		-- 		-- },
		-- 		telescope = require("telescope.themes").get_dropdown(),
		-- 	}
		-- end

		-- return { backend = "telescope", telescope = nil }
		-- end,
	},
}

return M
