return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	lazy = true,
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local gs = package.loaded.gitsigns

			local wk = require("which-key")
			wk.add({
				{ "<leader>ga", group = "add" },
				{
					"<leader>gab",
					gs.stage_hunk,
					desc = "hunk",
				},
				{
					"<leader>gaf",
					gs.stage_buffer,
					desc = "file",
				},

				{ "<leader>gt", group = "toggle" },
				{
					"<leader>gth",
					function()
						gs.diffthis("~")
					end,
					desc = "diff file",
				},
				{
					"<leader>gtd",
					gs.toggle_deleted,
					desc = "deleted",
				},
				{ "<leader>gh", group = "hunk" },
				{
					"<leader>ghp",
					function()
						gitsigns.preview_hunk()
					end,
					desc = "preview ",
				},
				{
					"<leader>ghk",
					function()
						if vim.wo.diff then
							return "g["
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end,
					desc = "previous",
				},
				{
					"<leader>ghj",
					function()
						if vim.wo.diff then
							return "g]"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end,
					desc = "next",
				},
				{ "<leader>gr", group = "undo" },
				{
					"<leader>grb",
					gs.reset_hunk,
					desc = "revert hunk",
				},
				{
					"<leader>grf",
					gs.reset_buffer_index,
					desc = "stage file",
				},
				{
					mode = "v",
					{
						{ "<leader>ga", group = "add" },
						{
							"<leader>gab",
							function()
								gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
							end,
							desc = "stage hunk",
						},

						{ "<leader>gr", group = "undo" },
						{
							"<leader>grb",
							function()
								gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
							end,
							desc = "reset hunk",
						},
					},
				},
			})
		end,

		signs = {
			add = {
				text = "+",
			},
			change = {
				text = "~",
			},
			delete = {
				text = "x",
			},
			topdelete = {
				text = "‾",
			},
			changedelete = {
				text = "~",
			},
			untracked = { text = "┆" },
		},
		worktrees = vim.g.git_worktrees,
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		watch_gitdir = { interval = 1000, follow_files = true },
		attach_to_untracked = true,
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			delay = 0,
			ignore_whitespace = false,
		},
		-- current_line_blame_formatter_opts = { relative_time = true },
		current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	},
}
