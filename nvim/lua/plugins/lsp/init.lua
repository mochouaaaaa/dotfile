return {
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		config = function()
			require("lsp-endhints").setup({
				icons = {
					type = "󰜁 ",
					parameter = "󰏪 ",
					offspec = " ", -- hint kind not defined in official LSP spec
					unknown = " ", -- hint kind is nil
				},
				label = {
					padding = 1,
					marginLeft = 0,
					bracketedParameters = true,
				},
				autoEnableHints = true,
			})
		end,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			local actions_preview = require("actions-preview")
			local hl = require("actions-preview.highlight")

			actions_preview.setup({
				diff = {
					algorithm = "patience",
					ignore_whitespace = true,
					ctxlen = 5, -- 多给一点上下文
				},
				highlight_command = {
					hl.delta("delta --no-gitconfig --side-by-side"),
					hl.diff_so_fancy("diff-so-fancy", "less -R"),
					hl.diff_highlight(),
				},
				backend = { "snacks", "nui" },
			})
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		branch = "main",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		ft = "python", -- Load when opening Python files
		keys = function()
			return {
				-- Keymap to open VenvSelector to pick a venv.
				{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Open VenvSelector" },
			}
		end,
		opts = { -- this can be an empty lua table - just showing below for clarity.
			search = {}, -- if you add your own searches, they go here.
			options = {
				debug = true,
				picker = "fzf-lua",
			}, -- if you add plugin options, they go here.
		},
	},
	{ import = "plugins.lsp.extra" },
}
