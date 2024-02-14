return {
	{
		"kdheepak/lazygit.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = {
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
						a = {
							name = "add",
							b = {
								gs.stage_hunk,
								"hunk",
							},
							f = {
								gs.stage_buffer,
								"file",
							},
						},
						t = {
							name = "toggle",
							h = {
								function() gs.diffthis("~") end,
								"diff file",
							},
							d = {
								gs.toggle_deleted,
								"deleted",
							},
						},
						h = {
							name = "hunk",
							p = {
								function() gitsigns.preview_hunk() end,
								"preview ",
							},
							k = {
								function()
									if vim.wo.diff then
										return "g["
									end
									vim.schedule(function() gs.prev_hunk() end)
									return "<Ignore>"
								end,
								"previous",
							},
							j = {
								function()
									if vim.wo.diff then
										return "g]"
									end
									vim.schedule(function() gs.next_hunk() end)
									return "<Ignore>"
								end,
								"next",
							},
						},
						r = {
							name = "undo",
							b = { gs.reset_hunk, "revert hunk" },
							f = {

								gs.reset_buffer_index,
								"stage file",
							},
						},
					},
				}
				local visual = {
					["<leader>g"] = {
						a = {
							name = "add",
							b = {
								function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
								"stage hunk",
							},
						},
						r = {
							name = "undo",
							b = {
								function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
								"reset hunk",
							},
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
			current_line_blame_formatter_opts = { relative_time = true },
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
			yadm = { enable = false },
		},
	},
	{
		"pwntester/octo.nvim",
		config = function() require("octo").setup() end,
	},
}
