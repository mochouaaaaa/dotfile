return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
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
			delay = 1000,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
		word_diff = false,
		sign_priority = 6,
		update_debounce = 500,
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
	keys = function()
		local gs = require("gitsigns")

		return {
			{
				"<leader>gab",
				gs.stage_hunk,
				mode = { "v" },
				desc = "Stage Hunk",
			},
			{
				"<leader>gaf",
				gs.stage_buffer,
				desc = "Stage Buffer",
			},
			{
				"<leader>gm",
				"<CMD>Gitsigns blame_line<CR>",
				desc = "Commit Message",
			},
			{
				"<leader>gth",
				function()
					gs.diffthis()
				end,
				desc = "Diff File",
			},
			{
				"<leader>gtd",
				function()
					gs.preview_hunk_inline()
				end,
				desc = "Toggle Deleted",
			},
			{
				"<leader>ghp",
				function()
					gs.preview_hunk()
				end,
				desc = "Preview Hunk",
			},
			{
				"<leader>ghk",
				function()
					gs.nav_hunk({ preview = true })
				end,
				desc = "Prev Hunk",
			},
			{
				"<leader>ghj",
				function()
					gs.nav_hunk()
				end,
				desc = "Next Hunk",
			},
			{ "<leader>grb", gs.reset_hunk, desc = "Reset Hunk" },
			{ "<leader>grf", gs.reset_buffer, desc = "Reset Buffer" },
			{
				"<leader>gab",
				mode = "v",
				function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				desc = "Stage Hunk",
			},
			{
				"<leader>grb",
				mode = "v",
				function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end,
				desc = "Reset Hunk",
			},
		}
	end,
}
