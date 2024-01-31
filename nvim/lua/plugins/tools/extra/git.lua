return {
	{
		"kdheepak/lazygit.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = {
			{ "nvim-telescope/telescope.nvim", lazy = true },
			{ "nvim-lua/plenary.nvim", lazy = true },
			{ "sindrets/diffview.nvim", lazy = true },
		},
		enabled = vim.fn.executable("git") == 1,
		config = function()
			local Util = require("lazyvim.util")
			Util.on_load("telescope.nvim", function() require("telescope").load_extension("lazygit") end)
		end,
		keys = {
			{
				"<leader>gg",
				"<cmd>LazyGit<CR>",
				desc = "git manager",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		lazy = true,
		opts = {
			plugins = { splling = true },
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local gs = package.loaded.gitsigns

				local wk = require("which-key")
				local keys = {
					["<leader>g"] = {
						name = "Git Manager",
						p = {
							function() gitsigns.preview_hunk() end,
							"Preview hunk",
						},
						r = { gs.reset_hunk, "Revert hunk" },
						U = {

							gs.undo_stage_hunk,
							"Undo stage file",
						},
						["["] = {
							function()
								if vim.wo.diff then
									return "g["
								end
								vim.schedule(function() gs.prev_hunk() end)
								return "<Ignore>"
							end,
							"Previous hunk",
						},
						["]"] = {
							function()
								if vim.wo.diff then
									return "g]"
								end
								vim.schedule(function() gs.next_hunk() end)
								return "<Ignore>"
							end,
							"Next hunk",
						},
					},
				}
				local visual = {
					["<leader>g"] = {
						a = {
							function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
							"Stage hunk",
						},
						r = {
							function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
							"undo reset hunk",
						},
					},
				}
				wk.register(keys, { bufnr = bufnr })
				wk.register(visual, { mode = "v" })
			end,

			signs = {
				add = {
					text = "+",
				},
				change = {
					text = "~",
				},
				delete = {
					text = "_",
				},
				topdelete = {
					text = "‾",
				},
				changedelete = {
					text = "~",
				},
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
			current_line_blame_formatter_opts = { relative_time = true },
			current_line_blame_formatter = "      <author>, <author_time:%R> - <summary>",
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
			yadm = { enable = false },
		},
	},
}
