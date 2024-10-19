return {
	{
		"jvgrootveld/telescope-zoxide", -- powerful cd
		lazy = true,
		keys = {
			{ "<leader>cd", "<cmd>Telescope zoxide list<cr>", desc = " Cd recently directory" },
		},
	},
	{
		"AckslD/nvim-neoclip.lua",
		event = "TextYankPost",
		lazy = true,
		keys = {
			{ "<leader><C-p>", "<Cmd>Telescope neoclip<cr>", desc = "Clipboard History" },
			{ "<leader>P", "<Cmd>Telescope neoclip unnamed<cr>", desc = "Clipboard History for system" },
		},
		dependencies = "kkharji/sqlite.lua",
		version = false,
		opts = {
			history = 500,
			enable_persistent_history = true,
			enable_macro_history = false,
			keys = {
				telescope = {
					i = {
						select = "<cr>",
						paste = "<c-o>",
						paste_behind = "<c-p>",
						replay = "<c-r>", -- replay a macro
						delete = "<c-d>", -- delete an entry
					},
					n = {
						select = "<cr>",
						paste = "p",
						paste_behind = "P",
						replay = "r",
						delete = "d",
					},
				},
			},
		},

		config = function(_, opts)
			require("neoclip").setup(opts)
			require("telescope").load_extension("neoclip")
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		opts = {
			detection_methods = { "lsp", "pattern" },
			patterns = {
				".git",
				".vscode",
				".svn",
				".idea",
				"package.json",
				"Makefile",
				">manage.py",
				"Cargo.toml",
			},
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)

			require("telescope").load_extension("projects")
		end,
		keys = {
			{
				"<leader>fp",
				-- function() require("telescope").extensions.projects.projects() end,
				"<Cmd>Telescope projects<CR>",
				desc = "find projects",
			},
		},
	},
	{
		"goolord/alpha-nvim",
		optional = true,
		opts = function(_, dashboard)
			local button = dashboard.button("p", " " .. " Projects", ":Telescope projects <CR>")
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
			table.insert(dashboard.section.buttons.val, 4, button)
		end,
	},
}
