return {
	"rebelot/heirline.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		{ "SmiteshP/nvim-navic", opts = true },
		{
			"jonahgoldwastaken/copilot-status.nvim",
			dependencies = { "copilot.lua" }, -- or "zbirenbaum/copilot.lua"
			event = "UiEnter",
		},
	},
	event = "UiEnter",
	enabled = false,
	config = function()
		heirline = require("heirline")
		functions = require("plugins.configs.heirline").setup()

		local filename_block = functions.FileManager.NameBlock
		file_icon = utils.insert(functions.FileManager.NameBlock, functions.FileManager.Icon)

		heirline.setup {
			statusline = {
				-- left
				{
					functions.Space,
					functions.ViMode,
					functions.Space,
					functions.GitManager.Branch,
				},
				functions.Align,
				-- center
				{
					{
						init = function(self) self.cop = require("copilot_status").setup {} end,
						condition = require("copilot_status").enabled(),
						provider = require("copilot_status").status_string(),
					},
				},
				functions.Align,
				-- right
				{
					functions.FileManager.Size,
					functions.Space,
					file_icon,
					-- functions.Space,
					{ provider = "•" },
					functions.FileManager.Type,
					functions.Space,
					functions.FileManager.Encoding,
					functions.Space,
					functions.FileManager.Format,
					functions.Space,
					functions.BarManager.Ruler,
					functions.Space,
					functions.BarManager.Scroll,
					functions.Space,
				},
			},
			winbar = {
				-- left
				functions.Space,

				{
					functions.LSPManager.Navic,
				},
				functions.Align,
				-- center
				-- fallthrough = false,
				{
					functions.LSPManager.Active,
				},
				-- functions.Align,
				-- right
				{
					functions.Space,
					functions.TerminalManager.Memory,
					functions.Space,
				},
			},
			-- tabline = TabLine,
			-- statuscolumn = StatusColumn,
			opts = {
				disable_winbar_cb = function(args)
					return conditions.buffer_matches({
						buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
						filetype = { "NvimTree", "neo%-tree", "nvim-lsp", "dashboard", "Outline", "aerial" },
					}, args.buf)
				end,
			}, -- other config parameters, see below
		}
	end,
}
