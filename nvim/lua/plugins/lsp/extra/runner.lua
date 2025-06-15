return {
	"CRAG666/code_runner.nvim",
	config = function()
		local code_runner = require("code_runner")

		local config_path = vim.fn.stdpath("config") .. "/lua/code_runner/"

		code_runner.setup({
			filetype_path = vim.fn.expand(config_path .. "code_runner.json"),
			project_path = vim.fn.expand(config_path .. "project_config.json"),
		})
	end,
	keys = {
		{
			"<leader>rc",
			":RunFile<CR>",
			desc = "Run code",
		},
	},
}
